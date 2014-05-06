//
//  ContentManager.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ContentManager.h"
#import "APIManager.h"
#import "LoginViewController.h"
#import "Bike.h"

NSString *const ContentManagerDidAuthenticateUserNotification = @"ContentManagerDidAuthenticateUserNotification";
NSString *const ContentManagerWillAuthenticateUserNotification = @"ContentManagerWillAuthenticateUserNotification";
NSString *const ContentManagerDidChangeUsingBikeNotification = @"ContentManagerDidChangeUsingBikeNotification";

NSString *const KeychainUserName = @"KeychainUserName";
NSString *const KeychainUserPassword = @"KeychainUserPassword";

@implementation ContentManager {
    NSOperation *_loginOperation;
    NSOperation *_bikesOperation;
    NSOperation *_bikeStateOperation;
    NSOperation *_returnOperation;
    NSOperation *_borrowOperation;
    
    struct {
        unsigned int authenticating:1;
    } _flags;
}

+ (instancetype)manager {
	static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc] init];
    });
    
	return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Accessors

- (BOOL)isLogged {
    return ([APIManager manager].accessToken != nil);
}

- (BOOL)isAuthenticating {
    return _flags.authenticating;
}

- (void)setUsingBike:(Bike *)usingBike {
    _usingBike = usingBike;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidChangeUsingBikeNotification object:self userInfo:nil];
    });
}

#pragma mark - Login / Logout methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    _flags.authenticating = 1;
    [self setKeychainObject:username forKey:KeychainUserName];
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerWillAuthenticateUserNotification object:self];
    
    __weak typeof(self)weakSelf = self;
    [_loginOperation cancel];
    _loginOperation = [[APIManager manager] POST:@"accounts/mine/login" parameters:@{@"username": username, @"password": password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            [APIManager manager].accessToken = responseObject[@"apiKey"];
            [weakSelf setKeychainObject:[[password dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0] forKey:KeychainUserPassword];
            
            [weakSelf bikeStateWithCompletion:^(Bike *bike, NSError *error) {
                if (error && error.statusCode != 404) {
                    [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"TabBarController"]];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:weakSelf userInfo:nil];
                    
                    if (completion) {
                        completion(nil);
                    }
                });
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([error message:operation.responseString]);
        }
        [weakSelf removeKeychainObjectForKey:KeychainUserPassword];
    }];
}

- (void)logout {
    [APIManager manager].accessToken = nil;
    _bikesUpdateDate = nil;
    
    [self removeKeychainObjectForKey:KeychainUserPassword];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:self userInfo:nil];
    });
}

#pragma mark - Bikes methods

- (void)bikesWithLocation:(CLLocationCoordinate2D)location completion:(void (^)(NSArray *bikes, NSError *error))completion {

    [_bikesOperation cancel];
    
    __weak __typeof(self)weakSelf = self;
    _bikesOperation = [[APIManager manager] GET:[NSString stringWithFormat:@"bikes/all?lat=%f&lng=%f",location.latitude, location.longitude] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSMutableArray *bikes = @[].mutableCopy;
            NSArray *data = responseObject;
            [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [bikes addObject:[[Bike alloc] initWithDictionary:obj]];
            }];
            
            if (bikes.count > 0) {
                strongSelf->_bikesUpdateDate = [[NSDate date] dateByAddingTimeInterval:5 * 60];
            }
            strongSelf->_bikes = bikes;
            
            if (completion) {
                completion(strongSelf->_bikes, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, [error message:operation.responseString]);
        }
    }];
}

- (void)bikeStateWithCompletion:(void (^)(Bike *bike, NSError *error))completion {
    
    [_bikeStateOperation cancel];
    
    __weak __typeof(self)weakSelf = self;
    _bikeStateOperation = [[APIManager manager] GET:@"bikes/mine" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            weakSelf.usingBike = [[Bike alloc] initWithDictionary:responseObject];
            if (completion) {
                completion(weakSelf.usingBike, nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, [error message:operation.responseString]);
        }
    }];
}

- (void)borrowBikeWithCode:(NSString *)code location:(CLLocationCoordinate2D)location completion:(void (^)(NSString *code, NSError *error))completion {
    NSParameterAssert(code);
    
    [_borrowOperation cancel];
    __weak __typeof(self)weakSelf = self;
    _borrowOperation = [[APIManager manager] GET:[NSString stringWithFormat:@"bikes/lock-code?bikeCode=%@",code] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            Bike *bike = [[Bike alloc] initWithDictionary:responseObject[@"bike"]];
            bike.lockCode = responseObject[@"lockCode"];
            weakSelf.usingBike = bike;
            weakSelf.bikesUpdateDate = nil;
            
            if (completion) {
                completion(bike.lockCode,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, [error message:operation.responseString]);
        }
    }];
}

- (void)returnBike:(Bike *)bike location:(CLLocation *)location note:(NSString *)note completion:(void (^)(NSError *error))completion {
    NSParameterAssert(bike);
    
    NSDictionary *loc = @{
                            @"lat": @(location.coordinate.latitude),
                            @"lng": @(location.coordinate.longitude),
                            @"note": note ?: @""
                         };
    
    NSDictionary *params = @{
                             @"location": loc
                            };
    
    [_returnOperation cancel];
    
    __weak __typeof(self)weakSelf = self;
    _returnOperation = [[APIManager manager] PUT:[NSString stringWithFormat:@"bikes/%@/return",[bike.identifier stringValue]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (weakSelf) {
            if (completion) {
                completion(nil);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion([error message:operation.responseString]);
        }
    }];
}

- (BOOL)updateTime {
    BOOL result = YES;
    if (_bikesUpdateDate != nil) {
        result = [_bikesUpdateDate compare:[NSDate date]] != NSOrderedDescending;
    } else {
        _bikesUpdateDate = [NSDate date];
    }
    return result;
}

- (BOOL)isLocationServiceAuthorized {
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
		case kCLAuthorizationStatusAuthorized:
		case kCLAuthorizationStatusNotDetermined:
			return YES;
            
		case kCLAuthorizationStatusDenied:
		case kCLAuthorizationStatusRestricted: {
			return NO;
		}
		default:
			NSLog (@"LocationService: Unknown status %d", status);
			return NO;
	}
}

@end

@implementation ContentManager (Keychain)

- (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return @{ (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService: key,
              (__bridge id)kSecAttrAccount: key,
              (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock }.mutableCopy;
}

- (void)setKeychainObject:(id)anObject forKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (anObject) {
        query[(__bridge id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:anObject];
        SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
}

- (void)removeKeychainObjectForKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    SecItemDelete((__bridge CFDictionaryRef)query);
}

- (id)keychainObjectForKey:(NSString *)aKey {
    NSParameterAssert(aKey);
    
    id value = nil;
    NSMutableDictionary *query = [self keychainQueryForKey:aKey];
    CFDataRef data = NULL;
    
    query[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    query[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&data) == noErr) {
        @try {
            value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)data];
        }
        @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", aKey, e);
        }
    }
    
    if (data) {
        CFRelease(data);
    }
    
    return value;
}

@end

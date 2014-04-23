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

NSString *const ContentManagerDidAuthenticateUserNotification = @"ContentManagerDidAuthenticateUserNotification";
NSString *const ContentManagerWillAuthenticateUserNotification = @"ContentManagerWillAuthenticateUserNotification";

NSString *const KeychainUserName = @"KeychainUserName";
NSString *const KeychainUserPassword = @"KeychainUserPassword";

@implementation ContentManager {
    NSOperation *_loginOperation;
    
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

#pragma mark - Login / Logout methods

- (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(NSError *error))completion {
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    _flags.authenticating = 1;
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerWillAuthenticateUserNotification object:self];
    
    __weak typeof(self)weakSelf = self;
    [_loginOperation cancel];
    _loginOperation = [[APIManager manager] POST:@"/accounts/mine/login" parameters:@{@"username": username, @"password": password} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [APIManager manager].accessToken = responseObject[@"apiKey"];
        [weakSelf setKeychainObject:username forKey:KeychainUserName];
        completion(nil);
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"MapViewController"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:weakSelf userInfo:nil];
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(error);
    }];
}

- (void)logout {
    [APIManager manager].accessToken = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[[[UIApplication sharedApplication] windows] firstObject] setRootViewController:[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:self userInfo:nil];
    });
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

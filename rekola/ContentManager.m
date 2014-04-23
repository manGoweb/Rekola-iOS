//
//  ContentManager.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ContentManager.h"
#import "APIManager.h"

NSString *const ContentManagerDidAuthenticateUserNotification = @"ContentManagerDidAuthenticateUserNotification";
NSString *const ContentManagerWillAuthenticateUserNotification = @"ContentManagerWillAuthenticateUserNotification";
NSString *const ContentManagerDidLogoutUserNotification = @"ContentManagerDidLogoutUserNotification";

@implementation ContentManager {
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

- (void)autologin {
    if (![APIManager manager].accessToken) {
        return;
    }
    
    //__weak typeof(self)weakSelf = self;
    _flags.authenticating = 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerWillAuthenticateUserNotification object:self];
    
    // TODO: login
    //[[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:weakSelf userInfo:nil];
}

- (void)logout {
    [[APIManager manager] setAccessToken:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ContentManagerDidAuthenticateUserNotification object:self userInfo:nil];
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

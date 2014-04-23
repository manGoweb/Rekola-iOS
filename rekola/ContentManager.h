//
//  ContentManager.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentManager : NSObject

@property (nonatomic, assign, readonly, getter = isLogged) BOOL logged;
@property (nonatomic, assign, readonly, getter = isAuthenticating) BOOL authenticating;

+ (instancetype)manager;

- (void)autologin;
- (void)logout;

@end

@interface ContentManager (Keychain)

- (void)setKeychainObject:(id)anObject forKey:(NSString *)aKey;
- (void)removeKeychainObjectForKey:(NSString *)aKey;
- (id)keychainObjectForKey:(NSString *)aKey;

@end

extern NSString *const ContentManagerDidAuthenticateUserNotification;
extern NSString *const ContentManagerWillAuthenticateUserNotification;
extern NSString *const ContentManagerDidLogoutUserNotification;

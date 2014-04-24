//
//  ContentManager.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bike.h"

@interface ContentManager : NSObject

@property (nonatomic, assign, readonly, getter = isLogged) BOOL logged;
@property (nonatomic, assign, readonly, getter = isAuthenticating) BOOL authenticating;
@property (nonatomic, strong) Bike *usingBike;

+ (instancetype)manager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSError *error))completion;

- (void)changePassword:(NSString *)password
            completion:(void (^)(NSError *error))completion;

- (void)logout;

- (void)bikeStateWithCompletion:(void (^)(Bike *bike, NSError *error))completion;

- (void)bikesWithLocation:(CLLocationCoordinate2D)location
               completion:(void (^)(NSArray *bikes, NSError *error))completion;

- (void)borrowBike:(Bike *)bike
          location:(CLLocationCoordinate2D)location
        completion:(void (^)(NSString *code, NSError *error))completion;

- (void)returnBike:(Bike *)bike
          location:(CLLocationCoordinate2D)location
              note:(NSString *)note
        completion:(void (^)(NSError *error))completion;

@end

@interface ContentManager (Keychain)

- (void)setKeychainObject:(id)anObject forKey:(NSString *)aKey;
- (void)removeKeychainObjectForKey:(NSString *)aKey;
- (id)keychainObjectForKey:(NSString *)aKey;

@end

extern NSString *const ContentManagerDidAuthenticateUserNotification;
extern NSString *const ContentManagerWillAuthenticateUserNotification;
extern NSString *const ContentManagerDidChangeUsingBikeNotification;

extern NSString *const KeychainUserName;
extern NSString *const KeychainUserPassword;

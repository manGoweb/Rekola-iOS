/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import <Foundation/Foundation.h>
#import "Bike.h"

@interface ContentManager : NSObject

@property (nonatomic, assign, readonly, getter = isLogged) BOOL logged;
@property (nonatomic, assign, readonly, getter = isAuthenticating) BOOL authenticating;
@property (nonatomic, strong) Bike *usingBike;

@property (nonatomic, strong, readonly) NSArray *bikes;
@property (nonatomic, strong) NSDate *bikesUpdateDate;

+ (instancetype)manager;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               completion:(void (^)(NSError *error))completion;

- (void)recoverPassword:(NSString *)username completion:(void (^)(NSError *error))completion;

- (BOOL)updateTime;
- (BOOL)isLocationServiceAuthorized;

- (void)logout;

- (void)bikeStateWithCompletion:(void (^)(Bike *bike, NSError *error))completion;

- (void)bikesWithLocation:(CLLocationCoordinate2D)location
               completion:(void (^)(NSArray *bikes, NSError *error))completion;

- (void)POIsWithLocation:(CLLocationCoordinate2D)location
               completion:(void (^)(NSArray *pois, NSError *error))completion;

- (void)borrowBikeWithCode:(NSString *)code
          location:(CLLocationCoordinate2D)location
        completion:(void (^)(NSString *code, NSError *error))completion;

- (void)returnBike:(Bike *)bike
          location:(CLLocation *)location
              note:(NSString *)note
        completion:(void (^)(NSString *successUrl, NSError *error))completion;

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

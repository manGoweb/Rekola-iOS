/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

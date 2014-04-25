//
//  RKLocationManager.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKLocationManager : NSObject

@property (nonatomic, assign) CLLocation *currentLocation;

+ (instancetype)manager;

- (void)startTracking;
- (void)startUpdateHeading;
- (void)stopTracking;
- (void)stopUpdateHeading;
- (BOOL)isAuthorized;

@end

extern NSString *const RKLocationManagerDidChangeUserLocationNotification;
extern NSString *const RKLocationManagerDidChangeAuthorizationStatusNotification;

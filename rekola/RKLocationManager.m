//
//  RKLocationManager.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "RKLocationManager.h"

NSString *const RKLocationManagerDidChangeUserLocationNotification = @"RKLocationManagerDidChangeUserLocationNotification";
NSString *const RKLocationManagerDidChangeAuthorizationStatusNotification = @"RKLocationManagerDidChangeAuthorizationStatusNotification";

@interface RKLocationManager () <CLLocationManagerDelegate>
@end

@implementation RKLocationManager {
    CLLocationManager *_locationManager;
	CLLocation *_lastKnownLocation;
	CLHeading *_currentHeading;
    
    BOOL _shouldStart;
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
        _locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.headingOrientation = CLDeviceOrientationPortrait;
    }
    return self;
}

#pragma mark - Accessors

- (BOOL)isEnabled {
	return [CLLocationManager locationServicesEnabled];
}


- (BOOL)isAvailable {
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}


- (BOOL)isHeadingAvailable {
	return [CLLocationManager headingAvailable];
}

#pragma mark - Public methods

- (void)startTracking {
	[_locationManager startUpdatingLocation];
    _shouldStart = ![self isAvailable];
}

- (void)startUpdateHeading {
    [_locationManager startUpdatingHeading];
}

- (void)stopTracking {
    
    if ([self isAvailable]) {
        [_locationManager stopUpdatingLocation];
    }

    _shouldStart = NO;
	_currentHeading = nil;
	_currentLocation = nil;
}

- (void)stopUpdateHeading {
    [_locationManager stopUpdatingHeading];
    _currentHeading = nil;
}

- (BOOL)isAuthorized {
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

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *latestLocation = [locations lastObject];
    
    if ([latestLocation.timestamp timeIntervalSinceNow] < 5 && latestLocation.horizontalAccuracy > 0 && (_currentLocation == nil || _currentLocation.horizontalAccuracy > latestLocation.horizontalAccuracy)) {
        _currentLocation = latestLocation;
        _lastKnownLocation = latestLocation;
        
        if (_currentLocation.horizontalAccuracy <= _locationManager.desiredAccuracy) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RKLocationManagerDidChangeUserLocationNotification object:nil];
          // TODO:
            [self stopTracking];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	// NSLog(@"LocationManager: manager did fail with error: %@", error);
	
	_currentLocation = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	_currentHeading = newHeading;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    _currentHeading = nil;
	_currentLocation = nil;
    
	if (_shouldStart) {
		[self startTracking];
	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RKLocationManagerDidChangeAuthorizationStatusNotification object:nil];
}


@end

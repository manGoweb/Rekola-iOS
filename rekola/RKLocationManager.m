//
//  RKLocationManager.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "RKLocationManager.h"

NSString *const RKLocationManagerDidChangeUserLocationNotification = @"RKLocationManagerDidChangeUserLocationNotification";

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
        _locationManager.distanceFilter = kCLDistanceFilterNone;
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
	
    if (latestLocation.horizontalAccuracy >= 100) {
        _currentLocation = latestLocation;
        _lastKnownLocation = latestLocation;
        
        NSLog(@"Location: lat:%f lng:%f",_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RKLocationManagerDidChangeUserLocationNotification object:nil];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"LocationManager: manager did fail with error: %@", error);
	
	_currentLocation = nil;
    // TODO: report
	//[self reportChangeToDelegates:YES];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	_currentHeading = newHeading;
    
    // TODO: report
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
	if (_shouldStart) {
		[self startTracking];
	}
    // TODO: report
}


@end

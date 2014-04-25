//
//  MapViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "MapViewController.h"

static CGFloat DefaultLatitude = 50.079167;
static CGFloat DefaultLongtitude = 14.428414;
static CGFloat DefaultUserZoom = 500;
static CGFloat DefaultDistance = 3500;

@implementation MapViewController {
    NSArray *_bikes;
    
    struct {
        unsigned int firtstUpdate:1;
        unsigned int firstLaunch:1;
    } _flags;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKLocationManagerDidChangeUserLocationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flags.firstLaunch = 1;
    _flags.firtstUpdate = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationDidUpdate) name:RKLocationManagerDidChangeUserLocationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAuthorizationStatus) name:RKLocationManagerDidChangeAuthorizationStatusNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_flags.firstLaunch == 1) {
        _flags.firstLaunch = 0;
        
        if ([[RKLocationManager manager] isAuthorized]) {
            [[RKLocationManager manager] startTracking];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
            
            [self zoomToDefaultLocation];
        }
        
        _mapView.showsUserLocation = YES;
        [self reloadData];
    }
}

- (void)reloadData {
    __weak __typeof(self)weakSelf = self;
        //@"/bikes?lat=50.071667&lng=14.433804"
    [[ContentManager manager] bikesWithLocation:CLLocationCoordinate2DMake(50.071667, 14.433804) completion:^(NSArray *bikes, NSError *error) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_bikes = bikes;
            [strongSelf->_mapView addAnnotations:bikes];
        }
    }];
}

#pragma mark - Private methods

-(void)zoomToDefaultLocation {

    CLLocationCoordinate2D zoomLocation = [[[CLLocation alloc] initWithLatitude:DefaultLatitude longitude:DefaultLongtitude] coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, DefaultDistance, DefaultDistance);
    [_mapView setRegion:viewRegion animated:YES];
}

#pragma mark - RKLocationManager Notifications

- (void)didChangeAuthorizationStatus {
    if ([RKLocationManager manager].isAuthorized) {
        [[RKLocationManager manager] startTracking];
    }
}

#pragma mark - MapKitDelegate methods

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    NSLog(@"boom");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_flags.firtstUpdate == 1) {
        _flags.firtstUpdate = 0;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, DefaultUserZoom, DefaultUserZoom);
        [_mapView setRegion:region animated:YES];
    }
}

@end

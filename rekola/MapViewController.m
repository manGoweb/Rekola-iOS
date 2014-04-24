//
//  MapViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "MapViewController.h"

static CGFloat DefaultLatitude = 50.07553864;
static CGFloat DefaultLongtitude = 14.43780041;
static CGFloat DefaultDistance = 400;

@implementation MapViewController {
    NSArray *_bikes;
    
    BOOL _firstUpdate;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKLocationManagerDidChangeUserLocationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationDidUpdate) name:RKLocationManagerDidChangeUserLocationNotification object:nil];
    
    _mapView.showsUserLocation = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[RKLocationManager manager] isAuthorized]) {
        [[RKLocationManager manager] startTracking];
        [self reloadData];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        
        [self zoomToDefaultLocation];
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

- (void)userLocationDidUpdate {

}

#pragma mark - MapKitDelegate methods

//- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
//// //   NSLog(@"boom");
//////    MKAnnotationView *annotationView = [views firstObject];
//////    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationView.annotation.coordinate, 250, 250);
//////    [mv setRegion:region animated:YES];
//}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  //  [self zoomToDefaultLocation];
    NSLog(@"didUpdateUserLocation fired!");
    [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
//    [_mapView addAnnotations:_bikes];
//  
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250);
//    [_mapView setRegion:region animated:YES];
}

@end

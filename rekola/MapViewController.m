//
//  MapViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController {
    NSArray *_bikes;
    CLLocationManager *_locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _mapView.showsUserLocation = YES;
    
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] bikesWithLocation:CLLocationCoordinate2DMake(0, 0) completion:^(NSArray *bikes, NSError *error) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf->_bikes = bikes;
            [weakSelf reloadData];
        }
    }];
}

- (void)reloadData {

}

#pragma mark - MapKitDelegate methods

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    NSLog(@"boom");
    MKAnnotationView *annotationView = [views firstObject];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(annotationView.annotation.coordinate, 250, 250);
    [mv setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {

    NSLog(@"didUpdateUserLocation fired!");
        [_mapView addAnnotations:_bikes];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250);
    [_mapView setRegion:region animated:YES];
}

@end

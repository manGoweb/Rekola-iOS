//
//  LocateViewController.m
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

static CGFloat DefaultUserZoom = 2500;

#import "LocateViewController.h"

@implementation LocateViewController {
    struct {
        unsigned int firtstUpdate:1;
    } _flags;
    
    CLLocationCoordinate2D _newLocation;
    Bike *_userBike;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _flags.firtstUpdate = 1;
    _doneButton.enabled = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [_mapView addGestureRecognizer:tapGesture];
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:)]) {
        [_delegate performSelector:@selector(controller:didFinishWithLocation:) withObject:self withObject:nil];
    }
}

- (IBAction)done:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:)]) {
        [_delegate performSelector:@selector(controller:didFinishWithLocation:) withObject:self withObject:[[CLLocation alloc] initWithLatitude:_newLocation.latitude longitude:_newLocation.longitude]];
    }
}

#pragma mark - UIGestureRecognizer methods

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (_flags.firtstUpdate == 0) {
        if (tapGesture.state == UIGestureRecognizerStateRecognized) {
            [_mapView removeAnnotation:_userBike];
            
            CGPoint touchPoint = [tapGesture locationInView:_mapView];
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
            _userBike.coordinate = coordinate;

            [_mapView addAnnotation:_userBike];
        }
    }
}

#pragma mark - MKMapKitDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *BikeAnnotationViewIdentifier = @"BikeAnnotationViewIdentifier";
    MKAnnotationView *retPinView = nil;
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        // Single pin
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:BikeAnnotationViewIdentifier];
        
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BikeAnnotationViewIdentifier];
            
            pinView.draggable = YES;
            pinView.canShowCallout = YES;
            pinView.pinColor = MKPinAnnotationColorRed;
            
        } else {
            pinView.annotation = annotation;
        }
        
        retPinView = pinView;
    }
    return retPinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding) {
//        CLGeocoder *geocoder = [CLGeocoder new];
        _newLocation = annotationView.annotation.coordinate;
//        [geocoder reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:_newLocation.latitude longitude:_newLocation.longitude] completionHandler:^(NSArray *placemarks, NSError *error) {
//            NSLog(@"Searching..");
//            if (!error) {
//                CLPlacemark *placemark = [placemarks lastObject];
//                NSLog(@"%@",[NSString stringWithFormat:@"%@", placemark.thoroughfare]);
//            } else {
//                NSLog(@"%@",error.localizedDescription);
//            }
//        }];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_flags.firtstUpdate == 1) {
        _flags.firtstUpdate = 0;
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, DefaultUserZoom, DefaultUserZoom);
        [_mapView setRegion:region animated:YES];
        
        _userBike = [Bike new];
        _userBike.title = NSLocalizedString(@"Your Bike", nil);
        _userBike.coordinate = userLocation.coordinate;
        _newLocation = userLocation.coordinate;
        
        [_mapView addAnnotation:_userBike];
        _doneButton.enabled = YES;
    }
}

@end

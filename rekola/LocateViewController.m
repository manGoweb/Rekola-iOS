//
//  LocateViewController.m
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "LocateViewController.h"

@implementation LocateViewController {
    struct {
        unsigned int firtstUpdate:1;
    } _flags;
    
    NSString *_textViewText;
    CLLocationCoordinate2D _newLocation;
    MKUserTrackingBarButtonItem *_trackingButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _flags.firtstUpdate = 1;
    
    _trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    _navBarItem.rightBarButtonItem = _trackingButton;
    
    _returnBikeButton.enabled = NO;
    
    _textView.layer.borderColor = COLOR(0xAAAAAA).CGColor;
    _textView.layer.borderWidth = 1;
    _textViewText = @"";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    if (![[ContentManager manager] isLocationServiceAuthorized]) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        
        [self zoomToDefaultLocation];
    }
    
    _returnBikeButton.enabled = YES;
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:note:)]) {
        [_delegate controller:self didFinishWithLocation:nil note:nil];
    }
}

- (IBAction)done:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:note:)]) {
        [_delegate controller:self didFinishWithLocation:[[CLLocation alloc] initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude] note:_textViewText];
    }
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.text = @"";
    textView.textColor = [UIColor RKPinkColor];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Comment";
        
    } else {
        _textViewText = textView.text;
    }
}

#pragma mark - Private methods

- (void)zoomToDefaultLocation {
    CLLocationCoordinate2D zoomLocation = [[[CLLocation alloc] initWithLatitude:DefaultLatitude longitude:DefaultLongtitude] coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, DefaultDistance, DefaultDistance);
    [_mapView setRegion:viewRegion animated:YES];
}

#pragma mark - MKMapKitDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_flags.firtstUpdate == 1) {
        _flags.firtstUpdate = 0;
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, DefaultUserZoom / 4, DefaultUserZoom / 4);
        [_mapView setRegion:region animated:NO];
    }
}

@end

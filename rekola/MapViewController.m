//
//  MapViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "MapViewController.h"
#import "RKAnnotation.h"

static CGFloat DefaultLatitude = 50.079167;
static CGFloat DefaultLongtitude = 14.428414;
static CGFloat DefaultUserZoom = 2500;
static CGFloat DefaultDistance = 3500;

@implementation MapViewController {
    MKUserTrackingBarButtonItem *_trackingButton;
    MKPolyline *_routePolyline;
    
    struct {
        unsigned int firtstUpdate:1;
        unsigned int firstLaunch:1;
        unsigned int loadingData:1;
    } _flags;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Title in nav & tab controller");
        self.navigationController.tabBarItem.title = self.title;
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RKLocationManagerDidChangeAuthorizationStatusNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = _trackingButton;
    
    _flags.firtstUpdate = 1;
    _flags.firstLaunch = 1;
    _mapView.clusteringEnabled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeAuthorizationStatus) name:RKLocationManagerDidChangeAuthorizationStatusNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
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
    }
}

- (void)reloadData {
    
    if (_flags.loadingData != 1 && [[ContentManager manager] updateTime]) {
        _flags.loadingData = 1;
        
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikesWithLocation:([RKLocationManager manager].currentLocation != nil)? [RKLocationManager manager].currentLocation.coordinate : CLLocationCoordinate2DMake(DefaultLatitude, DefaultLongtitude) completion:^(NSArray *bikes, NSError *error) {
            if (weakSelf) {
                if (!error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    NSMutableArray *annotations = @[].mutableCopy;
                    [bikes enumerateObjectsUsingBlock:^(Bike *obj, NSUInteger idx, BOOL *stop) {
                        [annotations addObject:[[RKAnnotation alloc] initWithAnnotation:obj]];
                    }];
                    
                    [strongSelf->_mapView clearAnnotations];
                    [strongSelf->_mapView addAnnotations:annotations];
                    strongSelf->_flags.loadingData = 0;
                } else {
                   // [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                }
            }
        }];
    }
}

#pragma mark - Actions

- (IBAction)zoomToUserLocation:(id)sender {
    if ([RKLocationManager manager].currentLocation) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([RKLocationManager manager].currentLocation.coordinate, DefaultUserZoom, DefaultUserZoom);
        [_mapView setRegion:region animated:YES];
    }
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

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    [_mapView clusterAnnotations];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    if ([view.annotation isKindOfClass:[Bike class]]) {
        [self performSegueWithIdentifier:@"BikeDetailSegue" sender:nil];
    }
    
//    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
//    
//    request.source = [MKMapItem mapItemForCurrentLocation];
//
//    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:view.annotation.coordinate addressDictionary:nil]];
//    request.destination = destination;
//    request.transportType = MKDirectionsTransportTypeWalking;
//    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
//    // distance / expectedTraveltime - seconds
//    [directions calculateDirectionsWithCompletionHandler:
//     ^(MKDirectionsResponse *response, NSError *error) {
//         if (error) {
//             // TODO:
//             // Handle Error
//         } else {
//             [self showRoute:[response.routes firstObject]];
//         }
//     }];
}

-(void)showRoute:(MKRoute *)route {
    if (_routePolyline) {
        [_mapView removeOverlay:_routePolyline];
    }
    
    _routePolyline = route.polyline;
    [_mapView addOverlay:_routePolyline];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.;
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *BikeAnnotationViewIdentifier = @"BikeAnnotationViewIdentifier";
    static NSString *ClusterAnnotationViewIdentifier = @"ClusterAnnotationViewIdentifier";
    MKAnnotationView *retPinView = nil;
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        if ([annotation isKindOfClass:[RKAnnotation class]]) {
            MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ClusterAnnotationViewIdentifier];
            
            if (!pinView) {
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ClusterAnnotationViewIdentifier];
                pinView.canShowCallout = NO;
            }
            
            // set title
            pinView.pinColor = MKPinAnnotationColorGreen;
            retPinView = pinView;
            
            // Single pin
        } else {
            MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:BikeAnnotationViewIdentifier];
            
            if (!pinView) {
                pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BikeAnnotationViewIdentifier];
                
                pinView.canShowCallout = YES;
                pinView.pinColor = MKPinAnnotationColorPurple;
                
                // Add a detail disclosure button to the callout.
                UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.leftCalloutAccessoryView = detailButton;
                
                // TODO: Missing left image for annotation
                // UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
                // pinView.leftCalloutAccessoryView = iconView;
                
            } else {
                pinView.annotation = annotation;
            }
            
            retPinView = pinView;
        }
    }
    return retPinView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (_flags.firtstUpdate == 1) {
        _flags.firtstUpdate = 0;
        
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, DefaultUserZoom, DefaultUserZoom);
        [_mapView setRegion:region animated:YES];
    }
}

@end

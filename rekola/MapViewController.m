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
    
    UIActivityIndicatorView *_indicatorView;
    NSInteger _selectedBikeIdentifier;
    MKDirections *_directionsRequest;
    NSArray *_bikes;
    
    struct {
        unsigned int firtstUpdate:1;
        unsigned int firstLaunch:1;
        unsigned int loadingData:1;
        unsigned int refreshingSelectedAnnotation:1;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    self.navigationItem.rightBarButtonItem = _trackingButton;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    _flags.refreshingSelectedAnnotation = 0;
    _flags.firtstUpdate = 1;
    _flags.firstLaunch = 1;
    _mapView.clusteringEnabled = NO;
    
    _POIBottomConstraint.constant = -230;
    [self.view layoutIfNeeded];
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
        
        [self startRefreshing];
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikesWithLocation:([RKLocationManager manager].currentLocation != nil)? [RKLocationManager manager].currentLocation.coordinate : CLLocationCoordinate2DMake(DefaultLatitude, DefaultLongtitude) completion:^(NSArray *bikes, NSError *error) {
            if (weakSelf) {
                if (!error) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    NSMutableArray *annotations = @[].mutableCopy;
                    
                    __block Bike *selectedBike = nil;
                    [bikes enumerateObjectsUsingBlock:^(Bike *obj, NSUInteger idx, BOOL *stop) {
                        if ([obj.identifier integerValue] == strongSelf->_selectedBikeIdentifier) {
                            selectedBike = obj;
                        }
                        [annotations addObject:[[RKAnnotation alloc] initWithAnnotation:obj]];
                    }];
                    
                    strongSelf->_bikes = bikes;
                    
                    [weakSelf.mapView clearAnnotations];
                    [weakSelf.mapView addAnnotations:annotations];
                    
                    if (selectedBike) {
                        strongSelf->_flags.refreshingSelectedAnnotation = 1;
                        [weakSelf.mapView selectAnnotation:selectedBike animated:NO];
                        strongSelf->_flags.refreshingSelectedAnnotation = 0;
                    } else {
                        [weakSelf POIDetailWillDismiss:weakSelf.POIView];
                    }
                    strongSelf->_flags.loadingData = 0;

                } else {
                   [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                }
                [weakSelf stopRefreshing];
            }
        }];
    }
}

#pragma mark - Actions

- (IBAction)refreshPOI:(id)sender {
    [ContentManager manager].bikesUpdateDate = nil;
    [self reloadData];
}

#pragma mark - Private methods

- (void)startRefreshing {
    [_indicatorView startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
}

- (void)stopRefreshing {
    self.navigationItem.leftBarButtonItem = _refreshButton;
    [_indicatorView stopAnimating];
}

- (void)zoomToDefaultLocation {
    CLLocationCoordinate2D zoomLocation = [[[CLLocation alloc] initWithLatitude:DefaultLatitude longitude:DefaultLongtitude] coordinate];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, DefaultDistance, DefaultDistance);
    [_mapView setRegion:viewRegion animated:YES];
}

- (Bike *)bikeWithId:(NSInteger)identifier {
    __block Bike *bike = nil;
    [_bikes enumerateObjectsUsingBlock:^(Bike *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.identifier integerValue] == identifier) {
            bike = obj;
            *stop = YES;
        }
    }];
    return bike;
}

#pragma mark - MapKitDelegate methods

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    [_mapView clusterAnnotations];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Bike class]] && _flags.refreshingSelectedAnnotation == 0) {

         Bike *bike = (Bike *)view.annotation;
        _selectedBikeIdentifier = [bike.identifier integerValue];
        
        if (mapView.userLocation.location != nil) {
            NSNumber *distance = @([mapView.userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:bike.coordinate.latitude longitude:bike.coordinate.longitude]]);
            _POIView.titleLabel.text = distance.formattedDistance;
        
        } else {
            _POIView.titleLabel.text = nil;
        }
        
        [_directionsRequest cancel];
        
        _POIView.indicatorView.hidden = YES;
        [_POIView.indicatorView stopAnimating];
        _POIView.directionButton.hidden = NO;
        
        if (_routePolyline) {
            [_mapView removeOverlay:_routePolyline];
        }
        
        //_POIView.titleLabel.text = bike.name;
        _POIView.descriptionLabel.text = bike.bikeDescription;
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)view;
        pinView.pinColor = MKPinAnnotationColorRed;
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            _POIBottomConstraint.constant = 0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _POIBottomConstraint.constant = 0;
        }];
        
        [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Bike class]]) {
        
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)view;
        pinView.pinColor = MKPinAnnotationColorPurple;
    }
}

- (void)showRoute:(MKRoute *)route {
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
                
                pinView.canShowCallout = NO;
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
            
            Bike *bike = (Bike *)annotation;
            if ([bike.identifier integerValue] == _selectedBikeIdentifier) {
                pinView.pinColor = MKPinAnnotationColorRed;
            } else {
                pinView.pinColor = MKPinAnnotationColorPurple;
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

#pragma mark - POIDetailViewDelegate methods

- (void)POIDetailWillOpenDetail:(POIDetailView *)detailView {
    [self performSegueWithIdentifier:@"BikeDetailSegue" sender:nil];
}

- (void)POIDetailWillFindDirections:(POIDetailView *)detailView {
    
    [_directionsRequest cancel];
    
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
        
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:[self bikeWithId:_selectedBikeIdentifier].coordinate addressDictionary:nil]];
    
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeWalking;
    
    detailView.indicatorView.hidden = NO;
    [detailView.indicatorView startAnimating];
    detailView.directionButton.hidden = YES;
    
    _directionsRequest = [[MKDirections alloc] initWithRequest:request];
    [_directionsRequest calculateDirectionsWithCompletionHandler: ^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            MKRoute *route = [response.routes firstObject];
            [self showRoute:route];
            detailView.titleLabel.text = @(route.expectedTravelTime).formattedDuration;
            
            
        } else {
            detailView.directionButton.hidden = NO;
        }
        
        detailView.indicatorView.hidden = YES;
        [detailView.indicatorView stopAnimating];
    }];
}

- (void)POIDetailWillDismiss:(POIDetailView *)detailView {
    
    [UIView animateWithDuration:0.25 animations:^{
        _POIBottomConstraint.constant = -230;

    } completion:^(BOOL finished) {
        _POIBottomConstraint.constant = -230;
        _selectedBikeIdentifier = -1;
        
        [_mapView deselectAnnotation:[_mapView.selectedAnnotations firstObject] animated:YES];
    }];
}

@end

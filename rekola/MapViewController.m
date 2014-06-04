/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import "MapViewController.h"
#import "BikeDetailViewController.h"
#import "RKAnnotation.h"

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
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tabbar_ic_map_active.png"] selectedImage:[[UIImage imageNamed:@"tabbar_ic_map_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)dealloc {
    _mapView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
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
    _mapView.showsUserLocation = YES;
    
    _POIBottomConstraint.constant = - (_POIHeightConstraint.constant + 30 + self.tabBarController.tabBar.bounds.size.height);
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
        
        if (![[ContentManager manager] isLocationServiceAuthorized]) {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Location Services are turned off. The application will not be able to provide full functionality. You can turn on Location Services by going to the Settings > Privacy > and switching Location Services On.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
            
            [self zoomToDefaultLocation];
        }
    }
    
    _POIView.directionButton.enabled = [[ContentManager manager] isLocationServiceAuthorized];
}

- (void)reloadData {
    
    if (_flags.loadingData != 1 && [[ContentManager manager] updateTime]) {
        _flags.loadingData = 1;
        
        [self startRefreshing];
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikesWithLocation:CLLocationCoordinate2DMake(DefaultLatitude, DefaultLongtitude) completion:^(NSArray *bikes, NSError *error) {
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"BikeDetailSegue"]) {
        Bike *bike = sender;
        NSString *urlPath = [NSString stringWithFormat:@"%@/bikes/%@/info-webview",RekolaAPIURLString,[bike.identifier stringValue]];
        BikeDetailViewController *controller = segue.destinationViewController;
        controller.urlPath = urlPath;
        controller.title = bike.name;
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

- (void)hidePOIDetailView {
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        _POIBottomConstraint.constant = - (_POIHeightConstraint.constant + 30 + self.tabBarController.tabBar.bounds.size.height);
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

#pragma mark - MapKitDelegate methods

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated {
    [_mapView clusterAnnotations];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Bike class]] && _flags.refreshingSelectedAnnotation == 0) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePOIDetailView) object:nil];
        
        Bike *bike = (Bike *)view.annotation;
        
        if ([bike.identifier integerValue] == _selectedBikeIdentifier && _routePolyline) {
            [_mapView removeOverlay:_routePolyline];
        } else {
            _selectedBikeIdentifier = [bike.identifier integerValue];
        }
        
        if (mapView.userLocation.location != nil) {
            NSNumber *distance = @([mapView.userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:bike.coordinate.latitude longitude:bike.coordinate.longitude]]);
            _POIView.titleLabel.text = [NSString stringWithFormat:@", %@, %@",distance.formattedDistance, bike.name];
        } else {
            _POIView.titleLabel.text = [NSString stringWithFormat:@", %@",bike.name];
        }
        
        _POIView.titlePaddingConstraint.constant = 64;
        [_POIView layoutIfNeeded];
        
        [_directionsRequest cancel];
        
        _POIView.indicatorView.hidden = YES;
        [_POIView.indicatorView stopAnimating];
        _POIView.directionButton.hidden = NO;
        
        _POIView.addressLabel.text = bike.location.note;
        _POIView.descriptionLabel.text = bike.bikeDescription;
        
        view.image = [UIImage imageNamed:@"ic_pin_focused_pressed.png"];
        
        if (_POIBottomConstraint.constant != 0) {
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.25 animations:^{
                _POIBottomConstraint.constant = 0;
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                _POIBottomConstraint.constant = 0;
            }];
        }
        
        [_mapView centerByOffset:CGPointMake(0, _POIHeightConstraint.constant / 2) from:view.annotation.coordinate];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view.annotation isKindOfClass:[Bike class]]) {
        
        view.image = [UIImage imageNamed:@"ic_pin_normal.png"];
        [self performSelector:@selector(hidePOIDetailView) withObject:nil afterDelay:0.1];
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
    renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
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
            
            pinView.pinColor = MKPinAnnotationColorGreen;
            retPinView = pinView;
            
            // Single pin
        } else {
            MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:BikeAnnotationViewIdentifier];
            
            if (!pinView) {
                pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:BikeAnnotationViewIdentifier];
                
                pinView.canShowCallout = NO;
                pinView.image = [UIImage imageNamed:@"ic_pin_normal.png"];
                pinView.centerOffset = CGPointMake(0, - pinView.image.size.height / 2);
                
                // Add a detail disclosure button to the callout.
                UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                pinView.leftCalloutAccessoryView = detailButton;
                
            } else {
                pinView.annotation = annotation;
            }
            
            Bike *bike = (Bike *)annotation;
            if ([bike.identifier integerValue] == _selectedBikeIdentifier) {
                pinView.image = [UIImage imageNamed:@"ic_pin_focused_pressed.png"];
            } else {
                pinView.image = [UIImage imageNamed:@"ic_pin_normal.png"];;
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
    [self performSegueWithIdentifier:@"BikeDetailSegue" sender:[self bikeWithId:_selectedBikeIdentifier]];
}

- (void)POIDetailWillFindDirections:(POIDetailView *)detailView {
    
    [_directionsRequest cancel];
    
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    
    Bike *bike = [self bikeWithId:_selectedBikeIdentifier];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:bike.coordinate addressDictionary:nil]];
    
    request.destination = destination;
    request.transportType = MKDirectionsTransportTypeWalking;
    
    detailView.indicatorView.hidden = NO;
    [detailView.indicatorView startAnimating];
    detailView.directionButton.hidden = YES;
    
    _directionsRequest = [[MKDirections alloc] initWithRequest:request];
    
    __weak __typeof(self)weakSelf = self;
    [_directionsRequest calculateDirectionsWithCompletionHandler: ^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            MKRoute *route = [response.routes firstObject];
            [weakSelf showRoute:route];
            
            NSString *durationString = (@(route.expectedTravelTime).formattedDuration.length > 0)? [NSString stringWithFormat:@"%@, ",@(route.expectedTravelTime).formattedDuration] : @"";
            detailView.titleLabel.text = [NSString stringWithFormat:@"%@%@",durationString, bike.name];
            
            [UIView animateWithDuration:0.25 animations:^{
                detailView.titlePaddingConstraint.constant = 12;
                [detailView layoutIfNeeded];
            }];
            
        } else if (error.code != -999) {
            NSString *message = [[error userInfo] objectForKey:@"NSLocalizedFailureReason"];
            message = message ?: error.localizedDescription;
            [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
            detailView.directionButton.hidden = NO;
        }
        
        if (error) {
            if (weakSelf.mapView.userLocation.location != nil) {
                NSNumber *distance = @([weakSelf.mapView.userLocation.location distanceFromLocation:[[CLLocation alloc] initWithLatitude:bike.coordinate.latitude longitude:bike.coordinate.longitude]]);
                detailView.titleLabel.text = [NSString stringWithFormat:@", %@, %@",distance.formattedDistance, bike.name];
            } else {
                detailView.titleLabel.text = [NSString stringWithFormat:@", %@",bike.name];
            }
        }
        
        detailView.indicatorView.hidden = YES;
        [detailView.indicatorView stopAnimating];
    }];
}

- (void)POIDetailWillDismiss:(POIDetailView *)detailView {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        _POIBottomConstraint.constant = - (_POIHeightConstraint.constant + 30 + self.tabBarController.tabBar.bounds.size.height);
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        _POIBottomConstraint.constant = - (_POIHeightConstraint.constant + 30 + self.tabBarController.tabBar.bounds.size.height);
        _selectedBikeIdentifier = -1;
        
        [_mapView deselectAnnotation:[_mapView.selectedAnnotations firstObject] animated:YES];
    }];
}

@end

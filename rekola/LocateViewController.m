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

#import "LocateViewController.h"
#import "POI.h"

@implementation LocateViewController {
    NSString *_textViewText;
    NSString *_placeHolderString;
    CLLocationCoordinate2D _newLocation;
    MKUserTrackingBarButtonItem *_trackingButton;
    UIActivityIndicatorView *_indicatorView;
    
    struct {
        unsigned int firtstUpdate:1;
    } _flags;
}

- (void)dealloc {
    _mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _flags.firtstUpdate = 1;
    
    _navBarItem.title = NSLocalizedString(@"Edit Location", @"Title in navigation bar");
    
    _trackingButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:_mapView];
    _navBarItem.rightBarButtonItem = _trackingButton;
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _returnBikeButton.enabled = NO;
    
    _textView.layer.borderColor = COLOR(0xAAAAAA).CGColor;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.layer.borderWidth = 1;
    _placeHolderString = NSLocalizedString(@"Upresnete prosim, kde kolo presne stoji (napr. 3. lampa od ulice X)", @"Placeholder text inside a Text View");
    _textViewText = @"";
    _textView.text = _placeHolderString;
    
    [_returnBikeButton setTitleForAllState:NSLocalizedString(@"Bike Returned", @"A button title somewhere on the screen")];
    _closeButton.title = NSLocalizedString(@"Close", @"Bar button title in navigation bar");
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(5.3297021841444163, 7.2027525576011158);
    [_mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(49.826988220214851, 15.472262382507363), span) animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        
    if (![[ContentManager manager] isLocationServiceAuthorized]) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        
        [self zoomToDefaultLocation];
        
    } else if (_mapView.userLocation != nil && _flags.firtstUpdate == 1) {
        _flags.firtstUpdate = 0;
        
        [self fetchPOIs];
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, DefaultUserZoom / 4, DefaultUserZoom / 4);
        [_mapView setRegion:region animated:YES];
    }
    
    _returnBikeButton.enabled = YES;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Actions

- (IBAction)close:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:note:)]) {
        [_delegate controller:self didFinishWithLocation:nil note:nil];
    }
}

- (IBAction)returnBike:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:didFinishWithLocation:note:)]) {
        [_delegate controller:self didFinishWithLocation:[[CLLocation alloc] initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude] note:_textViewText];
    }
}

- (IBAction)done:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Private methods

- (void)startRefreshing {
    [_indicatorView startAnimating];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
}

- (void)stopRefreshing {
    self.navigationItem.leftBarButtonItem = _trackingButton;
    [_indicatorView stopAnimating];
}

- (void)fetchPOIs {
    [self startRefreshing];
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] POIsWithLocation:(_mapView.userLocation != nil)? _mapView.userLocation.coordinate : CLLocationCoordinate2DMake(DefaultLatitude, DefaultLongtitude) completion:^(NSArray *pois, NSError *error) {
        if (weakSelf) {
            if (!error) {
                NSMutableArray *annotations = @[].mutableCopy;
                
                [pois enumerateObjectsUsingBlock:^(Bike *obj, NSUInteger idx, BOOL *stop) {
                    [annotations addObject:[[RKAnnotation alloc] initWithAnnotation:obj]];
                }];
                
                [weakSelf.mapView clearAnnotations];
                [weakSelf.mapView addAnnotations:annotations];
            }
            [weakSelf stopRefreshing];
        }
    }];
}

#pragma mark - UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.layer.borderColor = [UIColor RKPinkColor].CGColor;
    textView.text = _textViewText;
    textView.textColor = [UIColor RKPinkColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_textViewText.length == 0) {
        textView.text = _placeHolderString;
        textView.textColor = [UIColor lightGrayColor];
    }
    
    textView.layer.borderColor = COLOR(0xAAAAAA).CGColor;
}

- (void)textViewDidChange:(UITextView *)textView {
    _textViewText = textView.text;
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
        
        [self fetchPOIs];
    
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, DefaultUserZoom / 4, DefaultUserZoom / 4);
        [_mapView setRegion:region animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *POIAnnotationViewIdentifier = @"POIAnnotationViewIdentifier";
    MKAnnotationView *retPinView = nil;
    
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *pinView = [mapView dequeueReusableAnnotationViewWithIdentifier:POIAnnotationViewIdentifier];
        
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:POIAnnotationViewIdentifier];
            
            pinView.canShowCallout = YES;
            // TODO: missing assets
            pinView.image = [UIImage imageNamed:@"ic_pin_normal.png"];
            pinView.centerOffset = CGPointMake(0, - pinView.image.size.height / 2);
            
        } else {
            pinView.annotation = annotation;
        }
        
        // TODO: missing assets
        POI *poi = (POI *)annotation;
        if (poi.type == POITypeBay) {
            pinView.image = [UIImage imageNamed:@"ic_pin_pressed.png"];
        } else if (poi.type == POITypeGrave) {
            pinView.image = [UIImage imageNamed:@"ic_pin_normal.png"];
        }
        
        retPinView = pinView;
    }
    return retPinView;
}

#pragma mark - UIKeyboard methods

- (void)keyboardWillShow:(NSNotification*)notification {
    
    _navBarItem.rightBarButtonItem = _doneButton;
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // Convert right frame based on orientation.
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [_contentView convertRect:kbRect fromView:nil];
    
    CGRect viewFrame = _contentView.frame;
    viewFrame.origin.y = viewFrame.origin.y - kbRect.size.height;
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = viewFrame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    _navBarItem.rightBarButtonItem = _trackingButton;
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGRect viewFrame = _contentView.frame;
    viewFrame.origin.y = 65;
    
    [UIView animateWithDuration:duration animations:^{
        _contentView.frame = viewFrame;
    } completion:nil];
}

#pragma mark - UIGestureRecognizer methods

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

@end

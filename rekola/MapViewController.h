//
//  MapViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "RKMapView.h"

@interface MapViewController : BaseViewController <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet RKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshPOI:(id)sender;

@end

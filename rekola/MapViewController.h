//
//  MapViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "RKMapView.h"
#import "POIDetailView.h"

@interface MapViewController : BaseViewController <MKMapViewDelegate, POIDetailViewDelegate>

@property (nonatomic, weak) IBOutlet RKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, weak) IBOutlet POIDetailView *POIView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *POIBottomConstraint;

- (IBAction)refreshPOI:(id)sender;

@end

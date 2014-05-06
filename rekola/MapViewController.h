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

#import "BaseViewController.h"
#import "RKMapView.h"
#import "POIDetailView.h"

@interface MapViewController : BaseViewController <MKMapViewDelegate, POIDetailViewDelegate>

@property (nonatomic, weak) IBOutlet RKMapView *mapView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, weak) IBOutlet POIDetailView *POIView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *POIBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *POIHeightConstraint;

- (IBAction)refreshPOI:(id)sender;

@end

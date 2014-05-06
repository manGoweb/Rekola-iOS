//
//  LocateViewController.h
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "RKMapView.h"

@class LocateViewController;

@protocol LocateViewControllerDelegate <NSObject>
- (void)controller:(LocateViewController *)controller didFinishWithLocation:(CLLocation *)location note:(NSString *)note;
@end

@interface LocateViewController : BaseViewController

@property (nonatomic, weak) id<LocateViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet RKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *returnBikeButton;
@property (nonatomic, weak) IBOutlet UIImageView *annotationView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UINavigationItem *navBarItem;

- (IBAction)close:(id)sender;
- (IBAction)done:(id)sender;

@end

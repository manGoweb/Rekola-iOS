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

@class LocateViewController;

@protocol LocateViewControllerDelegate <NSObject>
- (void)controller:(LocateViewController *)controller didFinishWithLocation:(CLLocation *)location note:(NSString *)note;
@end

@interface LocateViewController : BaseViewController

@property (nonatomic, weak) id<LocateViewControllerDelegate> delegate;
@property (nonatomic, weak) IBOutlet RKMapView *mapView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *closeButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, weak) IBOutlet UIButton *returnBikeButton;
@property (nonatomic, weak) IBOutlet UIImageView *annotationView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UINavigationItem *navBarItem;

- (IBAction)close:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)returnBike:(id)sender;

@end

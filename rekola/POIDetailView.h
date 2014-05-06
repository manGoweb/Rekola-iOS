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

#import <UIKit/UIKit.h>

@class POIDetailView;
@protocol POIDetailViewDelegate <NSObject>

- (void)POIDetailWillDismiss:(POIDetailView *)detailView;
- (void)POIDetailWillOpenDetail:(POIDetailView *)detailView;
- (void)POIDetailWillFindDirections:(POIDetailView *)detailView;

@end

@interface POIDetailView : UIView

@property (nonatomic, weak) IBOutlet id<POIDetailViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *detailButton;
@property (nonatomic, weak) IBOutlet UIButton *directionButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

- (IBAction)showDetail:(id)sender;
- (IBAction)dismissView:(id)sender;
- (IBAction)findDirections:(id)sender;

@end

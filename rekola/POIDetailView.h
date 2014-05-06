//
//  POIDetailView.h
//  rekola
//
//  Created by Martin Banas on 02/05/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

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

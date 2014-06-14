/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titlePaddingConstraint;
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

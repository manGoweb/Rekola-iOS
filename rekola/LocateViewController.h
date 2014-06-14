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

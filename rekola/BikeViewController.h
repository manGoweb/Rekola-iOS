//
//  BikeViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface BikeViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIButton *borrowButton;
@property (nonatomic, weak) IBOutlet UITextField *bikeCodeField;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *codeLabel;

- (IBAction)textFieldDidChange:(UITextField *)textField;
- (IBAction)borrowBike:(id)sender;

@end

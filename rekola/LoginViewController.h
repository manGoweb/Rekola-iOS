//
//  LoginViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *passField;
@property (nonatomic, weak) IBOutlet UIButton *signButton;
@property (nonatomic, weak) IBOutlet UIButton *recoverButton;
@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *recoverDescriptionLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *centerConstraint;

- (IBAction)recoverPassword:(id)sender;
- (IBAction)signUp:(id)sender;
- (IBAction)signin:(id)sender;
- (IBAction)textFieldDidChange:(UITextField *)textField;

@end

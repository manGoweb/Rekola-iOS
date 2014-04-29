//
//  LoginViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "RecoverViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate, RecoverViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *passField;
@property (nonatomic, weak) IBOutlet UIButton *signButton;
@property (nonatomic, weak) IBOutlet UIButton *recoverButton;
@property (nonatomic, weak) IBOutlet UIButton *signUp;

- (IBAction)signUp:(id)sender;
- (IBAction)signin:(id)sender;
- (IBAction)textFieldDidChange:(UITextField *)textField;

@end

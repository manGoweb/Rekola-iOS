//
//  ChangePassViewController.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePassViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UITextField *oldPassField;
@property (nonatomic, weak) IBOutlet UITextField *passField;
@property (nonatomic, weak) IBOutlet UITextField *rePassField;
@property (nonatomic, weak) IBOutlet UIButton *changePassButton;

- (IBAction)changePass:(id)sender;
- (IBAction)textFieldDidChange:(UITextField *)textField;
- (IBAction)popBack:(id)sender;

@end

//
//  ChangePassViewController.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ChangePassViewController.h"

@implementation ChangePassViewController
/*
- (void)viewDidLoad
{
    [super viewDidLoad];

    _changePassButton.enabled = NO;
    _oldPassField.placeholder = NSLocalizedString(@"old password", nil);
    _newPassField.placeholder = NSLocalizedString(@"new password", nil);
    _newRePassField.placeholder = NSLocalizedString(@"new password again", nil);
    
    [_changePassButton setTitle:NSLocalizedString(@"Change", nil) forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Actions

- (void)changePass:(id)sender {
    if ([_newPassField.text isEqualToString:_newRePassField.text]) {
        
        _contentView.userInteractionEnabled = NO;
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] changePassword:_newPassField.text completion:^(NSError *error) {
            if (weakSelf) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
                    weakSelf.oldPassField.text = nil;
                    weakSelf.newPassField.text = nil;
                    weakSelf.newRePassField.text = nil;
                }
                strongSelf->_contentView.userInteractionEnabled = YES;
            }
        }];
    } else {
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Name or Password", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        
        _newRePassField.text = nil;
        _newRePassField.text = nil;
    }
}

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _oldPassField) {
        [_newPassField becomeFirstResponder];
    } else if (textField == _newPassField) {
        [_newRePassField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    _changePassButton.enabled = (_oldPassField.text.length > 0 && _newPassField.text.length > 0 && _newRePassField.text.length > 0);
}
 */

@end

//
//  ChangePassViewController.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ChangePassViewController.h"

@implementation ChangePassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _changePassButton.enabled = NO;
    _oldPassField.placeholder = NSLocalizedString(@"old password", nil);
    _passField.placeholder = NSLocalizedString(@"new password", nil);
    _rePassField.placeholder = NSLocalizedString(@"new password again", nil);
    
    [_changePassButton setTitle:NSLocalizedString(@"Change", nil) forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Actions

- (void)changePass:(id)sender {
    
    if ([_passField.text isEqualToString:_rePassField.text]) {
    
        [self.view endEditing:YES];
        _contentView.userInteractionEnabled = NO;
        
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] changePassword:_passField.text completion:^(NSError *error) {
            if (weakSelf) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
                    weakSelf.oldPassField.text = nil;
                    weakSelf.passField.text = nil;
                    weakSelf.rePassField.text = nil;
                    
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                strongSelf->_contentView.userInteractionEnabled = YES;
            }
        }];
    } else {
        // TODO:
//        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Name or Password", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        
        _passField.text = nil;
        _rePassField.text = nil;
    }
}

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _oldPassField) {
        [_passField becomeFirstResponder];
    } else if (textField == _passField) {
        [_rePassField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    _changePassButton.enabled = (_oldPassField.text.length > 0 && _passField.text.length > 0 && _rePassField.text.length > 0);
}

@end

//
//  LoginViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _signButton.enabled = NO;
    _nameField.placeholder = NSLocalizedString(@"email", nil);
    _passField.placeholder = NSLocalizedString(@"password", nil);
    [_signButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
    [_recoverButton setTitle:NSLocalizedString(@"Recover Password", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *username = [[ContentManager manager] keychainObjectForKey:KeychainUserName];
    
    if (username) {
        _nameField.text = username;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RecoverSegue"]) {
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - Actions

- (IBAction)signin:(id)sender {
    [self.view endEditing:YES];
    
    _contentView.userInteractionEnabled = NO;
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] loginWithUsername:_nameField.text password:_passField.text completion:^(NSError *error) {
        if (weakSelf) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if (error) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Incorrect Name or Password", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
                weakSelf.passField.text = nil;
            }
            strongSelf->_contentView.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameField) {
        [_passField becomeFirstResponder];
    } else if (textField == _passField) {
        [self signin:nil];
    }
    return YES;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    _signButton.enabled = (_nameField.text.length > 0 && _passField.text.length > 0);
}

#pragma mark - RecoveryViewControllerDelegate methods

- (void)controllerDidFinish:(RecoverViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end

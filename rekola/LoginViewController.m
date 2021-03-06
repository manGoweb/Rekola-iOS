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

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoginViewController {
    struct {
        unsigned int recoverPassword:1;
    } _flags;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _centerConstraint.constant = (IS_IPHONE && IS_WIDESCREEN)? 65 : 15;
    [self.view layoutIfNeeded];
    
    _flags.recoverPassword = 0;
    _indicatorView.hidden = YES;
    _signButton.enabled = NO;
    _recoverDescriptionLabel.alpha = 0;
    
    _titleLabel.text = NSLocalizedString(@"Log In", @"A label text somewhere on the screen");
    _recoverDescriptionLabel.text = NSLocalizedString(@"Enter your email to get instructions on how to reset your password.", @"A label text somewhere on the screen");
    
    _nameField.placeholder = NSLocalizedString(@"email", @"Placeholder inside a Text Field");
    _nameField.layer.borderColor = COLOR(0xAAAAAA).CGColor;
    _nameField.layer.borderWidth = 1;
    
    _passField.placeholder = NSLocalizedString(@"password", @"Placeholder inside a Text Field");
    _passField.layer.borderColor = COLOR(0xAAAAAA).CGColor;
    _passField.layer.borderWidth = 1;
    
    [_signButton setTitleForAllState:NSLocalizedString(@"Log In", @"A button title somewhere on the screen")];
    [_signButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [_signButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateSelected];
    
    [_signUpButton setTitleForAllState:NSLocalizedString(@"Not a member?", @"A button title somewhere on the screen")];
    [_recoverButton setTitleForAllState:NSLocalizedString(@"Forgot Password?", @"A button title somewhere on the screen")];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *username = [[ContentManager manager] keychainObjectForKey:KeychainUserName];
    
    if (username) {
        _nameField.text = username;
    }
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *passEncoded = [[ContentManager manager] keychainObjectForKey:KeychainUserPassword];
    NSString *username = [[ContentManager manager] keychainObjectForKey:KeychainUserName];
    
    if (passEncoded && username) {
        NSData *passData = [[NSData alloc] initWithBase64EncodedString:passEncoded options:0];
        NSString *pass = [[NSString alloc] initWithData:passData encoding:NSUTF8StringEncoding];
        
        _nameField.text = username;
        _passField.text = @"......";
        
        [self signInWithName:username password:pass];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _passField.text = nil;
}

#pragma mark - Actions

- (IBAction)signin:(id)sender {
    if (_flags.recoverPassword == 1) {
        [self recoverPassword];
    } else {
        [self signInWithName:_nameField.text password:_passField.text];
    }
}

- (IBAction)signUp:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rekola.cz/register/credentials"]];
}

- (IBAction)recoverPassword:(id)sender {
    
    if (_flags.recoverPassword == 1) {
        [self.view endEditing:YES];
        
    } else {
        [_signButton setTitleForAllState:NSLocalizedString(@"Reset Password", nil)];
        [_recoverButton setTitleForAllState:NSLocalizedString(@"Back to Log In", nil)];
        
        _flags.recoverPassword = 1;
        _signButton.enabled = (_nameField.text.length > 0);
        _nameField.returnKeyType = UIReturnKeyGo;
        
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = _nameField.frame;
            frame.origin.y += 52;
            _nameField.frame = frame;
            _recoverDescriptionLabel.alpha = 1;
            
        } completion:^(BOOL finished) {
            [_nameField becomeFirstResponder];
            _passField.text = nil;
        }];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == _nameField) {
        if (_flags.recoverPassword == 1) {
            [self recoverPassword];
        } else {
            [_passField becomeFirstResponder];
        }
    } else if (textField == _passField) {
        [self signInWithName:_nameField.text password:_passField.text];
    }
    return YES;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    if (_flags.recoverPassword == 1) {
        _signButton.enabled = (_nameField.text.length > 0);
    } else {
        _signButton.enabled = (_nameField.text.length > 0 && _passField.text.length > 0);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = [UIColor RKPinkColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = COLOR(0xAAAAAA).CGColor;
}

#pragma mark - Private methods

- (void)signInWithName:(NSString *)name password:(NSString *)password {
    [self.view endEditing:YES];
    
    _indicatorView.hidden = NO;
    _signButton.enabled = NO;
    [_indicatorView startAnimating];
    _contentView.userInteractionEnabled = NO;
    
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] loginWithUsername:name password:password completion:^(NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        }
        weakSelf.passField.text = nil;
        weakSelf.contentView.userInteractionEnabled = YES;
        weakSelf.signButton.enabled = YES;
        weakSelf.indicatorView.hidden = YES;
        [weakSelf.indicatorView stopAnimating];
    }];
}

- (void)recoverPassword {
    
    _indicatorView.hidden = NO;
    _signButton.enabled = NO;
    [_indicatorView startAnimating];
    
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] recoverPassword:_nameField.text completion:^(NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        // success
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please check your email for further instructions.", @"Text message in Alert View") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        }
        
        weakSelf.signButton.enabled = YES;
        weakSelf.indicatorView.hidden = YES;
        [weakSelf.indicatorView stopAnimating];
        [weakSelf.view endEditing:YES];
    }];
}

#pragma mark - UIGestureRecognizer methods

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UIKeyboard methods

- (void)keyboardWillShow:(NSNotification*)notification {
    if (IS_IPHONE && !IS_WIDESCREEN) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        // Convert right frame based on orientation.
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        kbRect = [_contentView convertRect:kbRect fromView:nil];
        
        CGRect viewFrame = _contentView.frame;
        viewFrame.origin.y = viewFrame.origin.y - (kbRect.size.height / ((_flags.recoverPassword == 1)? 4 : 3));
        [UIView animateWithDuration:duration animations:^{
            _contentView.frame = viewFrame;
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (IS_IPHONE && !IS_WIDESCREEN) {
        NSDictionary *info = [notification userInfo];
        CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        CGRect viewFrame = _contentView.frame;
        viewFrame.origin.y = 20;
        
        [_recoverButton setTitleForAllState:NSLocalizedString(@"Forgot Password?", nil)];
        [UIView animateWithDuration:duration animations:^{
            _contentView.frame = viewFrame;
            
            if (_flags.recoverPassword == 1) {
                CGRect frame = _nameField.frame;
                frame.origin.y -= 52;
                _nameField.frame = frame;
                
                [_signButton setTitleForAllState:NSLocalizedString(@"Log In", nil)];
                
                _recoverDescriptionLabel.alpha = 0;
                _signButton.enabled = (_nameField.text.length > 0 && _passField.text.length > 0);
                _nameField.returnKeyType = UIReturnKeyNext;
            }
        } completion:^(BOOL finished) {
            _flags.recoverPassword = 0;
        }];
        
    } else {
        [_recoverButton setTitleForAllState:NSLocalizedString(@"Forgot Password?", nil)];
        [UIView animateWithDuration:0.25 animations:^{
            if (_flags.recoverPassword == 1) {
                CGRect frame = _nameField.frame;
                frame.origin.y -= 52;
                _nameField.frame = frame;
                
                [_signButton setTitleForAllState:NSLocalizedString(@"Log In", nil)];
                
                _recoverDescriptionLabel.alpha = 0;
                _signButton.enabled = (_nameField.text.length > 0 && _passField.text.length > 0);
                _nameField.returnKeyType = UIReturnKeyNext;
            }
        } completion:^(BOOL finished) {
            _flags.recoverPassword = 0;
        }];
    }
}

@end

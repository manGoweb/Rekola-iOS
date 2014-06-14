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

#import "BikeViewController.h"
#import "RKMapView.h"

@implementation BikeViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Borrow Bike", @"Title in segmented control");
        self.navigationController.tabBarItem.title = self.title;
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.title image:[UIImage imageNamed:@"tabbar_ic_borrow_active.png"] selectedImage:[[UIImage imageNamed:@"tabbar_ic_borrow_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _indicatorView.hidden = YES;
    _borrowButton.enabled = NO;
    
    _titleLabel.text = NSLocalizedString(@"Borrow Bike", @"A label text somewhere on the screen");
    _descriptionLabel.text = NSLocalizedString(@"After entering the code, you will receive a bike lock code and you can start using the bike.", @"A label text somewhere on the screen");
    _codeLabel.text = NSLocalizedString(@"Code can be found on the rear fender or on rear stick.", @"A label text somewhere on the screen");
    
    _bikeCodeField.placeholder = NSLocalizedString(@"code", @"Placeholder text inside a TextField");
    _bikeCodeField.layer.borderColor = COLOR(0xAAAAAA).CGColor;
    _bikeCodeField.layer.borderWidth = 1;
    
    [_borrowButton setTitleForAllState:NSLocalizedString(@"Borrow", @"A button title somewhere on the screen")];
    [_borrowButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
    [_borrowButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)reloadData {
    _borrowButton.enabled = (_bikeCodeField.text.length > 0);
}

#pragma mark - Actions

- (IBAction)borrowBike:(id)sender {
    [self.view endEditing:YES];

    NSString *bikeCode = _bikeCodeField.text;
    _indicatorView.hidden = NO;
    _borrowButton.enabled = NO;
    [_indicatorView startAnimating];
    _contentView.userInteractionEnabled = NO;
    
    __weak __typeof(self)weakSelf = self;
    [[ContentManager manager] bikeStateWithCompletion:^(Bike *bike, NSError *error) {
        if (weakSelf) {
            if (!error || error.statusCode == 404 || error.statusCode == 200) {
                if (bike) {
                    [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"You already borrowed a bike.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                    [weakSelf restoreState];
                    
                } else {
                    [[ContentManager manager] borrowBikeWithCode:bikeCode location:CLLocationCoordinate2DMake(DefaultLatitude, DefaultLongtitude)  completion:^(NSString *code, NSError *error) {
                        if (!error) {
                            NSLog(@"Bike successfully borrowed %@", code);
                            
                        } else {
                            [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                            [weakSelf restoreState];
                        }
                    }];
                }
                
            } else {
                [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                [weakSelf restoreState];
            }
        }
    }];
}

#pragma mark - Private methods

- (void)restoreState {
    _bikeCodeField.text = nil;
    _contentView.userInteractionEnabled = YES;
    _borrowButton.enabled = YES;
    _indicatorView.hidden = YES;
    [_indicatorView stopAnimating];
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.layer.borderColor = [UIColor RKPinkColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = COLOR(0xAAAAAA).CGColor;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    _borrowButton.enabled = (_bikeCodeField.text.length > 0);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return ([[NSCharacterSet decimalDigitCharacterSet] isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:string]] && textField.text.length < 6);
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
        viewFrame.origin.y = viewFrame.origin.y - (kbRect.size.height / 3);
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
        viewFrame.origin.y = 0;
        
        [UIView animateWithDuration:duration animations:^{
            _contentView.frame = viewFrame;
        } completion:nil];
    }
}

#pragma mark - UIGestureRecognizer methods

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        [self.view endEditing:YES];
    }
}

@end

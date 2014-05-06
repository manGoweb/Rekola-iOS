/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
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
    _descriptionLabel.text = NSLocalizedString(@"After entering the code, you will receive a code bike lock. Ever since you running out of time for which you pay karma.", @"A label text somewhere on the screen");
    _codeLabel.text = NSLocalizedString(@"Code can be found on the side of the wheel on bike.", @"A label text somewhere on the screen");
    
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
    if (bikeCode.length > 0) {
        _indicatorView.hidden = NO;
        _borrowButton.enabled = NO;
        [_indicatorView startAnimating];
        _contentView.userInteractionEnabled = NO;
        
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikeStateWithCompletion:^(Bike *bike, NSError *error) {
            if (weakSelf) {
                if (!error || error.statusCode == 404 || error.statusCode == 200) {
                    if (bike) {
                        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Uz jedno kolo pujceno mate", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
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
        
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Bike Code ma spatnou delku", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
    }
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

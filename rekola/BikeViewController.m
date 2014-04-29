//
//  BikeViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BikeViewController.h"

@implementation BikeViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Borrow", @"Title in segmented control");
        self.navigationController.tabBarItem.title = self.title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData {
    _borrowButton.enabled = NO;
}

- (void)setBikeDetail:(Bike *)bikeDetail {
    _bikeDetail = bikeDetail;
}

#pragma mark - Actions

- (IBAction)borrowBike:(id)sender {
    
    
    NSString *bikeCode = _bikeCodeField.text;
    
    if (![[RKLocationManager manager] isAuthorized]) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
    // TODO:
    /*} else if ([RKLocationManager manager].currentLocation == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Nepodarilo se ziskat vasi GPS pozici.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        */
    } else if (bikeCode.length > 0) {
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikeStateWithCompletion:^(Bike *bike, NSError *error) {
            if (weakSelf) {
                // __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (error.statusCode == 404 || error.statusCode == 200) {
                    if (bike) {
                        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Uz jedno kolo pujceno mate", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                        
                    } else {
                        [[ContentManager manager] borrowBikeWithCode:bikeCode location:[RKLocationManager manager].currentLocation.coordinate  completion:^(NSString *code, NSError *error) {
                            if (!error) {
                                NSLog(@"Bike successfully borrowed %@", code);
                                
                            } else {
                                [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                            }
                        }];
                    }
                } else {
                    [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                }
            }
        }];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Bike Code ma spatnou delku", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)textFieldDidChange:(UITextField *)textField {
    _borrowButton.enabled = (_bikeCodeField.text.length > 0);
}

@end

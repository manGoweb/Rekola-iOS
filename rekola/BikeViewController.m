//
//  BikeViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BikeViewController.h"

@implementation BikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)reloadData {
    
}

- (void)setBikeDetail:(Bike *)bikeDetail {
    _bikeDetail = bikeDetail;
}

- (IBAction)borrowBike:(id)sender {
    
    if (![[RKLocationManager manager] isAuthorized]) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        
    } else if ([RKLocationManager manager].currentLocation == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Nepodarilo se ziskat vasi GPS pozici.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        
    } else {
        __weak __typeof(self)weakSelf = self;
        [[ContentManager manager] bikeStateWithCompletion:^(Bike *bike, NSError *error) {
            if (weakSelf) {
                
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                if (!error) {
                    if (bike) {
                        [ContentManager manager].usingBike = bike;
                        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Uz jedno kolo pujceno mate", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                        
                    } else {
                        [[ContentManager manager] borrowBike:strongSelf->_bikeDetail location:[RKLocationManager manager].currentLocation.coordinate  completion:^(NSString *code, NSError *error) {
                            if (!error) {
                                NSLog(@"%@",code);
                            }
                        }];
                    }
                }
            }
        }];
    }
}
@end

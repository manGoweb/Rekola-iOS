//
//  ReturnBikeViewController.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ReturnBikeViewController.h"

@implementation ReturnBikeViewController {
    CLGeocoder *_geocoder;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    
}

- (void)reloadData {
}

#pragma mark - Actions

- (IBAction)returnBike:(id)sender {
    // TODO: customLocation
    id customLocation = nil;
    if ([[RKLocationManager manager] isAuthorized]) {
        if ([RKLocationManager manager].currentLocation) {
            
            __weak __typeof(self)weakSelf = self;
            [[ContentManager manager] returnBike:[ContentManager manager].usingBike location:[RKLocationManager manager].currentLocation.coordinate note:nil completion:^(NSError *error) {
                if (weakSelf) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    // check for more error codes
                    if (!error) {
                        if ([strongSelf.delegate respondsToSelector:@selector(controller:containerWillChangeType:withObject:)]) {
                            [strongSelf.delegate controller:weakSelf containerWillChangeType:ContainerTypeBike withObject:nil];
                        }
                        NSLog(@"Bike successfully returned");
                        
                    } else {
                        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
                    }
                }
            }];
            
        } else {
            [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Nepodarilo se ziskat vasi GPS pozici.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Polohové služby nejsou zapnuté, aplikace nebude schopna poskytovat plnou fukncionalitu. Povolit je můžete v nastavení svého zařízení v záložce soukromí.", @"Text message in Alert View.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Close", @"Button title in Alert View.") otherButtonTitles:nil, nil] show];
    }
}

- (void)geocodeLocation {
    if (_geocoder == nil) {
        _geocoder = [CLGeocoder new];
    }
    
    // TODO:
    [_geocoder reverseGeocodeLocation:[RKLocationManager manager].currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
      //  NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
    }];
}

@end

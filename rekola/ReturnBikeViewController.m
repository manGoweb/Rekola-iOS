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

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.title = NSLocalizedString(@"Return", @"Title in nav & tab controller");
        self.navigationController.tabBarItem.title = self.title;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    
}

- (void)reloadData {
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LocationSegue"]) {
        [(LocateViewController *)segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - Actions

- (IBAction)returnBike:(id)sender {
    // TODO: customLocation
   // id customLocation = nil;
    if ([[RKLocationManager manager] isAuthorized]) {
        if ([RKLocationManager manager].currentLocation) {
            
            __weak __typeof(self)weakSelf = self;
            [[ContentManager manager] returnBike:[ContentManager manager].usingBike location:[RKLocationManager manager].currentLocation.coordinate note:nil completion:^(NSError *error) {
                if (weakSelf) {
                    __strong __typeof(weakSelf)strongSelf = weakSelf;
                    // check for more error codes
                    if (!error) {
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

#pragma mark - LocateViewControllerDelegate methods

- (void)controller:(LocateViewController *)controller didFinishWithLocation:(CLLocation *)location {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end

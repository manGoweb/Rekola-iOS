//
//  ReturnBikeViewController.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ReturnBikeViewController.h"

@implementation ReturnBikeViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)returnBike:(id)sender {
    [[ContentManager manager] returnBike:[ContentManager manager].usingBike location:CLLocationCoordinate2DMake(0, 0) note:nil completion:^(NSError *error) {
        // check for more error codes
        if (!error) {
        }
    }];
}

@end

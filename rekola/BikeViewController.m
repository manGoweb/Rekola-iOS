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

- (IBAction)borrowBike:(id)sender {
    
    Bike *bike = [Bike new];
    bike.bikeCode = @"77";
    
    [[ContentManager manager] borrowBike:bike location:CLLocationCoordinate2DMake(0, 0) completion:^(NSString *code, NSError *error) {
        if (!error) {
            NSLog(@"%@",code);
        }
    }];
}
@end

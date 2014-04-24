//
//  BikeViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BikeViewController.h"

@interface BikeViewController ()

@end

@implementation BikeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTab:(id)sender {
    if ([_delegate respondsToSelector:@selector(controller:containerWillChangeType:withObject:)]) {
        [_delegate controller:self containerWillChangeType:ContainerTypeMap withObject:nil];
    }
}
@end

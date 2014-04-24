//
//  ChangePassViewController.m
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "ChangePassViewController.h"

@implementation ChangePassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

//
//  RecoverViewController.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "RecoverViewController.h"

@implementation RecoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    if ([_delegate respondsToSelector:@selector(controllerDidFinish:)]) {
        [_delegate performSelector:@selector(controllerDidFinish:) withObject:self];
    }
}

@end

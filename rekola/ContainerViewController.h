//
//  ContainerViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerDelegate.h"

@interface ContainerViewController : BaseViewController <ContainerDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)changeTab:(id)sender;

@end

//
//  BikeViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerDelegate.h"

@interface BikeViewController : BaseViewController

@property (nonatomic, weak)id<ContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet UIButton *borrowButton;

- (IBAction)borrowBike:(id)sender;

@end

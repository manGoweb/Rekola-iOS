//
//  ReturnBikeViewController.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerDelegate.h"

@interface ReturnBikeViewController : BaseViewController

@property (nonatomic, weak) id<ContainerDelegate>delegate;
@property (nonatomic, weak) IBOutlet UIButton *returnButton;

- (IBAction)returnBike:(id)sender;

@end

//
//  BikeViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@interface BikeViewController : BaseViewController

@property (nonatomic, weak) Bike *bikeDetail;
@property (nonatomic, weak) IBOutlet UIButton *borrowButton;
@property (nonatomic, weak) IBOutlet UITextField *bikeCodeField;

- (IBAction)borrowBike:(id)sender;

@end

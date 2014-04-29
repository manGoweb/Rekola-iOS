//
//  ReturnBikeViewController.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"
#import "LocateViewController.h"

@interface ReturnBikeViewController : BaseViewController <LocateViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIButton *returnButton;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

- (IBAction)returnBike:(id)sender;

@end

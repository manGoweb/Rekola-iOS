//
//  RecoverViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "BaseViewController.h"

@class RecoverViewController;
@protocol RecoverViewControllerDelegate <NSObject>
- (void)controllerDidFinish:(RecoverViewController *)controller;

@end

@interface RecoverViewController : BaseViewController

@property (nonatomic, weak) id<RecoverViewControllerDelegate> delegate;

- (IBAction)dismiss:(id)sender;

@end

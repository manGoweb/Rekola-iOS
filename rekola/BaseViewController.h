//
//  BaseViewController.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 Template method, which is automatically or manually called to reload important controller data. Content of this method should implement source for table view, reload of table view or any further parts which can change when device localization or controller's model changes.
 */
- (void)reloadData;

@end

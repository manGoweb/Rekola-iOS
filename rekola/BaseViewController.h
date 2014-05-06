/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import <UIKit/UIKit.h>
#import "TabBarController.h"

@interface BaseViewController : UIViewController

/**
 Template method, which is automatically or manually called to reload important controller data. Content of this method should implement source for table view, reload of table view or any further parts which can change when device localization or controller's model changes.
 */
- (void)reloadData;

@end

@interface UIViewController(TabBarControllerExtension)

- (TabBarController *)tabBarViewController;

@end

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

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IS_IOS_7_OR_LATER) {
        self.navigationBar.translucent = NO;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Bar button title in navigation bar.") style: UIBarButtonItemStylePlain target: nil action: nil];
    self.navigationBar.topItem.backBarButtonItem = backButton;
    
    [super pushViewController:viewController animated:animated];
}

@end

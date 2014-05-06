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

#import "TabBarController.h"

@implementation TabBarController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.tintColor = [UIColor RKPinkColor];
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:ContentManagerDidChangeUsingBikeNotification object:nil];
}

- (void)reloadData {
    NSMutableArray *controllers = self.viewControllers.mutableCopy;
    UINavigationController *nav = nil;
    
    if ([ContentManager manager].usingBike) {
        nav = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReturnBikeViewController"]];
    } else {
        nav = [[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"BikeViewController"]];
    }
    
    [controllers replaceObjectAtIndex:0 withObject:nav];
    [self setViewControllers:controllers animated:YES];
}

#pragma mark - Public methods

- (void)switchToController:(ControllerType)type withObject:(id)object {
    
    self.selectedIndex = type;
    
    if (type == ControllerTypeBike) {
        
    } else if (type == ControllerTypeMap) {
        
    } else if (type == ControllerTypeProfile) {
        
    }
}


@end

//
//  TapBarController.m
//  rekola
//
//  Created by Martin Banas on 29/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

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

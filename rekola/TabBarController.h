//
//  TapBarController.h
//  rekola
//
//  Created by Martin Banas on 29/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ControllerType) {
    
    ControllerTypeBike,
    ControllerTypeMap,
    ControllerTypeProfile
};

@interface TabBarController : UITabBarController

- (void)switchToController:(ControllerType)type withObject:(id)object;

@end

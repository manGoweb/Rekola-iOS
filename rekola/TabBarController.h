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

typedef NS_ENUM(NSUInteger, ControllerType) {
    
    ControllerTypeBike,
    ControllerTypeMap,
    ControllerTypeProfile
};

@interface TabBarController : UITabBarController

- (void)switchToController:(ControllerType)type withObject:(id)object;

@end

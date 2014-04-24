//
//  ContainerDelegate.h
//  rekola
//
//  Created by Martin Banas on 24/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ContainerType) {
    
    ContainerTypeBike,
    ContainerTypeMap,
    ContainerTypeProfile
};

@protocol ContainerDelegate <NSObject>
- (void)controller:(UIViewController *)controller containerWillChangeType:(ContainerType)type withObject:(id)object;

@end

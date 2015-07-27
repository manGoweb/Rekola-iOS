//
//  ModalDismissAnimation.h
//  TransitionTest
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AnimationTypePresent,
    AnimationTypeDismiss
} AnimationType;

@interface ModalAnimation : NSObject  <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType type;

@end

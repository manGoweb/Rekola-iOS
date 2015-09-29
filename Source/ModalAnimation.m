//
//  ModalDismissAnimation.m
//  TransitionTest
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ModalAnimation.h"
#import <Masonry.h>

@interface ModalAnimation()

@property (nonatomic, strong) UIVisualEffectView *coverView;

@end

@implementation ModalAnimation {
//    NSArray *_constraints;
}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //The view controller's view that is presenting the modal view
    UIView *containerView = [transitionContext containerView];
    
    if (self.type == AnimationTypePresent) {
        //The modal view itself
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        //View to darken the area behind the modal view
        if (!_coverView) {
//            _coverView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            //_coverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
            _coverView = [[UIView alloc] init];
            _coverView.backgroundColor = [UIColor blackColor];
            _coverView.alpha = 0.3;
        }
        //_coverView.frame = containerView.frame;
        [containerView addSubview:_coverView];
        [_coverView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        
        [containerView addSubview:modalView];
        [modalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(containerView.mas_width).multipliedBy(0.875);
            make.height.lessThanOrEqualTo(containerView.mas_height).multipliedBy(0.875);
            make.center.equalTo(containerView);
        }];
        
        //Move off of the screen so we can slide it up
        CGRect endFrame = modalView.frame;
        modalView.frame = CGRectMake(endFrame.origin.x, containerView.frame.size.height, endFrame.size.width, endFrame.size.height);
        [containerView bringSubviewToFront:modalView];
        
        //Animate using spring animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:0 animations:^{
            modalView.frame = endFrame;
//            _coverView.alpha = 1.0;
            _coverView.alpha = 0.4;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            //[modalView layoutIfNeeded];
        }];
    } else if (self.type == AnimationTypeDismiss) {
        //The modal view itself
        UIView *modalView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            FrameReposition(modalView, left(modalView), height(containerView));
            _coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.coverView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return (self.type == AnimationTypePresent) ? 1.0 : 0.3;
}

@end

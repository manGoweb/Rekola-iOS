//
//  UIAlertView+CompletionBlock.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CompletionBlock) <UIAlertViewDelegate>

- (void)showWithCompletionBlock:(void(^)(UIAlertView * alert, NSInteger buttonIndex))block;

@end

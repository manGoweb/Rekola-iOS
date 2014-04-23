//
//  UIAlertView+CompletionBlock.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "UIAlertView+CompletionBlock.h"
#import <objc/runtime.h>

static const char *kAssociatedObjectKey = "completionBlock";

@implementation UIAlertView (CompletionBlock)

- (void)showWithCompletionBlock:(void (^)(UIAlertView *, NSInteger))block {
    if (block) {
        self.delegate = self;
        objc_setAssociatedObject(self, kAssociatedObjectKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
	[self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	void (^block)(UIAlertView *, NSInteger) = objc_getAssociatedObject(self, kAssociatedObjectKey);
	if (block) {
		block(self, buttonIndex);
	}
    objc_setAssociatedObject(self, kAssociatedObjectKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

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

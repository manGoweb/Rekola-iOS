/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
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

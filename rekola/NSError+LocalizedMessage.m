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

#import "NSError+LocalizedMessage.h"
#import <objc/runtime.h>

NSString *const AFNetworkingOperationMessageURLResponseErrorKey = @"AFNetworkingOperationMessageURLResponseErrorKey";

@implementation NSError (LocalizedMessage)

- (NSString *)localizedMessage {
    if (self.code == -1009) {
        return NSLocalizedString(@"The Internet connection appears to be offline.", @"Text message in Alert View.");
        
    } else if (self.message.length > 0) {
        return self.message;
        
    } else {
        return self.localizedDescription;
    }
}

- (NSError *)message:(NSString *)response {
    id result = self;
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *message = nil;
        
        if ([json isKindOfClass:[NSDictionary class]]) {
            message = json[@"message"];
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
            [userInfo setObject:message forKey:AFNetworkingOperationMessageURLResponseErrorKey];
            result = [[NSError alloc] initWithDomain:self.domain code:self.code userInfo:userInfo];
            
        }
    }
    return result;
}

- (NSString *)message {
    return [[self userInfo] objectForKey:AFNetworkingOperationMessageURLResponseErrorKey];
}

- (NSInteger)statusCode {
    return [[[self userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
}

@end

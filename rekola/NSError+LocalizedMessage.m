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

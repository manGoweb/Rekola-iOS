//
//  NSError+LocalizedMessage.m
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "NSError+LocalizedMessage.h"
#import <objc/runtime.h>

NSString *const AFNetworkingOperationMessageURLResponseErrorKey = @"AFNetworkingOperationMessageURLResponseErrorKey";

@implementation NSError (LocalizedMessage)

- (NSString *)localizedMessage {
    if (self.code == -1009) {
        return NSLocalizedString(@"Připojení k internetu je zřejmě neaktivní.", @"Text message in Alert View.");
        
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

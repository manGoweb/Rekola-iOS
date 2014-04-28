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
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString *message = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        message = json[@"message"];
        NSMutableDictionary *dica = [[NSMutableDictionary alloc] initWithDictionary:[self userInfo]];
        [dica setObject:message forKey:AFNetworkingOperationMessageURLResponseErrorKey];
    }
    
    return self;
}

- (NSString *)message {
    return [[self userInfo] objectForKey:AFNetworkingOperationMessageURLResponseErrorKey];
}

- (NSInteger)statusCode {
    return [[[self userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
}

@end

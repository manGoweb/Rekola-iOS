//
//  NSError+LocalizedMessage.h
//  rekola
//
//  Created by Martin Banas on 28/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (LocalizedMessage)

- (NSInteger)statusCode;
- (NSString *)localizedMessage;
- (NSError *)message:(NSString *)response;

@end

extern NSString *const AFNetworkingOperationMessageURLResponseErrorKey;
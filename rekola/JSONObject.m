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

#import "JSONObject.h"

@implementation JSONObject

- (id)init {
    return [self initWithDictionary:nil];
}

- (id)initWithData:(NSData *)data {
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (error) {
        return nil;
    } else {
        return [self initWithDictionary:dic];
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _dictionary = dictionary;
    }
    return self;
}

#pragma mark - Copying methods

- (id)copyWithZone:(NSZone *)zone {
    [NSException raise:@"Missing implementation" format:@"Implement copyWithZone: in its subclass."];
    return nil;
}


#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", _dictionary];
}

@end

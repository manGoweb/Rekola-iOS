//
//
//  JSONObject.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

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

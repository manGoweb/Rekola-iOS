//
//  RKLocation.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "RKLocation.h"

@implementation RKLocation

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        JSON_PARSE_STRING(_address, @"address");
        JSON_PARSE_STRING(_distance, @"distance");
        JSON_PARSE_STRING(_type, @"type");
        JSON_PARSE_STRING(_note, @"note");
        JSON_PARSE_COORDINATE(_coordinate, @"lat", @"lng");
        
    }
    return self;
}

@end

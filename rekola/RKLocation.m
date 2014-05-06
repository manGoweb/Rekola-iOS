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

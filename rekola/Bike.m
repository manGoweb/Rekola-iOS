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

#import "Bike.h"

@implementation Bike

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        JSON_PARSE_NUMBER(_identifier, @"id");
        JSON_PARSE_STRING(_name, @"name");
        JSON_PARSE_STRING(_bikeDescription, @"description");
        JSON_PARSE_STRING(_issue, @"issue");
        JSON_PARSE_STRING(_lastSeen, @"lastSeen");
        JSON_PARSE_BOOL(_borrowed, @"borrowed");
        JSON_PARSE_BOOL(_operational, @"operational");
        JSON_PARSE_OBJECT(_location, @"location", [RKLocation class])
        
        JSON_PARSE_STRING(_bikeCode, @"bikeCode");
        JSON_PARSE_STRING(_lockCode, @"lockCode");
        
        _title = _name;
        _subtitle = _location.address;
        _coordinate = _location.coordinate;
    }
    return self;
}

@end

//
//  Bike.m
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

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
        _subtitle = _bikeDescription;
        _coordinate = _location.coordinate;
    }
    return self;
}

@end

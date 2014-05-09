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

#import "POI.h"

NSString * NSStringFromPOIType(POIType type) {
    switch (type) {
        case POITypeBay:
            return @"bay";
        case POITypeGrave:
            return @"grave";
        default:
            return nil;
    }
}

@implementation POI

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        JSON_PARSE_STRING(_poiDescription, @"description");
        JSON_PARSE_NUMBER(_identifier, @"id");
        JSON_PARSE_COORDINATE(_coordinate, @"lat", @"lng");
        
        NSString *typeString = nil;
        JSON_PARSE_STRING(typeString, @"type");
        
        if ([typeString isEqualToString:NSStringFromPOIType(POITypeBay)]) {
            _type = POITypeBay;
        } else if ([typeString isEqualToString:NSStringFromPOIType(POITypeGrave)]) {
            _type = POITypeGrave;
        }
        
        _title = _poiDescription;
    }
    return self;
}

@end

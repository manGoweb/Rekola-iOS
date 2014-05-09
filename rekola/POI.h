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

typedef NS_ENUM(NSUInteger, POIType) {
    POITypeBay,
    POITypeGrave
};

@interface POI : JSONObject <MKAnnotation>

@property (nonatomic, strong) NSString *poiDescription;
@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, assign) POIType type;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

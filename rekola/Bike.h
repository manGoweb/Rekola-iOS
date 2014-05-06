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
#import "RKLocation.h"
#import "RKAnnotation.h"

@interface Bike : JSONObject <MKAnnotation>

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bikeDescription;
@property (nonatomic, strong) NSString *issue;
@property (nonatomic, assign) BOOL borrowed;
@property (nonatomic, assign) BOOL operational;
@property (nonatomic, strong) RKLocation *location;
@property (nonatomic, strong) NSString *lastSeen;
@property (nonatomic, strong) NSString *bikeCode;
@property (nonatomic, strong) NSString *lockCode;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

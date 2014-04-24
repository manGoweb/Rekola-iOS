//
//  Bike.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "JSONObject.h"
#import "RKLocation.h"

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
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

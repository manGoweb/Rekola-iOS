//
//  RKLocation.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "JSONObject.h"

@interface RKLocation : JSONObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

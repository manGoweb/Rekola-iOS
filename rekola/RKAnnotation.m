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

#import "RKAnnotation.h"

@implementation RKAnnotation {
    NSMutableArray *__clusterAnnotations;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        __clusterAnnotations = @[].mutableCopy;
    }
    return self;
}

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation {
    self = [self init];
    if (self) {
        _coordinate = [annotation coordinate];
        [__clusterAnnotations addObject:annotation];
        
        if ([annotation respondsToSelector:@selector(title)]) {
            self.title = [annotation title];
        }
        if ([annotation respondsToSelector:@selector(subtitle)]) {
            self.subtitle = [annotation subtitle];
        }
    }
    return self;
}

#pragma mark - Accessors

- (NSArray *)clusterAnnotations {
    return [__clusterAnnotations copy];
}

- (CLLocationCoordinate2D)coordinate {
    if (__clusterAnnotations.count > 0)  {
    
    CLLocationCoordinate2D min = [[__clusterAnnotations firstObject] coordinate];
    CLLocationCoordinate2D max = [[__clusterAnnotations firstObject] coordinate];
        
    for (id<MKAnnotation> annotation in self.clusterAnnotations) {
        min.latitude = MIN(min.latitude, annotation.coordinate.latitude);
        min.longitude = MIN(min.longitude, annotation.coordinate.longitude);
        max.latitude = MAX(max.latitude, annotation.coordinate.latitude);
        max.longitude = MAX(max.longitude, annotation.coordinate.longitude);
    }
    
    CLLocationCoordinate2D center = min;
    center.latitude += (max.latitude-min.latitude) / 2.0;
    center.longitude += (max.longitude-min.longitude) / 2.0;
    
    return center;
        
    } else {
        return CLLocationCoordinate2DMake(0, 0);
    }
}

#pragma mark - Public methods

- (void)addAnnotation:(id<MKAnnotation>)annotation {
    [__clusterAnnotations addObject:annotation];
}

- (void)addAnnotations:(NSArray *)annotations {
    for (id<MKAnnotation> annotation in annotations) {
        [self addAnnotation: annotation];
    }
}

- (void)removeAnnotation:(id<MKAnnotation>)annotation {
    [__clusterAnnotations removeObject:annotation];
}

- (void)removeAnnotations:(NSArray*)annotations {
    for (id<MKAnnotation> annotation in annotations) {
        [self removeAnnotation: annotation];
    }
}

@end

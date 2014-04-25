//
//  RKAnnotation.h
//  rekola
//
//  Created by Martin Banas on 25/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readonly) NSArray *clusterAnnotations;

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation;
- (void)addAnnotation:(id<MKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;
- (void)removeAnnotation:(id<MKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray*)annotations;

@end

//
//  RKMapView.h
//  rekola
//
//  Created by Martin Banas on 25/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface RKMapView : MKMapView

@property (nonatomic, assign) BOOL clusteringEnabled;
@property (nonatomic, readonly) NSArray *visibleAnnotations;
@property (nonatomic, assign) CLLocationDistance clusterSize;

- (void)clusterAnnotations;
- (void)clearAnnotations;

@end

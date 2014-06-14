/**
 * This source code can be used only for purposes specified by the given Apache License.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 Inmite s.r.o. (www.inmite.eu)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "RKMapView.h"
#import "RKAnnotation.h"

CGFloat const DefaultLatitude = 50.079167;
CGFloat const DefaultLongtitude = 14.428414;
CGFloat const DefaultUserZoom = 2500;
CGFloat const DefaultDistance = 3500;

@implementation RKMapView {
    NSMutableSet *_allAnnotations;
    MKCoordinateRegion _lastMapRegion;
    MKMapRect _lastMapRect;
    
    BOOL _needsClusturing;
    
    CLLocationDistance _clusterSize;
    CLLocationDegrees _minClusterDelta;
    NSUInteger _minAnnotationsForCluster;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _allAnnotations = [NSMutableSet new];
    _clusterSize = 0.2;
    _minClusterDelta = 0.;
    _minAnnotationsForCluster = 4;
    
    _clusteringEnabled = YES;
    _needsClusturing = YES;

    // CR region
    // span (latitudeDelta = 6.60817772436409, longitudeDelta = 7.2027526803690023)
    // center (latitude = 49.826988220214851, longitude = 15.472262382507363)
    
}

#pragma mark - MKMapView Accessors

- (void)addAnnotation:(id < MKAnnotation >)annotation {
    [_allAnnotations addObject:annotation];
    _needsClusturing = YES;
    [self clusterAnnotations];
}

- (void)addAnnotations:(NSArray *)annotations {
    [_allAnnotations addObjectsFromArray:annotations];
    _needsClusturing = YES;
    [self clusterAnnotations];
}

- (void)removeAnnotation:(id < MKAnnotation >)annotation {
    [_allAnnotations removeObject:annotation];
    _needsClusturing = YES;
    [self clusterAnnotations];
}

- (void)removeAnnotations:(NSArray *)annotations{
    for (id<MKAnnotation> annotation in annotations) {
        [_allAnnotations removeObject:annotation];
    }
    _needsClusturing = YES;
    [self clusterAnnotations];
}

- (NSArray *)annotations {
    return [_allAnnotations allObjects];
}

- (NSArray *)displayedAnnotations {
    return super.annotations;
}

- (void)clearAnnotations {
    _allAnnotations = [NSMutableSet new];
    [super removeAnnotations:[self displayedAnnotations]];
}

#pragma mark - Private methods

- (BOOL)mapDidZoom {
    return (fabs(_lastMapRect.size.width - self.visibleMapRect.size.width) > 0.1f);
}

- (BOOL)mapDidMove {
    CGPoint lastPoint = [self convertCoordinate:_lastMapRegion.center toPointToView:self];
    CGPoint currentPoint = [self convertCoordinate:self.region.center toPointToView:self];
    
    return ((fabs(lastPoint.x - currentPoint.x) > self.frame.size.width / 3.0) ||
            (fabs(lastPoint.y - currentPoint.y) > self.frame.size.height / 3.0));
}

- (void)centerByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate {
    CGPoint point = [self convertCoordinate:coordinate toPointToView:self];
    point.x += offset.x;
    point.y += offset.y;
    [self setCenterCoordinate:[self convertPoint:point toCoordinateFromView:self] animated:YES];
}

#pragma mark - Clustering

- (void)clusterAnnotations {
    
    if (_needsClusturing || MKMapRectIsNull(_lastMapRect) || [self mapDidZoom] || [self mapDidMove]) {

        NSMutableArray *annotations = [_allAnnotations allObjects].mutableCopy;
        //[self annotationsForVisibleRect:[_allAnnotations allObjects]].mutableCopy;
        NSArray *clusteredAnnotations = nil;
        
        if (_clusteringEnabled && (self.region.span.longitudeDelta > _minClusterDelta)) {
            CLLocationDistance clusterRadius = self.region.span.longitudeDelta * _clusterSize;
            clusteredAnnotations = [self clusteringWithAnnotations:annotations clusterRadius:clusterRadius];
            
        } else {
            clusteredAnnotations = annotations;
        }
        
        NSMutableArray *annotationsToDisplay = clusteredAnnotations.mutableCopy;
        
        for (NSUInteger i = 0; i < annotationsToDisplay.count; i++) {
            RKAnnotation *ann = annotationsToDisplay[i];
            if ([ann isKindOfClass:[RKAnnotation class]] && ann.clusterAnnotations.count < _minAnnotationsForCluster) {
                [annotationsToDisplay removeObject:ann];
                [annotationsToDisplay addObjectsFromArray:ann.clusterAnnotations];
                i--;
            }
        }
        
        for (id<MKAnnotation> annotation in self.displayedAnnotations) {
            if (annotation == self.userLocation) {
                continue;
            }
            
            if (![annotationsToDisplay containsObject:annotation]) {
                [super removeAnnotation:annotation];
                
            } else {
                [annotationsToDisplay removeObject:annotation];
            }
        }
        
        [super addAnnotations:annotationsToDisplay];

        _lastMapRect = self.visibleMapRect;
        _lastMapRegion = self.region;
        _needsClusturing = NO;
    }
}

#pragma mark - Helpers

- (NSArray *)annotationsForVisibleRect:(NSArray *)originAnnotations {
    
    NSMutableArray *annotations = @[].mutableCopy;
    
    CLLocationDistance a = self.region.span.latitudeDelta / 4;
    CLLocationDistance b = self.region.span.longitudeDelta / 4;
    CLLocationDistance radius = sqrt(pow(a, 2.0) + pow(b, 2.0));
    
    for (id<MKAnnotation> annotation in originAnnotations) {
        if ((CLLocationCoordinateDistance(annotation.coordinate, self.centerCoordinate) <= radius)) {
            [annotations addObject:annotation];
        }
    }
    return annotations;
}

- (NSArray *)clusteringWithAnnotations:(NSArray*)annotations clusterRadius:(CLLocationDistance)radius {
    
    NSMutableArray *clusteredAnnotations = @[].mutableCopy;
    
	for (id <MKAnnotation> annotation in annotations) {
		BOOL foundCluster = NO;
        for (RKAnnotation *ann in clusteredAnnotations) {
            if ((CLLocationCoordinateDistance([annotation coordinate], ann.coordinate) <= radius)) {
                foundCluster = YES;
                [ann addAnnotation:annotation];
                break;
            }
        }
        
        if (!foundCluster){
            RKAnnotation *newCluster = [[RKAnnotation alloc] initWithAnnotation:annotation];
            [clusteredAnnotations addObject:newCluster];
        }
	}
    
    NSMutableArray *results = @[].mutableCopy;
    for (RKAnnotation *ann in clusteredAnnotations) {
        if (ann.clusterAnnotations.count == 1) {
            [results addObject:[ann.clusterAnnotations lastObject]];
        } else if (ann.clusterAnnotations.count > 1) {
            [results addObject:ann];
        }
    }
    return results;
}

double CLLocationCoordinateDistance(CLLocationCoordinate2D c1, CLLocationCoordinate2D c2) {
    return sqrt(pow(c1.latitude  - c2.latitude , 2.0) + pow(c1.longitude - c2.longitude, 2.0));
}

@end

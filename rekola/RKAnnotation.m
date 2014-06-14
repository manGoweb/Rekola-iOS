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

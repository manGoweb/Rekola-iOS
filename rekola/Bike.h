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
@property (nonatomic, strong) UIColor *backgroundColor;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

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

#import "Bike.h"

@implementation Bike

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        
        JSON_PARSE_NUMBER(_identifier, @"id");
        JSON_PARSE_STRING(_name, @"name");
        JSON_PARSE_STRING(_bikeDescription, @"description");
        JSON_PARSE_STRING(_issue, @"issue");
        JSON_PARSE_STRING(_lastSeen, @"lastSeen");
        JSON_PARSE_BOOL(_borrowed, @"borrowed");
        JSON_PARSE_BOOL(_operational, @"operational");
        JSON_PARSE_OBJECT(_location, @"location", [RKLocation class])
        
        JSON_PARSE_STRING(_bikeCode, @"bikeCode");
        JSON_PARSE_STRING(_lockCode, @"lockCode");
        
        NSString *stringColor = nil;
        JSON_PARSE_STRING(stringColor, @"backgroundColor");
        
        if (stringColor) {
            stringColor = [stringColor substringFromIndex:1];
            
            NSUInteger hexColor;
            if ([[NSScanner scannerWithString:stringColor] scanHexInt:&hexColor]) {
                _backgroundColor = COLOR(hexColor);
            }
        }
        
        _title = _name;
        _subtitle = _location.address;
        _coordinate = _location.coordinate;
    }
    return self;
}

@end

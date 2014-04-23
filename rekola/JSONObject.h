//
//  JSONObject.h
//  rekola
//
//  Created by Martin Banas on 23/04/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

// Convenience macros for clean object init, robust parse and high performance.

#define JSON_KEYPATH_OBJECT(__keypath) json_keypath_object(_dictionary, __keypath)

#define JSON_PARSE_STRING(__ivar, __keypath) { \
    __ivar = nil; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        if ([obj isKindOfClass:[NSString class]]) { \
            __ivar = obj; \
        } else if ([obj isKindOfClass:[NSNumber class]]) { \
            __ivar = [obj stringValue]; \
        } \
    } \
}

#define JSON_PARSE_NUMBER(__ivar, __keypath) { \
    __ivar = nil; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        if ([obj isKindOfClass:[NSNumber class]]) { \
            __ivar = obj; \
        } else if ([obj isKindOfClass:[NSString class]]) { \
            __ivar = @([obj doubleValue]); \
        } \
    } \
}

#define JSON_PARSE_BOOL(__ivar, __keypath) { \
    __ivar = NO; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        if ([obj isKindOfClass:[NSNumber class]] || [obj isKindOfClass:[NSString class]]) { \
            __ivar = [obj boolValue]; \
        } \
    } \
}


#define JSON_PARSE_URL(__ivar, __keypath) { \
    __ivar = nil; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        if ([obj isKindOfClass:[NSString class]]) { \
            __ivar = [NSURL URLWithString:obj]; \
        } \
    } \
}

#define JSON_PARSE_DATE(__ivar, __keypath) _json_parse_date(__ivar, __keypath, @"yyyy-MM-dd HH:mm:ss");

#define JSON_PARSE_DATE_FORMAT(__ivar, __keypath, __format) _json_parse_date(__ivar, __keypath, __format);

#define _json_parse_date(__ivar, __keypath, __format) { \
    __ivar = nil; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        static NSDateFormatter *__df = nil; \
        static NSString *__ldf = nil; \
        \
        if (__df == nil) { \
            __df = [[NSDateFormatter alloc] init]; \
        } \
        \
        if (![__ldf isEqualToString:__format]) { \
            __ldf = __format; \
            [__df setDateFormat:__format]; \
        } \
        \
        if ([obj isKindOfClass:[NSNumber class]]) { \
            NSUInteger length = [[obj stringValue] length];\
            if (length <= 10) { \
                __ivar = [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]]; \
            } else if (length <= 13) { \
                __ivar = [NSDate dateWithTimeIntervalSince1970:([obj longLongValue] / 1000)]; \
            } \
        } else if ([obj isKindOfClass:[NSString class]]) { \
            __ivar = [__df dateFromString:obj]; \
        } \
    } \
}

#define JSON_PARSE_OBJECTS(__ivar, __keypath, __class) { \
    __ivar = nil; \
    id objs = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (objs) { \
        NSMutableArray *children = @[].mutableCopy; \
        BOOL isCompatibleJSONClass = [__class isSubclassOfClass:[JSONObject class]]; \
        \
        [objs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { \
            if (obj != [NSNull null]) { \
                if ([obj isKindOfClass:[NSDictionary class]] && isCompatibleJSONClass) { \
                    [children addObject:[(id)[__class alloc] initWithDictionary:obj]]; \
                } else if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) { \
                    [children addObject:obj]; \
                } \
            } \
        }]; \
        \
        __ivar = children.copy; \
    } \
}

#define JSON_PARSE_OBJECT(__ivar, __keypath, __class) { \
    __ivar = nil; \
    id obj = JSON_KEYPATH_OBJECT(__keypath); \
    \
    if (obj) { \
        if ([obj isKindOfClass:[NSDictionary class]]) { \
            __ivar = [[__class alloc] initWithDictionary:obj]; \
        } \
    } \
}

#define JSON_PARSE_COORDINATE(__ivar, __keypath_lat, __keypath_lng) { \
    __ivar = (CLLocationCoordinate2D) { 0, 0 }; \
    id latObj = JSON_KEYPATH_OBJECT(__keypath_lat); \
    id lngObj = JSON_KEYPATH_OBJECT(__keypath_lng); \
    \
    if ([latObj isKindOfClass:[NSNumber class]] && [lngObj isKindOfClass:[NSNumber class]]) { \
        __ivar = (CLLocationCoordinate2D) { [latObj doubleValue], [lngObj doubleValue] }; \
    } \
}

// Remove compiler warning for unused function which is used in macros above.
static id json_keypath_object(NSDictionary *dic, NSString *keypath) __attribute__((unused));

static id json_keypath_object(NSDictionary *dic, NSString *keypath) {
    id retVal = nil;
    
    if (dic && keypath.length > 0) {
        @try {
            retVal = [dic valueForKeyPath:keypath];
        }
        @catch (NSException * e) {
            NSLog(@"JSON Keypath Exception: %@", e);
        }
    }

    return retVal;
}


@interface JSONObject : NSObject <NSCopying> {
    NSDictionary *_dictionary;
}

// Initializer with raw data.
- (instancetype)initWithData:(NSData *)data;

// Designated initializer.
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

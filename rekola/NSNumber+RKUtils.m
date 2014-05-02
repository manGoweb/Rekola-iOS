//
//  NSNumber+RKUtils.m
//  rekola
//
//  Created by Martin Banas on 02/05/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "NSNumber+RKUtils.h"

static CGFloat const KilometersCoefficient = 0.001;
static CGFloat const FeetCoefficient = 3.2808399;
static CGFloat const YardsCoefficient = 1.0936133;
static CGFloat const MilesCoefficient = 0.000621371192;

static inline CGFloat DistanceToKilometers(CLLocationDistance distance) {
    return distance * KilometersCoefficient;
}

static inline CGFloat DistanceToFeet(CLLocationDistance distance) {
    return distance * FeetCoefficient;
}

static inline CGFloat DistanceToYards(CLLocationDistance distance) {
    return distance * YardsCoefficient;
}

static inline CGFloat DistanceToMiles(CLLocationDistance distance) {
    return distance * MilesCoefficient;
}

@implementation NSNumber (RKUtils)

- (NSString *)formattedDistance {
    
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 0;
        numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
        numberFormatter.locale = [NSLocale currentLocale];
    });
    
    NSString *distanceString = @"";
    NSString *unitString = @"";
    
    if ([[[NSLocale currentLocale] objectForKey:NSLocaleUsesMetricSystem] boolValue]) {
        CGFloat kmDistance = DistanceToKilometers([self doubleValue]);
        if (kmDistance >= 1) {
            distanceString = [numberFormatter stringFromNumber:@(kmDistance)];
            unitString = NSLocalizedString(@"km", @"Kilometer unit");
        } else {
            distanceString = [numberFormatter stringFromNumber:self];
            unitString = NSLocalizedString(@"m", @"Meter unit");
        }
        
    } else {
        CGFloat feetDistance = DistanceToFeet([self doubleValue]);
        CGFloat yardDistance = DistanceToYards([self doubleValue]);
        CGFloat milesDistance = DistanceToMiles([self doubleValue]);
        
        if (feetDistance < 300) {
            distanceString = [numberFormatter stringFromNumber:@(feetDistance)];
            unitString = NSLocalizedString(@"ft", @"Feet unit");
            
        } else if (yardDistance < 500) {
            distanceString = [numberFormatter stringFromNumber:@(yardDistance)];
            unitString = NSLocalizedString(@"yds", @"Yard unit");

        } else {
            distanceString = [numberFormatter stringFromNumber:@(milesDistance)];
            unitString = (milesDistance > 1.0 && milesDistance < 1.1) ? NSLocalizedString(@"mile", @"Mile Unit") : NSLocalizedString(@"miles", @"Mile Unit");
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@",distanceString, unitString];
}

- (NSString *)formattedDuration {
    NSDate *date = [NSDate date];
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:[self doubleValue]];
    
    NSUInteger flags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:date toDate:newDate options:0];
    
    NSInteger days = components.day;
    NSInteger hours = components.hour;
    NSInteger minutes = components.minute;
    
    NSMutableString *duration = [NSMutableString new];
    if (days >= 1) {
        NSInteger newHours = (minutes >= 30)? hours++ : hours;
        [duration appendString:[NSString stringWithFormat:@"%i%@%@",days, NSLocalizedString(@"d", @"Time Unit"), (newHours >= 1)? @" " : @""]];
        
        if (hours >= 1) {
            [duration appendString:[NSString stringWithFormat:@"%i%@",newHours, NSLocalizedString(@"hr", @"Time Unit")]];
        }
        
    } else {
        if (hours >= 1) {
            [duration appendString:[NSString stringWithFormat:@"%i%@%@",hours, NSLocalizedString(@"hr", @"Time Unit"), (minutes >= 1)? @" " : @""]];
        }
        if (minutes >= 1) {
            [duration appendString:[NSString stringWithFormat:@"%i%@",minutes, NSLocalizedString(@"min", @"Time Unit")]];
        }
    }
    
    return duration;
}

@end

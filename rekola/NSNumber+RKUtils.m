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
    static NSNumberFormatter *numberFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.maximumFractionDigits = 0;
        numberFormatter.locale = [NSLocale currentLocale];
    });
    
//    CGFloat seconds = [self doubleValue];
//    CGFloat minutes = seconds / 60;
//    CGFloat days = 0;
//    CGFloat years = 0;
    
    
    return @"";
}

@end

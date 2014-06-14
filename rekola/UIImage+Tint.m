/**
 *  Copyright (c) 2013, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified 
 * by the given license contract signed by the rightful deputy of Inmite s.r.o. 
 * This source code can be used only by the owner of the license.
 * 
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import "UIImage+Tint.h"

@implementation UIImage (Tint)

- (UIImage *)tintWithColor:(UIColor *)color {
    return [self tintWithColor:color fraction:0.0];
}

- (UIImage *)tintWithColor:(UIColor *)color fraction:(CGFloat)fraction {
    UIImage *image = self;
    
    if (self && color) {
        CGRect rect = (CGRect) { CGPointZero, [self size] };
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.f);
        
        [color set];
        UIRectFill(rect);
        
        [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0];
        
        if (fraction > 0.0) {
            [self drawInRect:rect blendMode:kCGBlendModeSourceAtop alpha:fraction];
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

@end

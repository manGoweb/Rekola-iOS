/**
 *  Copyright (c) 2014, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */

#import "POIDetailView.h"

@implementation POIDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    _indicatorView.hidden = YES;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"route", @"A button title somewhere on the screen")];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, title.length)];

    [_directionButton setAttributedTitle:title forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)showDetail:(id)sender {
    if ([_delegate respondsToSelector:@selector(POIDetailWillOpenDetail:)]) {
        [_delegate performSelector:@selector(POIDetailWillOpenDetail:) withObject:self];
    }
}

- (IBAction)dismissView:(id)sender {
    if ([_delegate respondsToSelector:@selector(POIDetailWillDismiss:)]) {
        [_delegate performSelector:@selector(POIDetailWillDismiss:) withObject:self];
    }
}

- (IBAction)findDirections:(id)sender {
    if ([_delegate respondsToSelector:@selector(POIDetailWillFindDirections:)]) {
        [_delegate performSelector:@selector(POIDetailWillFindDirections:) withObject:self];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(_closeButton.frame, point)) {
        return YES;
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end

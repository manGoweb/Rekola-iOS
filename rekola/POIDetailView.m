//
//  POIDetailView.m
//  rekola
//
//  Created by Martin Banas on 02/05/14.
//  Copyright (c) 2014 Martin Banas. All rights reserved.
//

#import "POIDetailView.h"

@implementation POIDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    _indicatorView.hidden = YES;
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

@end

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

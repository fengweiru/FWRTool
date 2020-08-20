//
//  UIButton+ExpandClick.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/20.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "UIButton+ExpandClick.h"

@implementation UIButton (ExpandClick)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.hidden || self.alpha == 0 || self.userInteractionEnabled == NO || self.enabled == NO) {
        return NO;
    }
    
    CGRect bounds = self.bounds;
    CGFloat width = self.f_width-44;
    CGFloat height = self.f_height-44;
    if (width > 0) {
        width = 0;
    }
    if (height > 0) {
        height = 0;
    }
    bounds = CGRectInset(bounds, width, height);
    return CGRectContainsPoint(bounds, point);
}

@end

//
//  UIColor+Conversion.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/12.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "UIColor+Conversion.h"

@implementation UIColor (Conversion)

- (NSArray *)getRGBArray
{
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    return @[[NSNumber numberWithFloat:r*255.0],[NSNumber numberWithFloat:g*255.0],[NSNumber numberWithFloat:b*255.0]];
}

- (NSArray *)getHSBArray
{
    CGFloat h, s, b, a;
    [self getHue:&h saturation:&s brightness:&b alpha:&a];
    return @[[NSNumber numberWithFloat:h*360.0],[NSNumber numberWithFloat:s*100.0],[NSNumber numberWithFloat:b*100.0]];
}

@end

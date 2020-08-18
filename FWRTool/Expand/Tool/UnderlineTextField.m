//
//  UnderlineTextField.m
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/8.
//  Copyright © 2020 Toman. All rights reserved.
//

#import "UnderlineTextField.h"

@implementation UnderlineTextField


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, FColor(0x99, 0x99, 0x99).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.6, CGRectGetWidth(self.frame), 0.6));
}


@end

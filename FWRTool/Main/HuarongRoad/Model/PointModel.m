//
//  PointModel.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "PointModel.h"

@implementation PointModel

+ (instancetype)makePointWithX:(NSInteger)x y:(NSInteger)y
{
    PointModel *model = [[self alloc]init];
    model.x = x;
    model.y = y;
    return model;
}

@end

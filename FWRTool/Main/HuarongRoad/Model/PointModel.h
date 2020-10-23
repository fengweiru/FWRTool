//
//  PointModel.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PointModel : NSObject

+ (instancetype)makePointWithX:(NSInteger)x y:(NSInteger)y;

@property (nonatomic, assign) NSInteger x;   //在二维数组种代表纵坐标
@property (nonatomic, assign) NSInteger y;   //在二维数组种代表横坐标

@end

NS_ASSUME_NONNULL_END

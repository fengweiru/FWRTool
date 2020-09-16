//
//  RulerView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/16.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RulerType;
@interface RulerView : UIView

- (instancetype)initWithRulerType:(RulerType *)rulerType;

+ (CGFloat)getRulerWidth;

@end

@interface RulerType : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) NSInteger unitType;  //单位：0 cm，1 inch

@end

NS_ASSUME_NONNULL_END

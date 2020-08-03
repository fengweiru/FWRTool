//
//  FWRMagnifierView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/3.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FWRMagnifierView : UIWindow

@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, assign) CGPoint renderPoint;

@end

NS_ASSUME_NONNULL_END

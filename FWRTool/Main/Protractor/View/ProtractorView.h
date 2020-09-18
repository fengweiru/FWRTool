//
//  ProtractorView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/17.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ProtractorViewDelegate <NSObject>

- (void)showAngle:(CGFloat)angle;

@end

@interface ProtractorView : UIView

@property (nonatomic, assign) id<ProtractorViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

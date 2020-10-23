//
//  PersonView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/19.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointModel.h"

NS_ASSUME_NONNULL_BEGIN

@class PersonView;

@protocol PersonViewDelegate <NSObject>

- (void)swipeWithSwipeGesture:(UISwipeGestureRecognizer *)swipeG personView:(PersonView *)personView;

@end

@interface PersonView : UIView

@property (nonatomic, assign) id<PersonViewDelegate> delegate;

@property (nonatomic, assign) NSInteger type; //类型0四格正方形，1单格，2两格长方形横，3两格长方形竖
@property (nonatomic, assign) NSInteger sign;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray *pointArr;

@end

NS_ASSUME_NONNULL_END

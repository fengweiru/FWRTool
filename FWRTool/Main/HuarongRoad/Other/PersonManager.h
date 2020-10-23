//
//  PersonManager.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonManager : NSObject

@property (nonatomic, assign) NSInteger type; //类型：0兵分三路，1兵临城下，2兵屯东路，3层层设防，4插翅难飞，5过五关，6横刀立马，7水泄不通，8天罗地网

- (instancetype)init;

- (BOOL)couldMoveWithPersonView:(PersonView *)personView direct:(UISwipeGestureRecognizerDirection)direct;

@end

NS_ASSUME_NONNULL_END

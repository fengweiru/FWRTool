//
//  NetworkMeasure.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/26.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkMeasure : NSObject

+ (instancetype)shareClient;

//开始检测
- (void)startMonitor;

//停止检测
- (void)stopMonitor;

@property (assign, nonatomic) float wwanSend;

@property (assign, nonatomic) float wwanReceived;

@property (assign, nonatomic) float wifiSend;

@property (assign, nonatomic) float wifiReceived;

@end

NS_ASSUME_NONNULL_END

//
//  HeartRateManager.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/14.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HeartRateManagerDelegate <NSObject>

- (void)startHeartDelegateRatePoint:(NSDictionary *)point;
@optional
- (void)startHeartDelegateRateError:(NSError *)error;
- (void)startHeartDelegateRateFrequency:(NSInteger)frequency;
@end

@interface HeartRateManager : NSObject

@property (copy, nonatomic) void ((^backPoint)(NSDictionary *));
@property (copy, nonatomic) void ((^frequency)(NSInteger ));
@property (copy, nonatomic) void ((^Error)(NSError *));
@property (assign, nonatomic) id <HeartRateManagerDelegate> delegate;



/**
 *  单例
 */
+ (instancetype)shareManager;



- (void)start;

/**
 *  调用摄像头测心率方法
 *
 *  @param backPoint 浮点和时间戳的 实时回调
 *                 * 数据类型   字典
 *                 * 数据格式   {  "1473386373135.52" = "0.3798618"; }
 *                      * 字典Key:     NSNumber类型double浮点数->时间戳  小数点前精确到毫秒
 *                      * 字典Value:   NSNumber类型float浮点数，数据未处理全部返回
 *  @param frequency 返回心率
 *  @param error     错误信息
 */
- (void)startHeartRatePoint:(void(^)(NSDictionary *point))backPoint
                  Frequency:(void(^)(NSInteger fre))frequency
                      Error:(void(^)(NSError *error))error;

/**
 *  结束方法
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END

//
//  AliOSSManager.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/8.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AliOSSManagerDelegate <NSObject>

- (void)downloadComplete:(BOOL)success;
- (void)uploadComplete:(BOOL)success;

@end

@interface AliOSSManager : NSObject

+ (instancetype)shareManager;

@property (nonatomic, assign) id<AliOSSManagerDelegate> delegate;

- (void)testDownload;
- (void)testUpload;

@end

NS_ASSUME_NONNULL_END

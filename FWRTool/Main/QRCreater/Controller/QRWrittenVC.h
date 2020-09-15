//
//  QRWrittenVC.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/15.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QRWrittenVCDelegate <NSObject>

- (void)writtenString:(NSString *)string;

@end

@interface QRWrittenVC : BaseViewController

- (instancetype)initWithString:(NSString *)string;

@property (nonatomic, assign) id<QRWrittenVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

//
//  CommonClass.h
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/12.
//  Copyright © 2020 Toman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonClass : NSObject

///*判断是否是手机号*/
//+ (BOOL)checkPhoneNum:(NSString *)str withView:(UIView *)view;
///*判断密码格式*/
//+ (BOOL)checkPassword:(NSString *)str  withView:(UIView *)view;
///*去除字符串前后空格和回车*/
//+ (NSString *)getStringWithoutwhitespaceAndNewline:(NSString *)string;

/*将UIColor转换成16进制字符串*/
+ (NSString *)toStrByUIColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END

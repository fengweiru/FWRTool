//
//  CommonClass.m
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/12.
//  Copyright © 2020 Toman. All rights reserved.
//

#import "CommonClass.h"

@implementation CommonClass

//+ (BOOL)checkPhoneNum:(NSString *)str withView:(UIView *)view
//{
//    
//    if ([str length] == 0) {
//        [view makeToast:@"请输入手机号"];
//        return NO;
//        
//    }
//    
//    NSString *regex = REGEXP_PHONE;
//    
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    
//    BOOL isMatch = [pred evaluateWithObject:str];
//    
//    if (!isMatch) {
//        
//        [view makeToast:@"请输入正确的手机号"];
//        return NO;
//        
//    }
//    return YES;
//}
//
//+ (BOOL)checkPassword:(NSString *)str  withView:(UIView *)view
//{
//    
//    if ([str length] == 0) {
//        [view makeToast:@"请输入密码"];
//        return NO;
//        
//    }
//    
//    NSString *regex = REGEXP_PASSWORD;
//    
//    
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    BOOL isMatch = [pred evaluateWithObject:str];
//    
//    if (!isMatch) {
//        
//        [view makeToast:@"密码为6-16位英文或数字，请重新输入"];
//        return NO;
//        
//    }
//    return YES;
//}
//
//+ (NSString *)getStringWithoutwhitespaceAndNewline:(NSString *)string
//{
//    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    return [string stringByTrimmingCharactersInSet:set];
//}

+ (NSString *)toStrByUIColor:(UIColor *)color {

    CGFloat r, g, b, a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"#%06x", rgb];

}

#pragma mark -- 根据颜色块生成图像
+ (UIImage *)createImageWithColor:(UIColor *)color withFrame:(CGRect)frame
{
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end

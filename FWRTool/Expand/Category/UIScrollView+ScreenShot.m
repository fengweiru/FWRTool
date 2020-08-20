//
//  UIScrollView+ScreenShot.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/20.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "UIScrollView+ScreenShot.h"

@implementation UIScrollView (ScreenShot)

- (UIImage *)screenShot
{
    UIScrollView *shadowView = (UIScrollView *)self;
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(shadowView.contentSize, NO, 0.f);
    // 保存现在视图的位置偏移信息
    CGPoint saveContentOffset = shadowView.contentOffset;
    // 保存现在视图的frame信息
    CGRect saveFrame = shadowView.frame;
    // 把要截图的视图偏移量设置为0
    shadowView.contentOffset = CGPointZero;
    // 设置要截图的视图的frame为内容尺寸大小
    shadowView.frame = CGRectMake(0, 0, shadowView.contentSize.width, shadowView.contentSize.height);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [shadowView.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [shadowView drawViewHierarchyInRect:shadowView.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 将视图的偏移量设置回原来的状态
    shadowView.contentOffset = saveContentOffset;
    // 将视图的frame信息设置回原来的状态
    shadowView.frame = saveFrame;
    // 保存相册
//    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
    
    return image;
}

@end

//
//  WebViewBrowseVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/20.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "WebViewBrowseVC.h"
#import <WebKit/WebKit.h>
#import "UIScrollView+ScreenShot.h"
#import "ScreenImageBrowseVC.h"

@interface WebViewBrowseVC ()

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) WKWebView *webview;

@end

@implementation WebViewBrowseVC

- (WKWebView *)webview
{
    if (!_webview) {
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, kScreenH-Height_For_AppHeader)];
    }
    return _webview;
}

- (instancetype)initWithUrlStr:(NSString *)urlString
{
    if (self = [super init]) {
        self.urlStr = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavRightItemWithTitle:@"截图"];
    
    [self.view addSubview:self.webview];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webview loadRequest:urlReq];
}

- (void)clickRightItem:(UIButton *)sender
{
//    UIScrollView *scrollView = self.webview.scrollView;
//    UIImage *image = [scrollView screenShot];
    
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.webview.f_size, NO, 0.f);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [self.webview.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
    // [shadowView drawViewHierarchyInRect:shadowView.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    
    ScreenImageBrowseVC *vc = [[ScreenImageBrowseVC alloc] initWithImage:image];
    [self.navigationController pushViewController:vc animated:true];
}

@end

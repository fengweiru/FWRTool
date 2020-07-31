//
//  WKWebViewVC.m
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/22.
//  Copyright © 2020 Toman. All rights reserved.
//

#import "WKWebViewVC.h"
#import <WebKit/WebKit.h>

@interface WKWebViewVC ()<WKNavigationDelegate,WKUIDelegate>
{
    NSString *_urlString;
    
    int      _type;  // 1:push;2:present
}

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation WKWebViewVC

- (instancetype)initWithURLString:(NSString *)urlString AndTitle:(nonnull NSString *)title
{
    if (self = [super init]) {
        _urlString = urlString;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self UIConfig];
}

- (void)UIConfig
{
    [self setNavLeftBackItem];
    
    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    [self.view addSubview:_wkWebView];
    [_wkWebView loadFileURL:[NSURL fileURLWithPath:_urlString] allowingReadAccessToURL:[NSURL fileURLWithPath:_urlString]];
            
    //        [self setCustomUserAngentWithVersion];
            
//            __weak UIWKWebViewController *weakSelf = self;
//
//            _wkBridge = [WKmCloudJSBridge bridgeForWebView:_wkWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//            }];
//
//            [_wkBridge send:[NSDictionary dictionaryWithObject:ApiVersion forKey:@"version"] responseCallback:^(id response) {
//
//            }];
//
//            [_wkBridge registerHandler:@"setTitle" handler:^(id data, WVJBResponseCallback responseCallback) {
//                [weakSelf JSSetTitle:data];//回调本地函数
//            }];
//
//            [_wkBridge registerHandler:@"close" handler:^(id data, WVJBResponseCallback responseCallback) {
//                [weakSelf JSClose:data];//回调本地函数
//            }];
//
//            [_wkBridge registerHandler:@"showServiceMessage" handler:^(id data, WVJBResponseCallback responseCallback) {
//                [weakSelf showServiceMessage:data];//回调本地函数
//            }];
}

@end

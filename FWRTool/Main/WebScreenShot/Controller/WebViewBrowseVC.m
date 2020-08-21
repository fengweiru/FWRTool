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
#import "PPSnapshotHandler.h"

@interface WebViewBrowseVC ()<PPSnapshotHandlerDelegate>

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
    self.title = self.urlStr;
    [self setNavRightItemWithTitle:@"截图"];
    
    [self.view addSubview:self.webview];
    
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webview loadRequest:urlReq];
}

- (void)clickRightItem:(UIButton *)sender
{
//    UIScrollView *scrollView = self.webview.scrollView;
//    UIImage *image = [scrollView screenShot];
    PPSnapshotHandler.defaultHandler.delegate = self;
    [PPSnapshotHandler.defaultHandler snapshotForView:self.webview];
}

#pragma mark - PPSnapshotHandlerDelegate

- (void)snapshotHandler:(PPSnapshotHandler *)snapshotHandler didFinish:(UIImage *)captureImage forView:(UIView *)view
{
    PPSnapshotHandler.defaultHandler.delegate = nil;

    ScreenImageBrowseVC *vc = [[ScreenImageBrowseVC alloc] initWithImage:captureImage];
    [self.navigationController pushViewController:vc animated:true];
}

@end

//
//  QRScanShowVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/15.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "QRScanShowVC.h"

@interface QRScanShowVC ()

@property (nonatomic, strong) UITextView *contentView;

@end

@implementation QRScanShowVC

- (UITextView *)contentView
{
    if (!_contentView) {
        _contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, kScreenH-Height_For_AppHeader)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.editable = false;
    }
    return _contentView;
}

- (instancetype)initWithContent:(NSString *)content
{
    if (self = [super init]) {
        self.contentView.text = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"扫描结果";
    if ([self isUrlAddress:self.contentView.text]) {
        [self setNavRightItemWithTitle:@"打开网址"];
    }
    
    [self.view addSubview:self.contentView];
}

- (void)clickRightItem:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:self.contentView.text];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (BOOL)isUrlAddress:(NSString*)url
{
    NSString*reg =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";

    NSPredicate*urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];

    return [urlPredicate evaluateWithObject:url];

}

@end

//
//  WebScreenShotVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/20.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "WebScreenShotVC.h"
#import "UIButton+ExpandClick.h"
#import "WebViewBrowseVC.h"

@interface WebScreenShotVC ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation WebScreenShotVC

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, Height_For_AppHeader+20, kScreenW-60, 50)];
        _titleLabel.text = @"请输入网址..";
    }
    return _titleLabel;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(30, self.titleLabel.f_bottom, kScreenW-60, 150)];
        _textView.layer.cornerRadius = 5;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.font = FFontRegular(18);
        _textView.clearsOnInsertion = true;
        _textView.delegate = self;
        
    }
    return _textView;
}
- (UIButton *)clearButton
{
    if (!_clearButton) {
        _clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame = CGRectMake(self.textView.f_x+self.textView.f_width-30, self.textView.f_y+self.textView.f_height-30, 20, 20);
        [_clearButton setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
        _clearButton.hidden = true;
        [_clearButton addTarget:self action:@selector(clearText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(30, self.textView.f_bottom+50, kScreenW-60, 50);
        _button.layer.cornerRadius = 5;
        [_button setBackgroundColor:FColor(0x33, 0xcc, 0xff)];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"打开网页" forState:UIControlStateNormal];
        
        [_button addTarget:self action:@selector(clickBrowseWebView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"网页截图";
    self.view.backgroundColor = FColor(0xee, 0xee, 0xee);
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.clearButton];
    
    [self.view addSubview:self.button];
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.clearButton.hidden = false;
    } else {
        self.clearButton.hidden = true;
    }
}

- (void)clearText:(UIButton *)sender
{
    self.textView.text = @"";
    self.clearButton.hidden = true;
}

- (void)clickBrowseWebView:(UIButton *)sender
{
    WebViewBrowseVC *vc = [[WebViewBrowseVC alloc] initWithUrlStr:self.textView.text];
    [self.navigationController pushViewController:vc animated:true];
}

@end

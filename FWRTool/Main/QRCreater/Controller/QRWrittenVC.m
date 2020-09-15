//
//  QRWrittenVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/15.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "QRWrittenVC.h"

@interface QRWrittenVC ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation QRWrittenVC

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, kScreenW-50, 50)];
    }
    return _textField;
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        self.textField.text = string;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加文字";
    self.view.backgroundColor = FColor(0xee, 0xee, 0xee);
    [self setNavRightItemWithTitle:@"添加"];
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader+20, kScreenW, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];

    [view addSubview:self.textField];
}

- (void)clickRightItem:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(writtenString:)]) {
        [self.delegate writtenString:self.textField.text];
    }
    [self.navigationController popViewControllerAnimated:true];
}

@end

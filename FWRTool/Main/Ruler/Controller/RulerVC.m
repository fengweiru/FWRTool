//
//  RulerVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/16.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "RulerVC.h"
#import "RulerView.h"

@interface RulerVC ()

@property (nonatomic, strong) RulerView *ruler1;   //厘米尺
@property (nonatomic, strong) RulerView *ruler2;   //英寸尺

@property (nonatomic, strong) UIButton *backButton;

@end

@implementation RulerVC

- (RulerView *)ruler1
{
    if (!_ruler1) {
        
        RulerType *type = [[RulerType alloc] init];
        type.point = CGPointMake(kScreenW-[RulerView getRulerWidth], Height_For_StatusBar);
        type.height = kScreenH-Height_For_StatusBar-Height_For_IphoneBottom;
        type.unitType = 0;
        
        _ruler1 = [[RulerView alloc] initWithRulerType:type];
        
    }
    return _ruler1;
}

- (RulerView *)ruler2
{
    if (!_ruler2) {
        
        RulerType *type = [[RulerType alloc] init];
        type.point = CGPointMake(0, Height_For_StatusBar);
        type.height = kScreenH-Height_For_StatusBar-Height_For_IphoneBottom;
        type.unitType = 1;
        
        _ruler2 = [[RulerView alloc] initWithRulerType:type];
        
    }
    return _ruler2;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(kScreenW/2-22, Height_For_AppHeader, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"back1"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(clickForBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:true];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"直尺";
    self.view.backgroundColor = FColor(0xee, 0xee, 0xee);
    [self.view addSubview:self.backButton];
    
    [self.view addSubview:self.ruler1];
    [self.view addSubview:self.ruler2];
    [self.ruler2 setTransform:CGAffineTransformMakeRotation(M_PI)];
}

@end

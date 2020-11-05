//
//  HuarongRoadVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/19.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "HuarongRoadVC.h"
#import "PersonView.h"
#import "PersonManager.h"
#import "PointModel.h"

#define basicY Height_For_AppHeader+50
#define singleLength (kScreenW-40)/4

@interface HuarongRoadVC ()<PersonViewDelegate>

@property (nonatomic, strong) PersonView *caocaoView;
@property (nonatomic, strong) PersonView *soldierView1;
@property (nonatomic, strong) PersonView *soldierView2;
@property (nonatomic, strong) PersonView *soldierView3;
@property (nonatomic, strong) PersonView *soldierView4;

@property (nonatomic, strong) PersonView *guanyuView;
@property (nonatomic, strong) PersonView *zhaoyunView;
@property (nonatomic, strong) PersonView *zhangfeiView;
@property (nonatomic, strong) PersonView *machaoView;
@property (nonatomic, strong) PersonView *huangzhongView;

@property (nonatomic, strong) PersonManager *manager;

@end

@implementation HuarongRoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configUI];
}

- (void)configUI
{
    self.title = @"兵分三路";
    [self setNavRightItemWithTitle:@"选择开局"];
    
    UIView *exitView = [[UIView alloc] initWithFrame:CGRectMake(20+singleLength, basicY+singleLength*5, singleLength*2, 1)];
    exitView.backgroundColor = [UIColor redColor];
    [self.view addSubview:exitView];
    UILabel *exitLabel = [[UILabel alloc] initWithFrame:CGRectMake(exitView.f_x, exitView.f_bottom, exitView.f_width, 50)];
    exitLabel.textAlignment = NSTextAlignmentCenter;
    exitLabel.textColor = [UIColor redColor];
    exitLabel.text = @"出";
    [self.view addSubview:exitLabel];
    
    self.manager = [[PersonManager alloc] init];
    
    self.caocaoView = [[PersonView alloc] initWithFrame:CGRectMake(20+singleLength, Height_For_AppHeader+50, singleLength*2, singleLength*2)];
    self.caocaoView.name = @"曹操";
    self.caocaoView.delegate = self;
    self.caocaoView.sign = 0;
    self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
    self.soldierView1 = [[PersonView alloc] initWithFrame:CGRectMake(20, self.caocaoView.f_y, singleLength, singleLength)];
    self.soldierView1.name = @"士兵1";
    self.soldierView1.delegate = self;
    self.soldierView1.sign = 1;
    self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:0]];
    self.soldierView2 = [[PersonView alloc] initWithFrame:CGRectMake(20, self.soldierView1.f_bottom, singleLength, singleLength)];
    self.soldierView2.name = @"士兵2";
    self.soldierView2.delegate = self;
    self.soldierView2.sign = 2;
    self.soldierView2.pointArr = @[[PointModel makePointWithX:1 y:0]];
    self.soldierView3 = [[PersonView alloc] initWithFrame:CGRectMake(self.caocaoView.f_right, self.caocaoView.f_y, singleLength, singleLength)];
    self.soldierView3.name = @"士兵3";
    self.soldierView3.delegate = self;
    self.soldierView3.sign = 3;
    self.soldierView3.pointArr = @[[PointModel makePointWithX:0 y:3]];
    self.soldierView4 = [[PersonView alloc] initWithFrame:CGRectMake(self.caocaoView.f_right, self.soldierView3.f_bottom, singleLength, singleLength)];
    self.soldierView4.name = @"士兵4";
    self.soldierView4.delegate = self;
    self.soldierView4.sign = 4;
    self.soldierView4.pointArr = @[[PointModel makePointWithX:1 y:3]];
    
    self.guanyuView = [[PersonView alloc] initWithFrame:CGRectMake(self.caocaoView.f_x, self.caocaoView.f_bottom, singleLength*2, singleLength)];
    self.guanyuView.name = @"关羽";
    self.guanyuView.delegate = self;
    self.guanyuView.sign = 5;
    self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
    self.zhaoyunView = [[PersonView alloc] initWithFrame:CGRectMake(20, self.guanyuView.f_bottom, singleLength, singleLength*2)];
    self.zhaoyunView.name = @"赵云";
    self.zhaoyunView.delegate = self;
    self.zhaoyunView.sign = 6;
    self.zhaoyunView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:4 y:0]];
    self.zhangfeiView = [[PersonView alloc] initWithFrame:CGRectMake(self.zhaoyunView.f_right, self.guanyuView.f_bottom, singleLength, singleLength*2)];
    self.zhangfeiView.name = @"张飞";
    self.zhangfeiView.delegate = self;
    self.zhangfeiView.sign = 7;
    self.zhangfeiView.pointArr = @[[PointModel makePointWithX:3 y:1],[PointModel makePointWithX:4 y:1]];
    self.machaoView = [[PersonView alloc] initWithFrame:CGRectMake(self.zhangfeiView.f_right, self.guanyuView.f_bottom, singleLength, singleLength*2)];
    self.machaoView.name = @"马超";
    self.machaoView.delegate = self;
    self.machaoView.sign = 8;
    self.machaoView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:4 y:2]];
    self.huangzhongView = [[PersonView alloc] initWithFrame:CGRectMake(self.machaoView.f_right, self.guanyuView.f_bottom, singleLength, singleLength*2)];
    self.huangzhongView.name = @"黄忠";
    self.huangzhongView.delegate = self;
    self.huangzhongView.sign = 9;
    self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:3],[PointModel makePointWithX:4 y:3]];
    
    [self.view addSubview:self.caocaoView];
    [self.view addSubview:self.soldierView1];
    [self.view addSubview:self.soldierView2];
    [self.view addSubview:self.soldierView3];
    [self.view addSubview:self.soldierView4];
    
    [self.view addSubview:self.guanyuView];
    [self.view addSubview:self.zhaoyunView];
    [self.view addSubview:self.zhangfeiView];
    [self.view addSubview:self.machaoView];
    [self.view addSubview:self.huangzhongView];
    
    [self refreshStartWithType:self.manager.type];
}

- (void)refreshStartWithType:(NSInteger)type
{
    self.manager.type = type;
    
    switch (self.manager.type) {
        case 0:
            self.title = @"兵分三路";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20, basicY+singleLength*3, singleLength, singleLength*2);
            self.zhangfeiView.frame = CGRectMake(20+singleLength*3, basicY+singleLength, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20, basicY+singleLength, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20+singleLength*3, basicY+singleLength*3, singleLength, singleLength*2);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:0 y:3]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:3 y:1]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:3 y:2]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:4 y:0]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:1 y:3],[PointModel makePointWithX:2 y:3]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:1 y:0],[PointModel makePointWithX:2 y:0]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:3],[PointModel makePointWithX:4 y:3]];
            break;
        
        case 1:
            self.title = @"兵临城下";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength, singleLength*2);
            self.zhangfeiView.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20+singleLength*3, basicY+singleLength*2, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20, basicY+singleLength*2, singleLength, singleLength*2);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:1 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:0 y:3]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:1 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:4 y:2]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:3 y:1],[PointModel makePointWithX:4 y:1]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:2 y:3],[PointModel makePointWithX:3 y:3]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:2 y:0],[PointModel makePointWithX:3 y:0]];
            break;
        case 2:
            self.title = @"兵屯东路";
            self.caocaoView.frame = CGRectMake(20+singleLength*2, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength*3, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20+singleLength*3, basicY+singleLength*3, singleLength, singleLength*2);
            self.zhangfeiView.frame = CGRectMake(20, basicY, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20+singleLength, basicY, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength, singleLength*2);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:0 y:3],[PointModel makePointWithX:1 y:2],[PointModel makePointWithX:1 y:3]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:2 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:3 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:2 y:1]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:3 y:1]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:2],[PointModel makePointWithX:2 y:3]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:3 y:3],[PointModel makePointWithX:4 y:3]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:0 y:0],[PointModel makePointWithX:1 y:0]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:1 y:1]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:4 y:2]];
            break;
        case 3:
            self.title = @"层层设防";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength*3, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*3, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength*3, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*4, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhangfeiView.frame = CGRectMake(20, basicY, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength*2, singleLength);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:2 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:3 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:2 y:3]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:3 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:4 y:1],[PointModel makePointWithX:4 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:0 y:0],[PointModel makePointWithX:1 y:0]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:0 y:3],[PointModel makePointWithX:1 y:3]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:1],[PointModel makePointWithX:3 y:2]];
            break;
        case 4:
            self.title = @"插翅难飞";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20+singleLength*3, basicY+singleLength, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*3, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*2, basicY+singleLength*2, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhangfeiView.frame = CGRectMake(20, basicY, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20, basicY+singleLength*3, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20+singleLength*3, basicY+singleLength*3, singleLength, singleLength*2);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:3]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:1 y:3]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:2 y:3]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:2 y:2]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:3 y:1],[PointModel makePointWithX:3 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:2 y:0],[PointModel makePointWithX:2 y:1]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:0 y:0],[PointModel makePointWithX:1 y:0]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:4 y:0]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:3],[PointModel makePointWithX:4 y:3]];
            break;
        case 5:
            self.title = @"过五关";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*4, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20, basicY+singleLength*3, singleLength*2, singleLength);
            self.zhangfeiView.frame = CGRectMake(20, basicY+singleLength*2, singleLength*2, singleLength);
            self.machaoView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*2, singleLength*2, singleLength);
            self.huangzhongView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength*2, singleLength);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:1 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:0 y:3]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:1 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:4 y:1],[PointModel makePointWithX:4 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:3 y:1]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:2 y:0],[PointModel makePointWithX:2 y:1]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:2 y:2],[PointModel makePointWithX:2 y:3]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:3 y:3]];
            break;
        case 6:
            self.title = @"横刀立马";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY+singleLength*4, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20+singleLength, basicY+singleLength*3, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength*4, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20, basicY+singleLength*2, singleLength, singleLength*2);
            self.zhangfeiView.frame = CGRectMake(20, basicY, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength*2);
            self.huangzhongView.frame = CGRectMake(20+singleLength*3, basicY+singleLength*2, singleLength, singleLength*2);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:4 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:3 y:1]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:3 y:2]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:4 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:2 y:0],[PointModel makePointWithX:3 y:0]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:0 y:0],[PointModel makePointWithX:1 y:0]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:0 y:3],[PointModel makePointWithX:1 y:3]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:2 y:3],[PointModel makePointWithX:3 y:3]];
            break;
        case 7:
            self.title = @"水泄不通";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20, basicY+singleLength*4, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength*4, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20, basicY+singleLength*3, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhangfeiView.frame = CGRectMake(20+singleLength*3, basicY, singleLength, singleLength*2);
            self.machaoView.frame = CGRectMake(20, basicY+singleLength*2, singleLength*2, singleLength);
            self.huangzhongView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength*2, singleLength);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:0 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:1 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:4 y:0]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:4 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:3 y:1]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:2 y:2],[PointModel makePointWithX:2 y:3]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:0 y:3],[PointModel makePointWithX:1 y:3]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:2 y:0],[PointModel makePointWithX:2 y:1]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:3 y:3]];
            break;
        case 8:
            self.title = @"天罗地网";
            self.caocaoView.frame = CGRectMake(20+singleLength, basicY, singleLength*2, singleLength*2);
            self.soldierView1.frame = CGRectMake(20, basicY+singleLength, singleLength, singleLength);
            self.soldierView2.frame = CGRectMake(20, basicY+singleLength*2, singleLength, singleLength);
            self.soldierView3.frame = CGRectMake(20+singleLength*3, basicY+singleLength, singleLength, singleLength);
            self.soldierView4.frame = CGRectMake(20+singleLength*3, basicY+singleLength*2, singleLength, singleLength);
            self.guanyuView.frame = CGRectMake(20+singleLength, basicY+singleLength*2, singleLength*2, singleLength);
            self.zhaoyunView.frame = CGRectMake(20, basicY+singleLength*4, singleLength*2, singleLength);
            self.zhangfeiView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*4, singleLength*2, singleLength);
            self.machaoView.frame = CGRectMake(20+singleLength*2, basicY+singleLength*3, singleLength*2, singleLength);
            self.huangzhongView.frame = CGRectMake(20, basicY+singleLength*3, singleLength*2, singleLength);
            
            self.caocaoView.pointArr = @[[PointModel makePointWithX:0 y:1],[PointModel makePointWithX:0 y:2],[PointModel makePointWithX:1 y:1],[PointModel makePointWithX:1 y:2]];
            self.soldierView1.pointArr = @[[PointModel makePointWithX:1 y:0]];
            self.soldierView2.pointArr = @[[PointModel makePointWithX:2 y:0]];
            self.soldierView3.pointArr = @[[PointModel makePointWithX:1 y:3]];
            self.soldierView4.pointArr = @[[PointModel makePointWithX:2 y:3]];
            self.guanyuView.pointArr = @[[PointModel makePointWithX:2 y:1],[PointModel makePointWithX:2 y:2]];
            self.zhaoyunView.pointArr = @[[PointModel makePointWithX:4 y:0],[PointModel makePointWithX:4 y:1]];
            self.zhangfeiView.pointArr = @[[PointModel makePointWithX:4 y:2],[PointModel makePointWithX:4 y:3]];
            self.machaoView.pointArr = @[[PointModel makePointWithX:3 y:2],[PointModel makePointWithX:3 y:3]];
            self.huangzhongView.pointArr = @[[PointModel makePointWithX:3 y:0],[PointModel makePointWithX:3 y:1]];
            break;
            
        default:
            break;
    }
}

- (void)clickRightItem:(UIButton *)sender
{
    UIAlertController *alervc = [UIAlertController alertControllerWithTitle:@"选择开局" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"兵分三路" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:0];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"兵临城下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:1];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"兵屯东路" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:2];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"层层设防" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:3];
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"插翅难飞" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:4];
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"过五关" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:5];
    }];
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"横刀立马" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:6];
    }];
    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"水泄不通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:7];
    }];
    UIAlertAction *action9 = [UIAlertAction actionWithTitle:@"天罗地网" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refreshStartWithType:8];
    }];
    UIAlertAction *canlcelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alervc addAction:action1];
    [alervc addAction:action2];
    [alervc addAction:action3];
    [alervc addAction:action4];
    [alervc addAction:action5];
    [alervc addAction:action6];
    [alervc addAction:action7];
    [alervc addAction:action8];
    [alervc addAction:action9];
    [alervc addAction:canlcelAction];
    [self presentViewController:alervc animated:true completion:nil];
}

#pragma mark -- delegate
- (void)swipeWithSwipeGesture:(UISwipeGestureRecognizer *)swipeG personView:(PersonView *)personView
{
    if ([self.manager couldMoveWithPersonView:personView direct:swipeG.direction]) {
        CGRect frame = personView.frame;
        if (swipeG.direction == UISwipeGestureRecognizerDirectionUp) {
            frame.origin.y -= singleLength;
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionDown) {
            frame.origin.y += singleLength;
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionLeft) {
            frame.origin.x -= singleLength;
        } else if (swipeG.direction == UISwipeGestureRecognizerDirectionRight) {
            frame.origin.x += singleLength;
        }
        [UIView animateWithDuration:0.2f animations:^{
            personView.frame = frame;
        }];
        
        [self judgeResult];
    }
    
}

- (void)judgeResult
{
    if (self.caocaoView.f_x == 20+singleLength && self.caocaoView.f_y == basicY+singleLength*3) {
        UIAlertController *successVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜通关!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self refreshStartWithType:self.manager.type];
        }];
        [successVC addAction:action];
        [self presentViewController:successVC animated:true completion:nil];
    }
}


@end

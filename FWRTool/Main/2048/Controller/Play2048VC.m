//
//  Play2048VC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/28.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "Play2048VC.h"
#import "Play2048Manager.h"
#import "BlockView.h"
#import "BlockModel.h"

static const CGFloat space = 12;

@interface Play2048VC ()<Play2048ManagerDelegate>
{
    UIView *bgView;
}

@property (nonatomic, strong) Play2048Manager *manager;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *historyScoreLabel;

@end

@implementation Play2048VC

- (Play2048Manager *)manager
{
    if (!_manager) {
        _manager = [[Play2048Manager alloc] init];
        _manager.delegate = self;
    }
    return _manager;
}

- (UILabel *)scoreLabel
{
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 110, 75)];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.font = [UIFont boldSystemFontOfSize:36];
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.numberOfLines = 2;
        _scoreLabel.text = @"0";
    }
    return _scoreLabel;
}

- (UILabel *)historyScoreLabel
{
    if (!_historyScoreLabel) {
        _historyScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 110, 75)];
        _historyScoreLabel.textAlignment = NSTextAlignmentCenter;
        _historyScoreLabel.font = [UIFont boldSystemFontOfSize:36];
        _historyScoreLabel.textColor = [UIColor whiteColor];
        _historyScoreLabel.numberOfLines = 2;
        _historyScoreLabel.text = @"0";
    }
    return _historyScoreLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
    self.title = @"2048";
    
    [self setupUI];
}

- (void)setupUI
{
    CGFloat headerSpace = (kScreenW - 220)/3;
    UIView *scoreView = [[UIView alloc] initWithFrame:CGRectMake(headerSpace, 20, 110, 110)];
    scoreView.backgroundColor = FColor(190, 175, 164);
    scoreView.layer.cornerRadius = 5;
    [self.view addSubview:scoreView];
    UILabel *scoreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, scoreView.f_width, 20)];
    scoreTitleLabel.textAlignment = NSTextAlignmentCenter;
    scoreTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    scoreTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    scoreTitleLabel.text = @"分数";
    [scoreView addSubview:scoreTitleLabel];
    [scoreView addSubview:self.scoreLabel];
    
    UIView *historyScoreView = [[UIView alloc] initWithFrame:CGRectMake(headerSpace*2+110, 20, 110, 110)];
    historyScoreView.backgroundColor = FColor(190, 175, 164);
    historyScoreView.layer.cornerRadius = 5;
    [self.view addSubview:historyScoreView];
    UILabel *historyScoreTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, historyScoreView.f_width, 20)];
    historyScoreTitleLabel.textAlignment = NSTextAlignmentCenter;
    historyScoreTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    historyScoreTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    historyScoreTitleLabel.text = @"历史最高分数";
    [historyScoreView addSubview:historyScoreTitleLabel];
    [historyScoreView addSubview:self.historyScoreLabel];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retryButton.backgroundColor = FColor(223, 156, 100);
    [retryButton setTitle:@"重新开始" forState:UIControlStateNormal];
    [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    retryButton.layer.cornerRadius = 5;
    retryButton.frame = CGRectMake(scoreView.f_x, scoreView.f_bottom+15, scoreView.f_width, 40);
    [retryButton addTarget:self action:@selector(retryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retryButton];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(16, 200, kScreenW-32, kScreenW-32)];
    bgView.backgroundColor = FColor(190, 175, 164);
    bgView.layer.masksToBounds = true;
    bgView.layer.cornerRadius = 5;
    bgView.userInteractionEnabled = true;
    UISwipeGestureRecognizer *swipeRG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeRG.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *swipeLG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeLG.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeUG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeUG.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *swipeDG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
    swipeDG.direction = UISwipeGestureRecognizerDirectionDown;
    [bgView addGestureRecognizer:swipeRG];
    [bgView addGestureRecognizer:swipeLG];
    [bgView addGestureRecognizer:swipeUG];
    [bgView addGestureRecognizer:swipeDG];
    [self.view addSubview:bgView];
    
    CGFloat width = (bgView.f_width-space*5)/4.f;
    
    for (NSInteger x = 0; x < 4; x++) {
        for (NSInteger y = 0; y < 4; y++) {
            UIView *bgBlock = [[UIView alloc] initWithFrame:CGRectMake(space+(space+width)*y, space+(space+width)*x, width, width)];
            bgBlock.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
            bgBlock.layer.masksToBounds = true;
            bgBlock.layer.cornerRadius = 5;
            [bgView addSubview:bgBlock];
        }
    }
    
//    NSArray <BlockView *>*arr = [self.manager createBaseData];
//    for (BlockView *blockView in arr) {
//        blockView.frame = CGRectMake(space+(space+width)*blockView.block.y, space+(space+width)*blockView.block.x, width, width);
//        blockView.space = space;
//
//        [bgView addSubview:blockView];
//    }
    [self createDataBase];
    
}
- (void)createDataBase
{
    NSArray <BlockView *>*arr = [self.manager createBaseData];
    CGFloat width = (bgView.f_width-space*5)/4.f;
    for (BlockView *blockView in arr) {
        blockView.frame = CGRectMake(space+(space+width)*blockView.block.y, space+(space+width)*blockView.block.x, width, width);
        blockView.space = space;
        
        [bgView addSubview:blockView];
    }
}

#pragma mark -- delegate
- (void)addBlockView:(BlockView *)blockView
{
    CGFloat width = (bgView.f_width-space*5)/4.f;
    
    blockView.frame = CGRectMake(space+(space+width)*blockView.block.y, space+(space+width)*blockView.block.x, width, width);
    blockView.space = space;
    
    [bgView addSubview:blockView];
}

- (void)refreshScore:(NSUInteger)score
{
    self.scoreLabel.text = [NSString stringWithFormat:@"%zu",score];
}
- (void)refreshHistoryScore:(NSUInteger)historyScore
{
    self.historyScoreLabel.text = [NSString stringWithFormat:@"%zu",historyScore];
}

#pragma mark -- 点击
- (void)retryButton:(UIButton *)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要重新开始游戏？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.manager clearCurrentData];
        self.scoreLabel.text = @"0";
        [self createDataBase];
    }];
    [vc addAction:actionCancel];
    [vc addAction:actionConfirm];
    [self presentViewController:vc animated:true completion:nil];
}

- (void)swipeView:(UISwipeGestureRecognizer *)swipeG
{
    [self.manager swipWithSwipeGestureRecognizer:swipeG];
}


@end

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBar];
    self.title = @"2048";
    
    [self setupUI];
}

- (void)setupUI
{
    NSArray <BlockView *>*arr = [self.manager createBaseData];
    
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
    
    for (BlockView *blockView in arr) {
        blockView.frame = CGRectMake(space+(space+width)*blockView.block.y, space+(space+width)*blockView.block.x, width, width);
        blockView.space = space;
        
        [bgView addSubview:blockView];
    }
    
}

- (void)addBlockView:(BlockView *)blockView
{
    CGFloat width = (bgView.f_width-space*5)/4.f;
    
    blockView.frame = CGRectMake(space+(space+width)*blockView.block.y, space+(space+width)*blockView.block.x, width, width);
    blockView.space = space;
    
    [bgView addSubview:blockView];
}

- (void)swipeView:(UISwipeGestureRecognizer *)swipeG
{
    [self.manager swipWithSwipeGestureRecognizer:swipeG];
}


@end

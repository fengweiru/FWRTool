//
//  BlockView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/28.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "BlockView.h"
#import "BlockModel.h"

@interface BlockView ()<BlockModelDelegate>

@property (nonatomic, strong) UILabel *label;

@end

@implementation BlockView

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:44];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.adjustsFontSizeToFitWidth = true;
    }
    return _label;
}

- (instancetype)init
{
    if (self == [super init]) {
        self.block = [[BlockModel alloc] init];
        self.block.delegate = self;
        [self addSubview:self.label];
    }
    return self;
}

- (void)setScore:(NSInteger)score
{
    [NSTimer scheduledTimerWithTimeInterval:0.2f repeats:false block:^(NSTimer * _Nonnull timer) {
        self.label.text = [NSString stringWithFormat:@"%zi",score];
    }];
    
}

- (void)moveX:(NSInteger)x isMergedTo:(BlockView *)blockView
{
    NSInteger move = x-self.block.x;
    
    WS(weakSelf);
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.f_y += (move*(self.space+self.f_height));    //二维数组的xy和frame的xy正好含义正好相反
    } completion:^(BOOL finished) {
        if (blockView) {
            [weakSelf removeFromSuperview];
        }
    }];
    if (blockView) {
        blockView.isMerged = true;
        blockView.block.score *= 2;
    } else {
        self.block.x = x;
    }
}
- (void)moveY:(NSInteger)y isMergedTo:(BlockView *)blockView
{
    NSInteger move = y-self.block.y;
    
    WS(weakSelf);
    [UIView animateWithDuration:0.2f animations:^{
        weakSelf.f_x += (move*(self.space+self.f_width));
    } completion:^(BOOL finished) {
        if (blockView) {
            [weakSelf removeFromSuperview];
        }
    }];
    if (blockView) {
        blockView.isMerged = true;
        blockView.block.score *= 2;
    } else {
        self.block.y = y;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = self.bounds;
    
}


@end

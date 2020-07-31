//
//  MainWindowCell.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/31.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "MainWindowCell.h"

@interface MainWindowCell ()

@property (nonatomic, strong) UILabel *title;

@end

@implementation MainWindowCell

- (UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.title];
        self.title.frame = self.contentView.bounds;
        self.title.text = @"哈哈哈啊哈";
    }
    return self;
}

- (void)layoutSubviews
{
    
}

@end

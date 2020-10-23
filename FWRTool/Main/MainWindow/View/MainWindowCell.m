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
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.masksToBounds = true;
        self.contentView.layer.cornerRadius = 4;
        [self.contentView addSubview:self.title];
        self.title.frame = self.contentView.bounds;
    }
    return self;
}

- (void)configWithTitle:(NSString *)title
{
    self.title.text = title;
}

- (void)layoutSubviews
{
    
}

@end

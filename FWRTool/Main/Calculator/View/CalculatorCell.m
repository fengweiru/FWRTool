//
//  CalculatorCell.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/18.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "CalculatorCell.h"

@interface CalculatorCell ()

@property (nonatomic, strong) UIButton *nameButton;

@property (nonatomic, assign) BOOL couldSelected;

@end

@implementation CalculatorCell

- (UIButton *)nameButton
{
    if (!_nameButton) {
        _nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_nameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        _nameButton.frame = CGRectMake(10, 10, self.f_width-20, self.f_height-20);
        _nameButton.layer.cornerRadius = _nameButton.f_height/2;
        
        [_nameButton setBackgroundImage:[CommonClass createImageWithColor:[UIColor orangeColor] withFrame:_nameButton.bounds] forState:UIControlStateHighlighted];
        [_nameButton setBackgroundImage:[CommonClass createImageWithColor:[UIColor orangeColor] withFrame:_nameButton.bounds] forState:UIControlStateSelected];
        
        _nameButton.layer.borderWidth = 1;
        _nameButton.layer.borderColor = [[UIColor orangeColor] CGColor];
        _nameButton.layer.masksToBounds = true;
        
        [_nameButton addTarget:self action:@selector(clickText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.nameButton];
        
    }
    return self;
}

- (void)setNameText:(NSString *)text couldSelected:(BOOL)couldSelect
{
    [self.nameButton setTitle:text forState:UIControlStateNormal];
    self.couldSelected = couldSelect;
}

- (void)setButtonSelected:(BOOL)selected
{
    self.nameButton.selected = selected;
}

- (void)clickText:(UIButton *)sender
{
    if (self.couldSelected) {
        [sender setSelected:!sender.selected];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickText:)]) {
        [self.delegate clickText:self.nameButton.titleLabel.text];
    }
}

- (void)layoutSubviews
{
    self.nameButton.frame = CGRectMake(10, 10, self.f_width-20, self.f_height-20);
}

@end

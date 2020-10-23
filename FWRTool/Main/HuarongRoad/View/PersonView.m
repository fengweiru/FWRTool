//
//  PersonView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/19.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "PersonView.h"

@interface PersonView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation PersonView

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.f_width-10, self.f_height-10)];
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.layer.borderWidth = 1;
        _label.layer.borderColor = [[UIColor blackColor] CGColor];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UISwipeGestureRecognizer *swipeRG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
        swipeRG.direction = UISwipeGestureRecognizerDirectionRight;
        UISwipeGestureRecognizer *swipeLG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
        swipeLG.direction = UISwipeGestureRecognizerDirectionLeft;
        UISwipeGestureRecognizer *swipeUG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
        swipeUG.direction = UISwipeGestureRecognizerDirectionUp;
        UISwipeGestureRecognizer *swipeDG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
        swipeDG.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeRG];
        [self addGestureRecognizer:swipeLG];
        [self addGestureRecognizer:swipeUG];
        [self addGestureRecognizer:swipeDG];
        
        [self addSubview:self.label];
    }
    return self;
}

- (void)swipeView:(UISwipeGestureRecognizer *)swipeG
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeWithSwipeGesture:personView:)]) {
        [self.delegate swipeWithSwipeGesture:swipeG personView:self];
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    
    self.label.text = name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(5, 5, self.f_width-10, self.f_height-10);
}


@end

//
//  FWRMagnifierView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/3.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "FWRMagnifierView.h"

@interface FWRMagnifierView ()

@property (nonatomic, strong) UIView *tagView;

@end

@implementation FWRMagnifierView

- (UIView *)tagView
{
    if (!_tagView) {
        _tagView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _tagView.backgroundColor = [UIColor clearColor];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(8.5, 0, 3, 20)];
        line1.layer.cornerRadius = line1.f_width/2;
        line1.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [_tagView addSubview:line1];
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 8.5, 20, 3)];
        line2.layer.cornerRadius = line2.f_height/2;
        line2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        [_tagView addSubview:line2];
    }
    return _tagView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.masksToBounds = true;
        //为了居于状态条之上
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.layer.delegate = self;
        //保证和屏幕读取像素的比例一致
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        
        [self addSubview:self.tagView];
    }
    return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //提前位移半个长宽的坑
    CGContextTranslateCTM(ctx, self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGContextScaleCTM(ctx, 2, 2);
    //再次位移后就可以把触摸点移至self.center的位置
    CGContextTranslateCTM(ctx, -1 * self.renderPoint.x, -1 * self.renderPoint.y);
    
    [self.renderView.layer renderInContext:ctx];
}

- (void)setRenderPoint:(CGPoint)renderPoint
{
    _renderPoint = renderPoint;
    
    [self.layer setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    self.layer.borderColor = hidden ? [[UIColor clearColor] CGColor] : [[UIColor lightGrayColor] CGColor];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.cornerRadius = frame.size.width/2;
    
    self.tagView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
}

- (void)dealloc
{
    NSLog(@"FWRMagnifierView dealloc");
}

@end

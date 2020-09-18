//
//  ProtractorView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/17.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ProtractorView.h"

@interface ProtractorView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) CGFloat topRadian;
@property (nonatomic, assign) CGFloat bottomRadian;

@end

@implementation ProtractorView

- (UIView *)topLine
{
    if (!_topLine) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(19, self.f_height/4, 2, self.f_height/2)];
        _topLine.backgroundColor = CommonBlueColor;
        _topLine.layer.anchorPoint = CGPointMake(0.5, 1);
        
        _topRadian = 0;
    }
    return _topLine;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(19, self.f_height/4, 2, self.f_height/2)];
        _bottomLine.backgroundColor = CommonBlueColor;
        _bottomLine.layer.anchorPoint = CGPointMake(0.5, 0);
        
        _bottomRadian = M_PI;
    }
    return _bottomLine;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.topLine];
        [self addSubview:self.bottomLine];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAngle:)]) {
        [self.delegate showAngle:180];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGContextSetFillColorWithColor(context, CommonBlueColor.CGColor);
//    CGRect rectangle = CGRectMake(5.0,5.0,rect.size.width-10.0,rect.size.height-10.0);
    CGContextFillEllipseInRect(context,CGRectMake(0,self.f_height/2-20,40,40));
    
    CGContextAddArc(context, 20, self.f_height/2, self.f_width-5-20, -M_PI_2, M_PI_2, 0);
    CGContextSetLineWidth(context, 5);
    CGFloat dashLength = 2.f;
    CGContextSetLineDash(context, 0, &dashLength, 1);
    CGContextSetStrokeColorWithColor(context, [CommonBlueColor CGColor]);

    
    CGContextStrokePath(context);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches.allObjects firstObject];
    CGPoint point = [touch locationInView:self];
    
    [self handleWithPoint:point];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches.allObjects firstObject];
    CGPoint point = [touch locationInView:self];
    
    [self handleWithPoint:point];
}

- (void)handleWithPoint:(CGPoint)point
{
    if (point.x < 20) {
        point.x = 20;
    }
    CGFloat radian = [self getTopAngleWithPoint:point];
    
    if ((radian - self.topRadian) <= (self.bottomRadian - radian)) {
        [self.topLine setTransform:CGAffineTransformMakeRotation(radian-0)];
        self.topRadian = radian;
    } else {
        [self.bottomLine setTransform:CGAffineTransformMakeRotation(radian-M_PI)];
        self.bottomRadian = radian;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAngle:)]) {
        [self.delegate showAngle:(self.bottomRadian-self.topRadian)*180/M_PI];
    }
    
}

- (CGFloat)getTopAngleWithPoint:(CGPoint)endPoint
{
    CGPoint startPoint = CGPointMake(20, self.f_height/2);
    
    CGFloat radian = 0;
    if (endPoint.y <= startPoint.y) {
        CGFloat a = endPoint.x-startPoint.x;  //一条直角边
        CGFloat b = startPoint.y-endPoint.y;  //另一条直角边
//        NSLog(@"a/b:%f",a/b);
        radian = atan(a/b);
    } else {
        CGFloat a = endPoint.y-startPoint.y;  //一条直角边
        CGFloat b = endPoint.x-startPoint.x;  //另一条直角边
//        NSLog(@"a/b:%f",a/b);
        radian = atan(a/b)+M_PI_2;
    }

    return radian;
}

@end

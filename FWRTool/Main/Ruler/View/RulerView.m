//
//  RulerView.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/16.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "RulerView.h"

static const CGFloat startX1 = 50;
static const CGFloat startX2 = 65;
static const CGFloat startX3 = 85;
static const CGFloat endX  = 100;

@interface RulerView ()
@property (nonatomic, assign) CGFloat pmm;        //每毫米mm的像素点pmm
@property (nonatomic, assign) CGFloat lineWidth;     //刻度宽度
@property (nonatomic, assign) CGFloat distance;      //刻度间距

@property (nonatomic, assign) NSInteger num;       //可画刻度数量

@property (nonatomic, strong) RulerType *rulerType;

@end

@implementation RulerView

+ (CGFloat)getRulerWidth
{
    return 100.f;
}

- (instancetype)initWithRulerType:(RulerType *)rulerType
{
    if (self = [super initWithFrame:CGRectMake(rulerType.point.x, rulerType.point.y, 100, rulerType.height)]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.rulerType = rulerType;
        
        self.pmm = [self getPmmForOnemm];
        NSString *unitStr = @"单位：厘米cm";
        if (rulerType.unitType == 1) {
            self.pmm *= 2.54;
            unitStr = @"单位：英寸inch";
        }
        self.lineWidth = 1;
        self.distance = self.pmm - self.lineWidth;
        
        self.num = (int)((rulerType.height-20-self.lineWidth)/self.pmm)+1;
        
        for (NSInteger i = 0; i < self.num; i+=10) {
            CGFloat y = self.pmm*i;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, y, 20, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [NSString stringWithFormat:@"%zi",i/10];
            [label setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            [self addSubview:label];
        }
        
        UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(-40, 50, 100, 30)];
        unit.textAlignment = NSTextAlignmentCenter;
        unit.text = unitStr;
        unit.font = [UIFont systemFontOfSize:12];
        [unit setTransform:CGAffineTransformMakeRotation(M_PI_2)];

        [self addSubview:unit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    for (NSInteger i = 0; i < self.num; i++) {
        CGFloat startX;
        if (i%10 == 0) {
            startX = startX1;
        } else if (i%5 == 0) {
            startX = startX2;
        } else {
            startX = startX3;
        }

        CGContextMoveToPoint(context, startX, 10+self.pmm*i);
        CGContextAddLineToPoint(context, endX, 10+self.pmm*i);
    }
    
    CGContextMoveToPoint(context, startX1, 10);
    CGContextAddLineToPoint(context, endX, 10);
    
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextStrokePath(context);
}

- (CGFloat)getPmmForOnemm
{
    CGFloat sc_w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat sc_h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat sc_s;
    CGFloat ff = [[UIScreen mainScreen] nativeBounds].size.height;
    
    if (ff == 1136) {
        sc_s = 4.0;
    }else if(ff == 1334.0){
        sc_s = 4.7;
    }else if (ff== 2208){
        sc_s = 5.5;
    }else if (ff== 2436){
        sc_s = 5.8;
    }else if (ff== 1792){
        sc_s = 6.1;
    }
    else if (ff== 2688){
        sc_s = 6.5;
    }else{
        sc_s = 3.5;
    }
    
    //1mm米的像素点
    CGFloat pmm = sqrt(sc_w * sc_w + sc_h * sc_h)/(sc_s * 25.4);//mm
    
    return pmm;
}

@end

@implementation RulerType



@end

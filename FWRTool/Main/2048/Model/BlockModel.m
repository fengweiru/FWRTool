//
//  BlockModel.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/11/4.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "BlockModel.h"

@implementation BlockModel

- (void)setScore:(NSInteger)score
{
    _score = score;
    if (self.delegate && [self.delegate respondsToSelector:@selector(setScore:)]) {
        [self.delegate setScore:score];
    }
}

@end

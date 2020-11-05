//
//  BlockView.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/28.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BlockModel;
@interface BlockView : UIView

@property (nonatomic, strong) BlockModel *block;
@property (nonatomic, assign) CGFloat space; //方块间隔
@property (nonatomic, assign) BOOL isMerged; //本次移动中是否合并过

- (void)moveX:(NSInteger)x isMergedTo:(BlockView * _Nullable )blockView;
- (void)moveY:(NSInteger)y isMergedTo:(BlockView * _Nullable )blockView;

@end

NS_ASSUME_NONNULL_END

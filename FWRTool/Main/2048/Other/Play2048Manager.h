//
//  Play2048Manager.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/10/28.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BlockView;

@protocol Play2048ManagerDelegate <NSObject>

- (void)addBlockView:(BlockView *)blockView;

@end

@interface Play2048Manager : NSObject

@property (nonatomic, assign) id<Play2048ManagerDelegate> delegate;

- (NSArray <BlockView *>*)createBaseData;

- (void)swipWithSwipeGestureRecognizer:(UISwipeGestureRecognizer *)swipeG;

@end

NS_ASSUME_NONNULL_END

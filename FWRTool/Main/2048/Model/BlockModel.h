//
//  BlockModel.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/11/4.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BlockModelDelegate <NSObject>

- (void)setScore:(NSInteger)score;

@end

@interface BlockModel : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, assign) id<BlockModelDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

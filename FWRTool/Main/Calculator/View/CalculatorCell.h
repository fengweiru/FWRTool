//
//  CalculatorCell.h
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/18.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CalculatorCellDelegate <NSObject>

- (void)clickText:(NSString *)text;

@end

@interface CalculatorCell : UICollectionViewCell

@property (nonatomic, assign) id<CalculatorCellDelegate> delegate;

- (void)setNameText:(NSString *)text couldSelected:(BOOL)couldSelect;

@end

NS_ASSUME_NONNULL_END

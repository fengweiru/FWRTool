//
//  CommonPickerView.h
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/15.
//  Copyright © 2020 Toman. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CommonPickerViewType) {
    CommonPickerViewTypeSex,
    CommonPickerViewTypeDate,
};

@protocol CommonPickerViewDelegate <NSObject>

- (void)selectString:(NSString *)string AndTag:(NSInteger)tag;

@end

@interface CommonPickerView : UIView

@property (nonatomic, assign) id<CommonPickerViewDelegate> delegate;
@property (nonatomic, assign) CommonPickerViewType type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger ftag;

@property (nonatomic, strong) NSString *selectStr;

- (instancetype)initWithView:(UIView *)superView;

- (void)moveUp;
- (void)moveDown;

@end

NS_ASSUME_NONNULL_END

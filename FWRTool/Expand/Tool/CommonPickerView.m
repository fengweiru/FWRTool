//
//  CommonPickerView.m
//  ChildProtection
//
//  Created by 冯伟如 on 2020/5/15.
//  Copyright © 2020 Toman. All rights reserved.
//

#import "CommonPickerView.h"

#define Tag_For_Banner_Label     91003

#define Height_For_Picker        162
#define Height_For_Banner        42
#define Left_For_Button          20
#define Width_For_Button         50

@interface CommonPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *_superView;
    
    UIView *_pickerAndBanner;
    UIView *_shadeView;
}

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, strong) NSArray *optionArray;

@end

@implementation CommonPickerView

- (instancetype)initWithView:(UIView *)superView
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        CGRect frame = superView.frame;
        self.frame = frame;
        _superView = superView;
        
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_For_Picker+Height_For_Banner-frame.size.height, frame.size.width, frame.size.height-Height_For_Picker-Height_For_Banner)];
        _shadeView.backgroundColor = [UIColor blackColor];
        _shadeView.alpha = 0.3;
        _shadeView.hidden = YES;
        
        [superView addSubview:_shadeView];
        
        _pickerAndBanner = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, Height_For_Picker+Height_For_Banner)];
        _pickerAndBanner.backgroundColor = [UIColor whiteColor];
        _pickerAndBanner.hidden = YES;
        
        /*确定取消栏*/
        UITextField *bannerTF = [[UITextField alloc]initWithFrame:CGRectMake(frame.size.width/2-50, 0, 100, Height_For_Banner)];
        [bannerTF setBackgroundColor:[UIColor whiteColor]];
        bannerTF.textAlignment = NSTextAlignmentCenter;
        bannerTF.enabled = NO;
        bannerTF.tag = Tag_For_Banner_Label;
        bannerTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_pickerAndBanner addSubview:bannerTF];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(Left_For_Button, 0, Width_For_Button, Height_For_Banner);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:CommonOrangeColor forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(moveDown) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setTitleColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:0.8] forState:UIControlStateHighlighted];
        [_pickerAndBanner addSubview:cancelButton];
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(frame.size.width - Left_For_Button- Width_For_Button, 0, Width_For_Button, Height_For_Banner);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:CommonOrangeColor forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:0.8] forState:UIControlStateHighlighted];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _sureButton.backgroundColor = [UIColor clearColor];
        [_sureButton addTarget:self action:@selector(inputNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        [_pickerAndBanner addSubview:_sureButton];
        
        [superView addSubview:_pickerAndBanner];
 
    }
    return self;
}

- (void)moveUp{
    
    
    _shadeView.hidden = NO;
    _pickerAndBanner.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self->_shadeView.frame = CGRectMake(0, self.frame.origin.y, self->_shadeView.frame.size.width, self->_shadeView.frame.size.height);
        
        self->_pickerAndBanner.frame = CGRectMake(0, self.frame.size.height - Height_For_Picker -Height_For_Banner, self->_pickerAndBanner.frame.size.width, self->_pickerAndBanner.frame.size.height);
        
        
    } completion:nil];
//    ^(BOOL result){
//        [self->_pickerView reloadAllComponents];
//    }
}

- (void)moveDown{

    [UIView animateWithDuration:0.3 animations:^{
        
        self->_shadeView.frame = CGRectMake(0, -self->_shadeView.frame.size.height, self->_shadeView.frame.size.width, self->_shadeView.frame.size.height);
        
        self->_pickerAndBanner.frame = CGRectMake(0, self.frame.size.height, self->_pickerAndBanner.frame.size.width, self->_pickerAndBanner.frame.size.height);
        
    } completion:^(BOOL result){
        
        self->_shadeView.hidden = YES;
        self->_pickerAndBanner.hidden = YES;
        
    }];
}

- (void)setType:(CommonPickerViewType)type
{
    _type = type;
    if (_pickerView) {
        if ([_pickerView isKindOfClass:[UIPickerView class]]) {
            _pickerView.delegate = nil;
            _pickerView.dataSource = nil;
        }

        [_pickerView removeFromSuperview];
        _pickerView = nil;
    }
    CGRect rect = CGRectMake(0, _pickerAndBanner.frame.size.height - Height_For_Picker, _pickerAndBanner.frame.size.width, Height_For_Picker);
    if (type == CommonPickerViewTypeSex) {
        _optionArray = @[@"女",@"男"];
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        if (self.selectStr) {
            for (NSString *option in _optionArray) {
                if ([option isEqualToString:self.selectStr]) {
                    self.selectRow = [_optionArray indexOfObject:option];
                }
            }
        }
        
        [_pickerView selectRow:self.selectRow inComponent:0 animated:false];
    } else if (type == CommonPickerViewTypeDate) {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:@"1900-01-01"];
        datePicker.minimumDate=date;//1900/01/01
        datePicker.maximumDate=[NSDate dateWithTimeIntervalSinceNow:0];//现在
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        datePicker.locale = locale;
        
        if (self.selectStr) {
            NSDate *newDate = [dateFormatter dateFromString:self.selectStr];
            if(newDate)
            {
                [datePicker setDate:newDate animated:NO];
            }
        }
//        [datePicker addTarget:self action:@selector(rollAction:) forControlEvents:(UIControlEventValueChanged)];
        
        _pickerView = (UIPickerView *)datePicker;
    }
    _pickerView.frame = rect;
    
    [_pickerAndBanner addSubview:_pickerView];
}

- (void)inputNumber:(UIButton *)sender
{
    
    if (self.delegate) {
        if (self.type == CommonPickerViewTypeDate) {
            // 格式化日期格式
               NSDateFormatter *formatter = [NSDateFormatter new];
              // 设置显示的格式
               [formatter setDateFormat:@"YYYY-MM-dd"];
            UIDatePicker *datePicker = (UIDatePicker *)self.pickerView;
            [self.delegate selectString:[formatter stringFromDate:datePicker.date] AndTag:self.ftag];
        } else {
            [self.delegate selectString:self.optionArray[self.selectRow] AndTag:self.ftag];
        }
        
    }
    
    [self moveDown];
}

#pragma mark -- UIPickerView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_optionArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _optionArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectRow = row;
}

//#pragma mark ------>> 监听滚动的方法   滚动日期键盘时候走的方法<<------
//- (void)rollAction:(UIDatePicker *)sender
//{
//    // 格式化日期格式
//    NSDateFormatter *formatter = [NSDateFormatter new];
//   // 设置显示的格式
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//   // UIDatePicker 滚动也就是日期改变
//    self.timeField.text = [formatter stringFromDate:sender.date];
//
//}

@end

//
//  CalculatorVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/18.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "CalculatorVC.h"
#import "CalculatorCell.h"

@interface CalculatorVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CalculatorCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *historyResultArr;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *calculatorKeyArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UnderlineTextField *inputTextField;

@property (nonatomic, strong) NSString *lastNum;
@property (nonatomic, strong) NSString *operator;

@property (nonatomic, assign) BOOL shouldClear;

@end

@implementation CalculatorVC

- (NSMutableArray *)historyResultArr
{
    if (!_historyResultArr) {
        _historyResultArr = [[NSMutableArray alloc] init];
    }
    return _historyResultArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, self.inputTextField.f_y-Height_For_AppHeader) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UnderlineTextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UnderlineTextField alloc] initWithFrame:CGRectMake(30, self.collectionView.f_y-50, kScreenW-60, 40)];
        _inputTextField.textAlignment = NSTextAlignmentRight;
        _inputTextField.font = FFontRegular(25);
        _inputTextField.userInteractionEnabled = false;
        _inputTextField.text = @"0";
    }
    return _inputTextField;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        layout.itemSize = CGSizeMake((kScreenW-40)/2, (kScreenW-40)/2);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenW/2-160, kScreenH-320*5/4-Height_For_IphoneBottom, 320, 320*5/4) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        _collectionView.bounces = false;
        
        [_collectionView registerClass:[CalculatorCell class] forCellWithReuseIdentifier:@"CalculatorCell"];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"计算器";
    
    [self.view addSubview:self.tableView];
    
    self.calculatorKeyArr = @[@"C",@"+/-",@"%",@"÷",@"7",@"8",@"9",@"×",@"4",@"5",@"6",@"-",@"1",@"2",@"3",@"+",@"0",@".",@"="];
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.inputTextField];
}

#pragma mark -- UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.calculatorKeyArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *calculatorKey = self.calculatorKeyArr[indexPath.item];
    if ([calculatorKey isEqualToString:@"0"]) {
        return CGSizeMake((320-2)/4*2, (320-2)/4);
    } else {
        return CGSizeMake((320-2)/4, (320-2)/4);
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalculatorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalculatorCell" forIndexPath:indexPath];
    cell.delegate = self;
    
    NSString *calculatorKey = self.calculatorKeyArr[indexPath.item];
    BOOL couldSelected = false;
    [cell setButtonSelected:false];
    if ([calculatorKey isEqualToString:@"÷"] || [calculatorKey isEqualToString:@"×"] || [calculatorKey isEqualToString:@"-"] || [calculatorKey isEqualToString:@"+"]) {
        couldSelected = true;
        
        if (self.operator && [self.operator isEqualToString:calculatorKey]) {
            [cell setButtonSelected:true];
        }
    }
    [cell setNameText:calculatorKey couldSelected:couldSelected];
    
    return cell;
}

- (void)clickText:(NSString *)text
{
    BOOL shouldClear = false;
    
    if ([text isEqualToString:@"C"]) {
        self.inputTextField.text = @"0";
    } else if ([text isEqualToString:@"+/-"]) {
        if ([self.inputTextField.text floatValue] > 0) {
            self.inputTextField.text = [NSString stringWithFormat:@"-%@",self.inputTextField.text];
        } else if ([self.inputTextField.text floatValue] < 0) {
            self.inputTextField.text = [self.inputTextField.text substringFromIndex:1];
        }
        [self.historyResultArr addObject:self.inputTextField.text];
        [self.tableView reloadData];
    } else if ([text isEqualToString:@"%"]) {
        self.inputTextField.text = [NSString stringWithFormat:@"%@",@([self.inputTextField.text doubleValue]/100)];
        [self.historyResultArr addObject:self.inputTextField.text];
        [self.tableView reloadData];
    }
    else if ([text isEqualToString:@"÷"] || [text isEqualToString:@"×"] || [text isEqualToString:@"-"] || [text isEqualToString:@"+"]) {
        [self calculate];
        
        self.operator = text;
        [self.collectionView reloadData];
    } else if ([text isEqualToString:@"="]) {
        [self calculate];
        [self.collectionView reloadData];
        
        shouldClear = true;
    } else if ([text isEqualToString:@"."]) {
        if (self.shouldClear) {
            self.inputTextField.text = @"0";
        }
        
        NSMutableString *string = [NSMutableString stringWithString:self.inputTextField.text];
        NSRange range = [self.inputTextField.text rangeOfString:@"."];
        if (range.length == 0) {
            [string appendString:text];
        }
        
        self.inputTextField.text = string;
    }
    else {
        
        if (self.operator && self.lastNum == nil) {
            self.lastNum = self.inputTextField.text;
            self.inputTextField.text = @"";
        }
        if (self.shouldClear) {
            self.inputTextField.text = @"";
        }
        
        NSMutableString *string = [NSMutableString stringWithString:self.inputTextField.text];
        [string appendString:text];
        self.inputTextField.text = [NSString stringWithFormat:@"%@",@([string floatValue])];
        
    }
    
    self.shouldClear = shouldClear;
    
}

- (void)calculate
{
    if (self.operator && self.lastNum != nil) {
        CGFloat num = [self.lastNum floatValue];
        CGFloat calcuteNum = [self.inputTextField.text floatValue];
        if ([self.operator isEqualToString:@"÷"]) {
            num = num/calcuteNum;
        } else if ([self.operator isEqualToString:@"×"]) {
            num = num*calcuteNum;
        } else if ([self.operator isEqualToString:@"+"]) {
            num = num+calcuteNum;
        } else if ([self.operator isEqualToString:@"-"]) {
            num = num-calcuteNum;
        }
        
        self.inputTextField.text = [NSString stringWithFormat:@"%@",@(num)];
        
        self.operator = nil;
        self.lastNum = nil;
        
        [self.historyResultArr addObject:self.inputTextField.text];
        [self.tableView reloadData];
    }
}

////去除尾部0
//- (NSString *)exactString:(NSString *)string
//{
//    NSString * testNumber = string;
//    NSString * s = nil;
//    NSInteger offset = testNumber.length - 1;
//    while (offset)
//    {
//        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
//        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
//        {
//            offset--;
//        }
//        else
//        {
//            break;
//        }
//    }
//    NSString *outNumber = [testNumber substringToIndex:offset+1];
//    return outNumber;
//}

#pragma mark -- UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyResultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.historyResultArr.count > 0) {
        return 44;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    header.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenW-60, header.f_height)];
    title.text = @"点击选择，右滑删除";
    [header addSubview:title];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    NSString *resultStr = self.historyResultArr[indexPath.row];
    cell.detailTextLabel.text = resultStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (self.operator && self.lastNum == nil) {
        
        self.lastNum = self.inputTextField.text;
        self.inputTextField.text = @"";
        
    }
    
    NSString *resultStr = self.historyResultArr[indexPath.row];
    self.inputTextField.text = resultStr;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.historyResultArr removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
   return @[rowAction];
}

@end

//
//  CalculatorVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/18.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "CalculatorVC.h"
#import "CalculatorCell.h"

@interface CalculatorVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CalculatorCellDelegate>

@property (nonatomic, strong) NSArray *calculatorKeyArr;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UnderlineTextField *inputTextField;

@end

@implementation CalculatorVC

- (UnderlineTextField *)inputTextField
{
    if (!_inputTextField) {
        _inputTextField = [[UnderlineTextField alloc] initWithFrame:CGRectMake(10, self.collectionView.f_y-50, kScreenW-20, 40)];
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
    if ([calculatorKey isEqualToString:@"÷"] || [calculatorKey isEqualToString:@"×"] || [calculatorKey isEqualToString:@"-"] || [calculatorKey isEqualToString:@"+"]) {
        couldSelected = true;
    }
    [cell setNameText:calculatorKey couldSelected:couldSelected];
    
    return cell;
}

- (void)clickText:(NSString *)text
{
    if ([text isEqualToString:@"C"]) {
        self.inputTextField.text = @"0";
    } else if ([text isEqualToString:@"+/-"]) {
        if ([self.inputTextField.text floatValue] > 0) {
            self.inputTextField.text = [NSString stringWithFormat:@"-%@",self.inputTextField.text];
        } else if ([self.inputTextField.text floatValue] < 0) {
            self.inputTextField.text = [self.inputTextField.text substringFromIndex:1];
        }
    } else if ([text isEqualToString:@"%"]) {
        self.inputTextField.text = [self exactString:[NSString stringWithFormat:@"%lf",[self.inputTextField.text doubleValue]/100]];
    }
//    else if ([text isEqualToString:@""]) {
//
//    }
    else {
        NSMutableString *string = [NSMutableString stringWithString:self.inputTextField.text];
        [string appendString:text];
        self.inputTextField.text = [NSString stringWithFormat:@"%@",@([string floatValue])];
    }
    
}

- (NSString *)exactString:(NSString *)string
{
    NSString * testNumber = string;
    NSString * s = nil;
    NSInteger offset = testNumber.length - 1;
    while (offset)
    {
        s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
        if ([s isEqualToString:@"0"] || [s isEqualToString:@"."])
        {
            offset--;
        }
        else
        {
            break;
        }
    }
    NSString *outNumber = [testNumber substringToIndex:offset+1];
    return outNumber;
}

@end

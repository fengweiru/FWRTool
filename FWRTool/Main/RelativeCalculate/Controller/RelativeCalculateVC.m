//
//  RelativeCalculateVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/17.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "RelativeCalculateVC.h"

@interface RelativeCalculateVC ()

@property (nonatomic, strong) UITextField *processTextField;
@property (nonatomic, strong) UITextField *resultTextField;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RelativeCalculateVC

- (UITextField *)processTextField
{
    if (!_processTextField) {
        _processTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, Height_For_AppHeader+20, kScreenW-40, 50)];
    }
    return _processTextField;
}

- (UITextField *)resultTextField
{
    if (!_resultTextField) {
        _resultTextField = [[UITextField alloc] initWithFrame:self.processTextField.frame];
        _resultTextField.f_y = self.processTextField.f_height + 20;
    }
    return _resultTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end

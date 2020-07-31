//
//  BaseViewController.m
//  AccountManager
//
//  Created by fengweiru on 2018/7/13.
//  Copyright © 2018年 fengweiru. All rights reserved.
//

#import "BaseViewController.h"
//#import "NetworkSessionManager.h"
//#import "RopeSkippingDataManager.h"

@interface BaseViewController ()

@property (nonatomic, strong) NSUserDefaults *userDefault;

@property (nonatomic, strong) MBProgressHUD *loadingView;

@property (nonatomic, assign) NSInteger loadingImageCount;

@end

@implementation BaseViewController

- (NSUserDefaults *)userDefault
{
    if (!_userDefault) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return _userDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBar];
}


- (void)setNavBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)setNavLeftBackItem
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:48/255. green:123/255.0 blue:246/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickForBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setNavLeftItemWithTitle:(NSString *)title
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton setTitle:title forState:UIControlStateNormal];
//    [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)setNavLeftItemWithImage:(UIImage *)image
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(clickForBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    negativeSpacer.width = -9;
        
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftItem, nil];

}

- (void)setNavRightNullItem
{
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)setNavRightItemWithTitle:(NSString *)title
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setTitle:title forState:UIControlStateNormal];
//    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)setNavRightItemWithImage:(UIImage *)image
{
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = CGRectMake(0, 0, 44, 44);
    [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(clickRightItem:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)clickForBack:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)clickLeftItem:(UIButton *)sender
{
    
}

- (void)clickRightItem:(UIButton *)sender
{
    
}



@end

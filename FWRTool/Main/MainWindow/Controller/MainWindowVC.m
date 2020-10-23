//
//  MainWindowVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/7/31.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "MainWindowVC.h"
#import "MainWindowCell.h"

#import "ColorPickerVC.h"

@interface MainWindowVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *toolArr;

@end

@implementation MainWindowVC

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 30;
        layout.minimumLineSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
        layout.itemSize = CGSizeMake((kScreenW-90)/2, 50);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = true;
        
        [_collectionView registerClass:[MainWindowCell class] forCellWithReuseIdentifier:@"MainWindowCell"];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[CommonClass createImageWithColor:CommonBlueColor withFrame:CGRectMake(0, 0, kScreenW, 88)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = Color_Background;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Property List" ofType:@"plist"];
    self.toolArr = [NSArray arrayWithContentsOfFile:path];
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.toolArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainWindowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainWindowCell" forIndexPath:indexPath];
    NSDictionary *tool = self.toolArr[indexPath.row];
    [cell configWithTitle:tool[@"name"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tool = self.toolArr[indexPath.row];
    NSString *className = tool[@"class"];
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end

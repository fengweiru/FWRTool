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

@end

@implementation MainWindowVC

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 30;
        layout.minimumLineSpacing = 30;
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
        layout.itemSize = CGSizeMake((kScreenW-90)/2, 40);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[MainWindowCell class] forCellWithReuseIdentifier:@"MainWindowCell"];
    }
    return _collectionView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:true animated:true];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = Color_Background;
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainWindowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MainWindowCell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ColorPickerVC *vc = [[ColorPickerVC alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

@end

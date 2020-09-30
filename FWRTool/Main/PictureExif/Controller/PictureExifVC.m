//
//  PictureExifVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/22.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "PictureExifVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>

@interface PictureExifVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSDictionary *mediadata;
@property (nonatomic, strong) NSArray *keyArr;

@end

@implementation PictureExifVC

- (NSArray *)keyArr
{
    if (!_keyArr) {
        _keyArr = [[NSArray alloc] init];
    }
    return _keyArr;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, kScreenH-Height_For_AppHeader) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 200)];
        header.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = header;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"照片exif";
    self.view.backgroundColor = Color_Background;
    
    [self setNavRightItemWithTitle:@"照片选择"];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, 200)];
    self.imageView.backgroundColor = [UIColor clearColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *inArr = (NSArray *)self.keyArr[section];
    return inArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *inArr = (NSArray *)self.keyArr[section];
    NSString *inKey = [inArr firstObject];
    if ([inKey componentsSeparatedByString:@"."].count == 1) {
        return 5;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *inArr = (NSArray *)self.keyArr[section];
    NSString *inKey = [inArr firstObject];
    if ([inKey componentsSeparatedByString:@"."].count == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
        header.backgroundColor = FColor(0xee, 0xee, 0xee);;
        return header;
    } else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
        header.backgroundColor = FColor(0xee, 0xee, 0xee);;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, kScreenW-50, 30)];
        title.font = FFontRegular(14);
        title.textColor = [UIColor grayColor];
        [header addSubview:title];
        
        NSString *keys = [inArr firstObject];
        NSArray *keyArr = [keys componentsSeparatedByString:@"."];
        title.text = [keyArr firstObject];
        
        return header;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    NSArray *inArr = (NSArray *)self.keyArr[indexPath.section];
    NSString *keys = inArr[indexPath.row];
    
    NSArray *keyArr = [keys componentsSeparatedByString:@"."];
    if (keyArr.count == 1) {
        cell.textLabel.text = keys;
        cell.detailTextLabel.text = [self.mediadata[keys] description];
    } else {
        NSString *inKey = keyArr[1];
        cell.textLabel.text = inKey;
        
        NSMutableString *detailStr = [[NSMutableString alloc] init];
        id object = self.mediadata[keyArr[0]][inKey];
        if ([object isKindOfClass:[NSArray class]]) {
            [detailStr appendString:[(NSArray *)object componentsJoinedByString:@","]];
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            NSArray *objectKeys = [(NSDictionary *)object allKeys];
            for (NSString *objectKey in objectKeys) {
                if ([objectKeys indexOfObject:objectKey] != 0) {
                    [detailStr appendString:@" , "];
                }
                [detailStr appendFormat:@"%@ = %@",objectKey,[(NSDictionary *)object objectForKey:objectKey]];
            }
        } else {
            [detailStr appendFormat:@"%@",object];
        }
        cell.detailTextLabel.text = detailStr;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        CGPoint point = scrollView.contentOffset;
        if (point.y < 0) {
            CGRect rect = self.imageView.frame;
            rect.size.height = 200 - point.y;
            self.imageView.frame = rect;
        }
    }
       
}

- (void)clickRightItem:(UIButton *)sender
{
    WS(weakSelf);
    
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"照片选择" message:@"请选择需要获取exif信息的照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = weakSelf;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            vc.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:vc animated:true completion:nil];
        } else {
            [weakSelf.view makeToast:@"无相机权限"];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = weakSelf;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:vc animated:true completion:nil];
        } else {
            [weakSelf.view makeToast:@"无权限打开相册"];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [vc addAction:action1];
    [vc addAction:action2];
    [vc addAction:action3];
    [self presentViewController:vc animated:true completion:nil];
}
#pragma mark -- delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [self dismissViewControllerAnimated:true completion:nil];
    
    //取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = pickImage;
    
//    self.imageView.f_width = pickImage.size.width/pickImage.size.height * self.imageView.f_height;
//    self.imageView.f_x = (kScreenW-self.imageView.f_width)/2;
    
    NSDictionary *mediadata;
    if (info[UIImagePickerControllerMediaMetadata]) {
        mediadata = info[UIImagePickerControllerMediaMetadata];
        
    } else {
        NSURL *imageUrl = info[UIImagePickerControllerImageURL];

        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageUrl, NULL);
        CFDictionaryRef imageInfo = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        
        mediadata = (__bridge_transfer  NSDictionary*)imageInfo;
    }
    NSLog(@"%@",mediadata);
    
    self.mediadata = mediadata;
    
    NSMutableArray *keyArr = [[NSMutableArray alloc] init];
    NSArray *outKeyArr = [mediadata allKeys];
    for (NSString *key in outKeyArr) {
        id object1 = mediadata[key];
        if ([object1 isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *inArr = [[NSMutableArray alloc] init];
            
            NSDictionary *dict = (NSDictionary *)object1;
            NSArray *inKeyArr = [dict allKeys];
            for (NSString *inKey in inKeyArr) {
                NSString *comKey = [NSString stringWithFormat:@"%@.%@",key,inKey];
                [inArr addObject:comKey];
            }
            
            [keyArr addObject:[NSArray arrayWithArray:inArr]];
            
        } else {
            
            [keyArr addObject:[NSArray arrayWithObject:key]];
        }
    }
    
    self.keyArr = [NSArray arrayWithArray:keyArr];
    
    [self.tableView reloadData];
    
}

@end

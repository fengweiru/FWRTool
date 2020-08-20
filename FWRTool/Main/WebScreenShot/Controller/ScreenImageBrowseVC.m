//
//  ScreenImageBrowseVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/20.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "ScreenImageBrowseVC.h"
#import <Photos/Photos.h>

@interface ScreenImageBrowseVC ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ScreenImageBrowseVC

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-Height_For_AppHeader)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _imageView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, kScreenH-Height_For_AppHeader)];
        
        [_scrollView addSubview:self.imageView];
    }
    return _scrollView;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavRightItemWithTitle:@"保存截图"];
    
    [self.view addSubview:self.scrollView];
    
    self.imageView.image = self.image;
    self.imageView.f_height = self.image.size.height/self.image.size.width * _imageView.f_width;
    self.scrollView.contentSize = CGSizeMake(0, self.imageView.f_height);
}

- (void)clickRightItem:(UIButton *)sender
{
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
      } error:&error];
    
    if (!error) {
        [self.view makeToast:@"保存成功！"];
    }
}



@end

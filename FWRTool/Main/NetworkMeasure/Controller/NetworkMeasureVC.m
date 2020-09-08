//
//  NetworkMeasureVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/8/25.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "NetworkMeasureVC.h"
#import "NetworkMeasure.h"

@interface NetworkMeasureVC ()

@end

@implementation NetworkMeasureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NetworkMeasure shareClient] startMonitor];
}

- (void)dealloc
{
    [[NetworkMeasure shareClient] stopMonitor];
}

@end

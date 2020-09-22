//
//  FixedDialingNumberVC.m
//  FWRTool
//
//  Created by 冯伟如 on 2020/9/21.
//  Copyright © 2020 Fengweiru. All rights reserved.
//

#import "FixedDialingNumberVC.h"

@interface FixedDialingNumberVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *phoneArr;

@end

@implementation FixedDialingNumberVC

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Height_For_AppHeader, kScreenW, kScreenH-Height_For_AppHeader) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"一键拨号";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DialingNumber" ofType:@"plist"];
    self.phoneArr = [NSArray arrayWithContentsOfFile:path];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.phoneArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *classDic = self.phoneArr[section];
    NSArray *list = classDic[@"list"];
    return list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    header.backgroundColor = FColor(0xee, 0xee, 0xee);
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenW-40, 30)];
    title.font = FFontRegular(14);
    title.textColor = [UIColor grayColor];
    [header addSubview:title];
    
    NSDictionary *classDic = self.phoneArr[section];
    title.text = classDic[@"name"];
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSDictionary *classDic = self.phoneArr[indexPath.section];
    NSArray *list = classDic[@"list"];
    NSDictionary *dict = list[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.detailTextLabel.text = dict[@"number"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    NSDictionary *classDic = self.phoneArr[indexPath.section];
    NSArray *list = classDic[@"list"];
    NSDictionary *dict = list[indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",dict[@"number"]]];
    [[UIApplication sharedApplication] openURL:url];
}

@end

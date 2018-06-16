//
//  SettingViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "SettingViewController.h"
#import "IPSettingViewController.h"
#import "AboutUSViewController.h"
#import "SettingTableCell.h"

static NSString *const CellID = @"SettingTableCell";

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLbl.text = @"全屏显示";
            cell.contentLbl.text = @"隐藏状态栏";
        } else {
            cell.titleLbl.text = @"显示页码";
            cell.contentLbl.text = @"在阅读界面显示页码";
        }
    
    } else {
        if (indexPath.row == 0) {
            cell.titleLbl.text = @"IP设置";
            cell.contentLbl.text = @"设置书库连接的IP";
        } else {
            cell.titleLbl.text = @"关于我们";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            IPSettingViewController *ipSettingVC = [[IPSettingViewController alloc]init];
            ipSettingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ipSettingVC animated:YES];
            
        } else {
            AboutUSViewController *aboutUsVC = [[AboutUSViewController alloc]init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
            
        }
    }
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        [_tableView registerClass:SettingTableCell.class forCellReuseIdentifier:CellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 65;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

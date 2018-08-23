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
#import "ActivationCodeViewController.h"

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
    return [kUserDefaults boolForKey:@"ShowActivationCode"] ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    if ([kUserDefaults boolForKey:@"ShowActivationCode"]) {
        if (indexPath.section == 0) {
            cell.titleLbl.text = @"激活码";
        } else {
            cell.titleLbl.text = @"关于我们";
        }
    } else {
        cell.titleLbl.text = @"关于我们";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([kUserDefaults boolForKey:@"ShowActivationCode"]) {
        if (indexPath.section == 0) {
            ActivationCodeViewController *activationCodeVC = [[ActivationCodeViewController alloc]init];
            activationCodeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:activationCodeVC animated:YES];
            
        } else {
            AboutUSViewController *aboutUsVC = [[AboutUSViewController alloc]init];
            aboutUsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    } else {
        AboutUSViewController *aboutUsVC = [[AboutUSViewController alloc]init];
        aboutUsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }
    
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight- kNavigationBarHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        [_tableView registerClass:SettingTableCell.class forCellReuseIdentifier:CellID];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

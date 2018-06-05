//
//  IPSettingViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "IPSettingViewController.h"

@interface IPSettingViewController ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *ipTxt;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UILabel *tipLbl;

@end

@implementation IPSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"IP设置";
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.ipTxt];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.tipImageView];
    [self.view addSubview:self.tipLbl];
    [self autoLayout];
}

- (void)autoLayout {
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight + 20);
        make.left.mas_equalTo(self.view).offset(20);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    [_ipTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView).offset(10);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
        make.height.mas_equalTo(45);
    }];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(45);
    }];
    
    [_tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.saveBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(15);
    }];
    
    [_tipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipImageView.mas_right).offset(5);
        make.top.mas_equalTo(self.tipImageView);
    }];
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = Font(14);
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"请填写本单位五车电子图书服务器访问地址";
    }
    return _titleLbl;
}

- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"ebebeb"].CGColor;
        _bgView.layer.borderWidth = 1;
    }
    return _bgView;
}

- (UITextField *)ipTxt {
    if(!_ipTxt) {
        _ipTxt = [[UITextField alloc]init];
        _ipTxt.textColor = [UIColor colorWithHexString:@"999999"];
        _ipTxt.text = @"http://";
    }
    return _ipTxt;
}

- (UIButton *)saveBtn {
    if(!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.backgroundColor = OrangeThemeColor;
        _saveBtn.layer.cornerRadius = 5;
        [_saveBtn setTitle:@"测试并保存" forState:UIControlStateNormal];
//        [_saveBtn addTarget:self action:@selector(<#btnClick#>:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIImageView *)tipImageView {
    if(!_tipImageView) {
        _tipImageView = [[UIImageView alloc]init];
        _tipImageView.image = IMAGENAMED(@"tip");
    }
    return _tipImageView;
}

- (UILabel *)tipLbl {
    if(!_tipLbl) {
        _tipLbl = [[UILabel alloc]init];
        _tipLbl.font = Font(12);
        _tipLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _tipLbl.text = @"提示：根据本单位安装的五车数字图书服务器访问地址来填写\n如：http://211.81.40.104:8081/5clib";
        _tipLbl.numberOfLines = 2;
    }
    return _tipLbl;
}
@end

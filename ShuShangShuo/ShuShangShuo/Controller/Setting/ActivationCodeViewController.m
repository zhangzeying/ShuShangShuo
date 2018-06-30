//
//  ActivationCodeViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 27/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "ActivationCodeViewController.h"
#import "AFNetworking.h"
#import <YYModel.h>
#import "DownloadBookModel.h"
#import "DownLoadViewController.h"

@interface ActivationCodeViewController ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UITextField *inputTxt;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation ActivationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"激活码";
    [self setupUI];
    [self autoLayout];
}

- (void)setupUI {
    [self.view addSubview:self.titleLbl];
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.inputTxt];
    [self.view addSubview:self.submitBtn];
}

- (void)autoLayout {
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight + 50);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(45);
    }];
    
    [_inputTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView).offset(10);
        make.right.mas_equalTo(self.bgView.mas_right).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputTxt.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

- (void)submitBtnClick {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSDictionary *params = @{@"code":self.inputTxt.text};
    [SProgressHUD showWaiting:nil];
    [manager POST:@"http://wx.5csss.com/booklist/index/getBookList" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [SProgressHUD hideHUDfromView:nil];
        if ([responseObject[@"code"] isEqualToString:@"200"]) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[DownloadBookModel class] json:responseObject[@"result"]];
            DownLoadViewController *downloadVC = [[DownLoadViewController alloc]init];
            downloadVC.grade =responseObject[@"grade"];
            downloadVC.dataArr = array;
            downloadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:downloadVC animated:YES];
            
        } else {
            [SProgressHUD showFailure:responseObject[@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SProgressHUD hideHUDfromView:nil];
    }];
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = Font(16);
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"请将激活码输入下方";
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

- (UITextField *)inputTxt {
    if(!_inputTxt) {
        _inputTxt = [[UITextField alloc]init];
        _inputTxt.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _inputTxt;
}

- (UIButton *)submitBtn {
    if(!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = OrangeThemeColor;
        _submitBtn.layer.cornerRadius = 5;
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}



@end

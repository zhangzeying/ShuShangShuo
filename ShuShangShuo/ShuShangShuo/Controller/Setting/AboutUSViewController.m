//
//  AboutUSViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 15/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "AboutUSViewController.h"
#import <WebKit/WebKit.h>

@interface AboutUSViewController () <WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property(nonatomic,strong)CALayer *progresslayer;
@property(nonatomic,strong)UIView *naviView;
@property(nonatomic,assign)BOOL isFristLoadWeb;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self.view addSubview:self.webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self setupWebViewProgress];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
   
}

- (void)setupWebViewProgress {
    UIView *progress = [[UIView alloc]initWithFrame:CGRectZero];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationBarHeight);
        make.height.equalTo(2);
    }];
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 2);
    layer.backgroundColor = OrangeThemeColor.CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
}

//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (!self.isFristLoadWeb) {
        self.isFristLoadWeb = YES;
    }
}

//注册webView 的监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (!self.isFristLoadWeb) {
            self.progresslayer.opacity = 1;
            //不要让进度条倒着走...有时候goback会出现这种情况
            if ([change[@"new"] floatValue] < [change[@"old"] floatValue]) {
                return;
            }
            self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[@"new"] floatValue], 3);
            __weak typeof(self) weakSelf = self;
            if ([change[@"new"] floatValue] >= 1) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.progresslayer.opacity = 0;
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakSelf.progresslayer.frame = CGRectMake(0, 0, 0, 3);
                });
            }
        }
    }
    
}

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://5csss.com"]]];
    }
    return _webView;
}

@end

//
//  BaseNavigationController.m
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = NormalDefaultThemeColor;
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:18.0];
    [self.navigationBar setTitleTextAttributes:attr];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"navigation_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)backClick {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

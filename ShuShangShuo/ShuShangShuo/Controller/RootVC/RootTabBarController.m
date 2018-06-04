//
//  RootTabBarController.m
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavigationController.h"
#import "STabBar.h"

@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    STabBar *tabbar = [[STabBar alloc] init];

    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

//设置tabBar
- (void)setTabBar {
    
    //添加子控制器
    NSArray *classNames = @[@"BookshelfViewController", @"BookshelfViewController"];
    
    NSArray *titles = @[@"书架", @"设置"];
    
    NSArray *imageNames = @[@"book_center_normal", @"setting_normal"];
    
    NSArray *selectedImageNames = @[@"book_center_selected", @"setting_selected"];
    
    for (int i = 0; i < classNames.count; i++) {
        
        UIViewController *vc = (UIViewController *)[[NSClassFromString(classNames[i]) alloc] init];
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.tabBarItem.title = titles[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
//        vc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
//        vc.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:nc];
        
    }
    self.selectedIndex = 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

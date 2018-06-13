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
#import "SGQRCode.h"
#import "SGQRCodeScanningVC.h"

@interface RootTabBarController () <STabBarDelegate>

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTabBar];
    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    STabBar *tabbar = [[STabBar alloc] init];
    tabbar.tabbarDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
}

//设置tabBar
- (void)setTabBar {
    
    //添加子控制器
    NSArray *classNames = @[@"HomeViewController", @"SettingViewController"];
    
    NSArray *titles = @[@"书架", @"设置"];
    
    NSArray *imageNames = @[@"book_center_normal", @"setting_normal"];
    
    NSArray *selectedImageNames = @[@"book_center_selected", @"setting_selected"];
    
    for (int i = 0; i < classNames.count; i++) {
        
        UIViewController *vc = (UIViewController *)[[NSClassFromString(classNames[i]) alloc] init];
        BaseNavigationController *nc = [[BaseNavigationController alloc] initWithRootViewController:vc];
        vc.tabBarItem.title = titles[i];
        vc.tabBarItem.image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [IMAGENAMED(selectedImageNames[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:OrangeThemeColor} forState:UIControlStateSelected];
        [self addChildViewController:nc];
        
    }
}

#pragma mark - STabBarDelegate
- (void)scan {
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self.selectedViewController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.selectedViewController pushViewController:vc animated:YES];
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

//
//  SProgressHUD.h
//  ShuShangShuo
//
//  Created by zhangzey on 10/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SProgressHUD : UIView

#pragma mark ----- 1.7秒后隐藏
/**
 *  显示只有文字的HUD
 *
 *  @param message 文字信息
 */
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
/**
 *  显示成功样式的HUD
 *
 *  @param message 文字信息
 */
+ (void)showSuccess:(NSString *)message;
+ (void)showSuccess:(NSString *)message toView:(UIView *)view;

/**
 *  显示失败样式的HUD
 *
 *  @param message 文字信息
 */
+ (void)showFailure:(NSString *)message;
+ (void)showFailure:(NSString *)message toView:(UIView *)view;



#pragma mark ----- 需要手动隐藏

/**
 *  显示等待样式的HUD
 *
 *  @param message 文字信息
 */
+ (void)showWaiting:(NSString *)message;
+ (void)showWaiting:(NSString *)message toView:(UIView *)view;

/**
 显示进度条
 
 @param progressValue 0 - 1
 @param title 文字，默认是加载中
 @show  显示父视图
 */
+ (void)showProgressValue:(float)progressValue title:(NSString *)title;
+ (void)showProgressValue:(float)progressValue title:(NSString *)title toView:(UIView *)view;

#pragma mark ----- 隐藏
/**
 *  移除HUD
 */
+ (void)hideHUDfromView:(UIView *)view;

@end

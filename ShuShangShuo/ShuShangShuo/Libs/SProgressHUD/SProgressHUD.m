//
//  SProgressHUD.m
//  ShuShangShuo
//
//  Created by zhangzey on 10/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "SProgressHUD.h"
#import "MBProgressHUD.h"

CGFloat kLoadingTime =  1.7;

@implementation SProgressHUD

+ (CGSize)setSquareSize:(BOOL)squareSize{
    if (squareSize) {
        //正方形
        return CGSizeMake(105, 105);
    }else{
        return CGSizeMake(105, 40);
    }
}

#pragma mark - ClassMethod

+ (void)showMessage:(NSString *)message
{
    [[self class] showSuccess:message toView:kWindow];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.minSize = [[self class] setSquareSize:NO];
    hud.label.text = message;
    hud.label.font = Font(16);
    hud.margin = 10;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:kLoadingTime];
    
}

+ (void)showSuccess:(NSString *)message
{
    [[self class] showSuccess:message toView:kWindow];
}

+ (void)showSuccess:(NSString *)message toView:(UIView *)view
{
    [[self class] showMessage:message toView:view];//和普通信息一样
}

+ (void)showFailure:(NSString *)message
{
    [[self class] showFailure:message toView:kWindow];
}

+ (void)showFailure:(NSString *)message toView:(UIView *)view
{
    [[self class] showMessage:message toView:view];//和普通信息一样
}

+ (void)showWaiting:(NSString *)message
{
    [[self class]showWaiting:message toView:kWindow];
}

+ (void)showWaiting:(NSString *)message toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.contentColor = [UIColor whiteColor];
    hud.minSize = [[self class] setSquareSize:YES];
    hud.label.font = Font(16);
    if (message.length) {
        hud.label.text = message;
    }
}

+ (void)showProgressValue:(float)progressValue title:(NSString *)title
{
    [[self class] showProgressValue:progressValue title:title toView:kWindow];
}

+ (void)showProgressValue:(float)progressValue title:(NSString *)title toView:(UIView *)view
{
    if (title.length == 0) {
        title = @"加载中...";
    }
    if (!view) {
        view = kWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.bezelView.backgroundColor = [UIColor blackColor];
        hud.contentColor = [UIColor whiteColor];
        hud.minSize = [[self class] setSquareSize:YES];
        hud.label.text = title;
        hud.label.font = Font(16);
    }
    hud.progress = progressValue;
}

+ (void)hideHUDfromView:(UIView *)view
{
    if (!view) {
        view = kWindow;
    }
    [[MBProgressHUD HUDForView:view] hideAnimated:YES];
}

@end

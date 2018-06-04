//
//  CommonConst.h
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#ifndef CommonConst_h
#define CommonConst_h

//屏幕
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth ScreenBounds.size.width
#define ScreenHeight ScreenBounds.size.height

#define iPhone4_inch (ScreenHeight <= 480)
#define iPhone5_inch (ScreenHeight > 480 && ScreenHeight <= 568)
#define iPhone6_inch (ScreenHeight > 568 && ScreenHeight <= 667)
#define iPhone6p_inch (ScreenHeight > 667 && ScreenHeight <= 736)
#define iPhoneX_inch ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//获取MediumFont
#define Font(fontSize)           [UIFont systemFontOfSize:fontSize]
#define BOLDFont(fontSize)       [UIFont boldSystemFontOfSize:fontSize]
#define MediumFont(fontSize)     [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]?[UIFont fontWithName:@"PingFangSC-Medium" size:fontSize]:[UIFont systemFontOfSize:fontSize]

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define kNavigationBarHeight (kStatusBarHeight + 44)
#define kNavigationBarNoStatusBarHeight 44
#define kTabbarDefaultHeight 49
#define kIphoneXSafeBottomHeight 34
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kBottomHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:0)
#define kTopHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)

//当前App的版本号
#define SCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#endif /* CommonConst_h */

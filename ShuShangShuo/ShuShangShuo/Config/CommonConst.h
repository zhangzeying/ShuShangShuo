//
//  CommonConst.h
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#ifndef CommonConst_h
#define CommonConst_h

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

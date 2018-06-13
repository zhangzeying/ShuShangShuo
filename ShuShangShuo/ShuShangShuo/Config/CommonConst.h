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

#define kWindow ([UIApplication sharedApplication].keyWindow)

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
#define KCurrentVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define kDocuments NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

//---- epub相关 ----
#define TopSpacing 40.0f
#define BottomSpacing 40.0f
#define LeftSpacing 20.0f
#define RightSpacing  20.0f
#define MinFontSize 11.0f
#define MaxFontSize 20.0f
#define RGB(R, G, B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]
#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))
#define DistanceFromTopGuiden(view) (view.frame.origin.y + view.frame.size.height)
#define DistanceFromLeftGuiden(view) (view.frame.origin.x + view.frame.size.width)
#define ViewOrigin(view)   (view.frame.origin)

#define kUserDefaults [NSUserDefaults standardUserDefaults]

#endif /* CommonConst_h */

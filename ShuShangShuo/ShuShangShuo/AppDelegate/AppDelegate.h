//
//  AppDelegate.h
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookInfoModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray <BookInfoModel *>*staticsBookArr;
@property (nonatomic, assign) BOOL isShowActivationCode;

@end


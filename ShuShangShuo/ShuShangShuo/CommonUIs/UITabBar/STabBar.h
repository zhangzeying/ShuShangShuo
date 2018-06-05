//
//  STabBar.h
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STabBarDelegate <NSObject>

- (void)scan;

@end

@interface STabBar : UITabBar

@property (nonatomic, weak) id<STabBarDelegate> tabbarDelegate;

@end

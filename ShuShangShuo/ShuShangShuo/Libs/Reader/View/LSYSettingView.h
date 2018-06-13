//
//  LSYSettingView.h
//  ShuShangShuo
//
//  Created by zhangzey on 08/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSYMenuViewDelegate;

@interface LSYSettingView : UIView

@property (nonatomic,weak) id<LSYMenuViewDelegate>delegate;

@end

@interface LSYThemeView : UIView

@end

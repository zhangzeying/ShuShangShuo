//
//  ToolView.h
//  ShuShangShuo
//
//  Created by zhangzey on 28/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolViewDelegate <NSObject>

- (void)finish:(BOOL)isSelected;

@end

@interface ToolView : UIView

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic,weak) id<ToolViewDelegate> delegate;

@end

//
//  LSYMenuView.m
//  LSYReader
//
//  Created by Labanotation on 16/6/1.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYMenuView.h"
#import "LSYTopMenuView.h"
#import "LSYBottomMenuView.h"
#import "LSYSettingView.h"
#define AnimationDelay 0.3f
#define TopViewHeight 64.0f
#define BottomViewHeight 150.0f
#define SettingViewHeight 220.0f
@interface LSYMenuView ()<LSYMenuViewDelegate>
@property (nonatomic,assign) BOOL isShowSettingView;
@end
@implementation LSYMenuView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.settingView];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenSelf)]];
}
-(LSYTopMenuView *)topView
{
    if (!_topView) {
        _topView = [[LSYTopMenuView alloc] initWithFrame:CGRectMake(0, -TopViewHeight, self.width,TopViewHeight)];
        _topView.delegate = self;
    }
    return _topView;
}
-(LSYBottomMenuView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[LSYBottomMenuView alloc] initWithFrame:CGRectMake(0, self.height, self.width,BottomViewHeight)];
        _bottomView.delegate = self;
    }
    return _bottomView;
}
-(LSYSettingView *)settingView
{
    if (!_settingView) {
        _settingView = [[LSYSettingView alloc] initWithFrame:CGRectMake(0, self.height, self.width,SettingViewHeight)];
        _settingView.delegate = self;
    }
    return _settingView;
}
-(void)setRecordModel:(LSYRecordModel *)recordModel
{
    _recordModel = recordModel;
    _bottomView.readModel = recordModel;
}
#pragma mark - LSYMenuViewDelegate

-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewInvokeCatalog:)]) {
        [self.delegate menuViewInvokeCatalog:bottomMenu];
    }
}
-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    if ([self.delegate respondsToSelector:@selector(menuViewJumpChapter:page:)]) {
        [self.delegate menuViewJumpChapter:chapter page:page];
    }
}
-(void)menuViewFontSize
{
    if ([self.delegate respondsToSelector:@selector(menuViewFontSize)]) {
        [self.delegate menuViewFontSize];
    }
}
-(void)changeTransitionStyle:(UIPageViewControllerTransitionStyle)transitionStyle
{
    [self hiddenSelf];
    if ([self.delegate respondsToSelector:@selector(changeTransitionStyle:)]) {
        [self.delegate changeTransitionStyle:transitionStyle];
    }
}
- (void)changeMaskViewLight:(CGFloat)alpha {
    if ([self.delegate respondsToSelector:@selector(changeMaskViewLight:)]) {
        [self.delegate changeMaskViewLight:alpha];
    }
}
-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    if ([self.delegate respondsToSelector:@selector(menuViewMark:)]) {
        [self.delegate menuViewMark:topMenu];
    }
}
#pragma mark -
-(void)hiddenSelf
{
    if (self.isShowSettingView) {
        self.isShowSettingView = NO;
        [UIView animateWithDuration:AnimationDelay animations:^{
            self.settingView.frame = CGRectMake(0, self.height, self.width,SettingViewHeight);
            
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
        
    } else {
        [self hiddenAnimation:YES];
    }
}
-(void)showAnimation:(BOOL)animation
{
    self.hidden = NO;
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        self.topView.frame = CGRectMake(0, 0, self.width, TopViewHeight);
        self.bottomView.frame = CGRectMake(0, self.height-BottomViewHeight, self.width,BottomViewHeight);
    } completion:^(BOOL finished) {
        
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidAppear:)]) {
        [self.delegate menuViewDidAppear:self];
    }
}
-(void)hiddenAnimation:(BOOL)animation
{
    [UIView animateWithDuration:animation?AnimationDelay:0 animations:^{
        self.topView.frame = CGRectMake(0, -TopViewHeight, self.width, TopViewHeight);
        self.bottomView.frame = CGRectMake(0, self.height, self.width,BottomViewHeight);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
        [self.delegate menuViewDidHidden:self];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:LSYBottomMenuViewSettingBtnClickKey]) {//设置
        self.isShowSettingView = YES;
        [UIView animateWithDuration:AnimationDelay animations:^{
            self.topView.frame = CGRectMake(0, -TopViewHeight, self.width, TopViewHeight);
            self.bottomView.frame = CGRectMake(0, self.height, self.width,BottomViewHeight);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:AnimationDelay animations:^{
                self.settingView.frame = CGRectMake(0, self.height-SettingViewHeight, self.width,SettingViewHeight);
                
            } completion:^(BOOL finished) {
                
            }];
        }];
        if ([self.delegate respondsToSelector:@selector(menuViewDidHidden:)]) {
            [self.delegate menuViewDidHidden:self];
        }
    }
    
    
}
@end

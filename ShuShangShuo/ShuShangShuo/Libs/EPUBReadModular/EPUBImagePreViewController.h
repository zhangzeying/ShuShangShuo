//
//  CImagePreViewController.h
//  掌上阅读
//
//  Created by 易云时代 on 2017/8/10.
//  Copyright © 2017年 易云时代_ZXW. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EPUBCustomType.h"

@class EPUBReadMainViewController;
@interface EPUBImagePreViewController : UIViewController<UIScrollViewDelegate>

@property (weak,nonatomic) EPUBReadMainViewController *epubVC;
@property (strong, nonatomic) EPUBReadBackBlock backBlock; //应该是copy


@property (nonatomic,strong) NSMutableDictionary *info;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImage *image;

-(void)customViewInit:(CGRect)viewRect;     //创建
-(void)resizeViews:(CGRect)viewRect;        //布局
-(void)dataPrepare;                         //数据
-(void)initAfter;                           //线程初始化
-(void)refresh;                             //刷新


@end

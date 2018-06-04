//
//  BookshelfViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BookshelfViewController.h"
#import "SPPageMenu.h"

static CGFloat const pageMenuH = 50;

@interface BookshelfViewController () <SPPageMenuDelegate>

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childViewControllerArray;

@end

@implementation BookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[IMAGENAMED(@"search") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    
    self.pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, kNavigationBarHeight, 200, pageMenuH) trackerStyle:SPPageMenuTrackerStyleLine];
    self.pageMenu.centerX = self.view.centerX;
    [self.pageMenu setItems:@[@"浏览历史",@"我的书架"] selectedItemIndex:0];
    self.pageMenu.permutationWay = SPPageMenuPermutationWayNotScrollEqualWidths;
    self.pageMenu.dividingLine.hidden = YES;
    self.pageMenu.trackerWidth = 30;
    self.pageMenu.backgroundColor = [UIColor clearColor];
    self.pageMenu.tracker.backgroundColor = OrangeThemeColor;
    self.pageMenu.selectedItemTitleColor = OrangeThemeColor;
    self.pageMenu.unSelectedItemTitleColor = [UIColor darkGrayColor];
    self.pageMenu.itemTitleFont = [UIFont systemFontOfSize:14.f];
    self.pageMenu.itemPadding = 40;
    self.pageMenu.delegate = self;
    self.pageMenu.bridgeScrollView = self.scrollView;
    [self.view addSubview:self.pageMenu];
    
    [self.view addSubview:self.scrollView];

}

- (void)searchClick {
    
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGFloat scrollViewY = self.pageMenu.bottom;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, ScreenWidth, ScreenHeight - scrollViewY - kTabbarDefaultHeight - 10)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)childViewControllerArray {
    if (!_childViewControllerArray) {
        _childViewControllerArray = @[].mutableCopy;
    }
    return _childViewControllerArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

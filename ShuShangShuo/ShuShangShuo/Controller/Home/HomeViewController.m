//
//  HomeViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "HomeViewController.h"
#import "BookshelfViewController.h"
#import "HistorySearchViewController.h"
#import "SPPageMenu.h"
#import "DownLoadEpubFileTool.h"
#import "HSDownloadManager.h"

static CGFloat const pageMenuH = 50;

#define ScrollViewHeight (ScreenHeight - kNavigationBarHeight - pageMenuH - kTabbarDefaultHeight - 15)

@interface HomeViewController () <SPPageMenuDelegate>

@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *childViewControllerArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NOTIF_ADD(DownloadSucces, downloadSucces);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[IMAGENAMED(@"search") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(searchClick)];
    
    BookshelfViewController *browseHistoryVC = [[BookshelfViewController alloc]init];
    browseHistoryVC.pageStyle = PageStyle_BrowseHistory;
    [self.childViewControllerArray addObject:browseHistoryVC];
    [self addChildViewController:browseHistoryVC];
    
    BookshelfViewController *myBookshelfVC = [[BookshelfViewController alloc]init];
    myBookshelfVC.pageStyle = PageStyle_MyBookshelf;
    [self.childViewControllerArray addObject:myBookshelfVC];
    [self addChildViewController:myBookshelfVC];
    
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
    
    if (self.pageMenu.selectedItemIndex < self.childViewControllerArray.count) {
        BaseViewController *baseVc = self.childViewControllerArray[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:baseVc.view];
        baseVc.view.frame = CGRectMake(ScreenWidth * self.pageMenu.selectedItemIndex, 0, ScreenWidth, ScrollViewHeight);
        self.scrollView.contentOffset = CGPointMake(ScreenWidth * self.pageMenu.selectedItemIndex, 0);
        self.scrollView.contentSize = CGSizeMake(self.childViewControllerArray.count * ScreenWidth, 0);
    }
    
    [self.view addSubview:self.scrollView];
    
    NSString *currentDownloadUrl = [kUserDefaults objectForKey:@"current_download_url"];
    if (currentDownloadUrl.length > 0) {
        CGFloat progress = [[HSDownloadManager sharedInstance] progress:currentDownloadUrl];
        if (progress < 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"检测到上次有书籍未下载完成，是否继续下载？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [[DownLoadEpubFileTool sharedtool] downloadEpubFile:currentDownloadUrl];
                                                                  }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                     [[HSDownloadManager sharedInstance] deleteFile:currentDownloadUrl];
                                                                     [kUserDefaults removeObjectForKey:@"current_download_url"];
                                                                     [kUserDefaults synchronize];
                                                                     
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    }
    
}

- (void)searchClick {
    HistorySearchViewController *historySearchVC = [[HistorySearchViewController alloc]init];
    historySearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historySearchVC animated:YES];
}

- (void)downloadSucces {
    self.pageMenu.selectedItemIndex = 1;
}

#pragma mark - SPPageMenuDelegate

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
    if (labs(toIndex - fromIndex) >= 2) {
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth * toIndex, 0) animated:NO];
    } else {
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth * toIndex, 0) animated:YES];
    }
    if (self.childViewControllerArray.count <= toIndex) {return;}
    
    UIViewController *targetViewController = self.childViewControllerArray[toIndex];
    // 如果已经加载过，就不再加载
    if ([targetViewController isViewLoaded]) return;
    
    targetViewController.view.frame = CGRectMake(ScreenWidth * toIndex, 0, ScreenWidth, ScrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.pageMenu.bottom, ScreenWidth, ScrollViewHeight)];
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

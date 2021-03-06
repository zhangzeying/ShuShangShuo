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
#import "BookInfoModel.h"
#import "NSString+Hash.h"
#import "NSString+HTML.h"

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
    NOTIF_ADD(@"ChangeScrollState", changeScrollState:);
    UIImageView *image = [[UIImageView alloc]init];
    image.image = IMAGENAMED(@"logo");
    image.width = 50;
    image.height = 25;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[IMAGENAMED(@"logo") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
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
            NSString *code = [kUserDefaults objectForKey:HSFileName(currentDownloadUrl)];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"检测到上次有书籍未下载完成，是否继续下载？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      [[DownLoadEpubFileTool sharedtool] downloadEpubFile:currentDownloadUrl code:code isContinue:YES];
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
    
    if (![[kUserDefaults objectForKey:@"load"] boolValue]) {
        [self loadDefault];
    }
}

- (void)loadDefault {
    [SProgressHUD showWaiting:nil];
    NSArray *array = @[@"YcmccwcY0BB222FqY", @"YcmccwcY0I0I0IuLY", @"YcmccwcY0II221BvY", @"YcmccwcY0II556IyY", @"YcmccwcY0II556rvY"];
    for (int i = 0; i < array.count; i++) {
        NSString *fileName = array[i];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"5cb"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:HSCachesDirectory]) {
            [fileManager createDirectoryAtPath:HSCachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
        }
        BOOL flag = [[DownLoadEpubFileTool sharedtool] decodeEpubFile:fileData fileName:fileName];
        if (flag) {
            NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",fileName]];
            NSURL *fileURL = [NSURL URLWithString:fullPath];
            if ([fileURL.pathExtension isEqualToString:@"epub"]) {
                NSString *zipFile = [LSYReadUtilites unZip:fullPath];
                if (zipFile.length > 0) {
                    NSString *OPFPath = [LSYReadUtilites OPFPath:zipFile];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[LSYReadUtilites parseEpubInfo:OPFPath]];
                    NSString *str = [NSString stringWithFormat:@"%@/%@", [OPFPath stringByDeletingLastPathComponent],[dict objectForKey:@"coverHtmlPath"]];
                    BookInfoModel *model = [[BookInfoModel alloc]init];
                    model.title = [dict objectForKey:@"title"];
                    model.creator = [dict objectForKey:@"creator"];
                    NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[kDocuments stringByAppendingPathComponent:str]]] encoding:NSUTF8StringEncoding];
                    NSString *img = [self parserEpubCoverImg:[html stringByConvertingHTMLToPlainText]];
                    model.coverPath = [[str stringByDeletingLastPathComponent] stringByAppendingPathComponent:img];
                    model.fileUrl = fileName;
                    NSMutableArray *dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kMyBookshelfFilePath];
                    if (!dataArr) {
                        dataArr = [NSMutableArray arrayWithObjects:model, nil];
                        
                    } else {
                        [dataArr insertObject:model atIndex:0];
                    }
                    if ([NSKeyedArchiver archiveRootObject:dataArr toFile:kMyBookshelfFilePath]) {
                        [kUserDefaults setObject:@(YES) forKey:@"load"];
                        [kUserDefaults synchronize];
                    }
                }
            }
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SProgressHUD hideHUDfromView:nil];
    });
}

- (NSString *)parserEpubCoverImg:(NSString *)content
{
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:content];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            img = [img stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return img;
        } else{
            NSString *content;
            [scanner scanUpToString:@"<img>" intoString:&content];
        }
    }
    return nil;
}

- (void)searchClick {
    HistorySearchViewController *historySearchVC = [[HistorySearchViewController alloc]init];
    historySearchVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:historySearchVC animated:YES];
}

- (void)downloadSucces {
    if (self.pageMenu.selectedItemIndex == 1) {
        BookshelfViewController *vc = self.childViewControllerArray[self.pageMenu.selectedItemIndex];
        [vc loadData];
        
    } else {
        self.pageMenu.selectedItemIndex = 1;
        BookshelfViewController *vc = self.childViewControllerArray[self.pageMenu.selectedItemIndex];
        if (vc.isNotFristAppear) {
            [vc loadData];
        }
    }
    
}

- (void)changeScrollState:(NSNotification *)sender {
    NSString *state = sender.object;
    self.pageMenu.bridgeScrollView.scrollEnabled = [state isEqualToString:@"1"] ? NO : YES;
}

- (void)dealloc {
    NOTIF_REMV();
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

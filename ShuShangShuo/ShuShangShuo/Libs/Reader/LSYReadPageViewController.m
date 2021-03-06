//
//  LSYReadPageViewController.m
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import "LSYReadPageViewController.h"
#import "LSYReadViewController.h"
#import "LSYChapterModel.h"
#import "LSYMenuView.h"
#import "LSYCatalogViewController.h"
#import "UIImage+ImageEffects.h"
#import "LSYNoteModel.h"
#import "LSYMarkModel.h"
#import <objc/runtime.h>
#import "NSString+HTML.h"
#import "BookInfoModel.h"
#import "AppDelegate.h"

#define AnimationDelay 0.3

@interface LSYReadPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,LSYMenuViewDelegate,UIGestureRecognizerDelegate,LSYCatalogViewControllerDelegate,LSYReadViewControllerDelegate>
{
    NSUInteger _chapter;    //当前显示的章节
    NSUInteger _page;       //当前显示的页数
    NSUInteger _chapterChange;  //将要变化的章节
    NSUInteger _pageChange;     //将要变化的页数
    BOOL _isTransition;     //是否开始翻页
}
@property (nonatomic,strong) UIPageViewController *pageViewController;
@property (nonatomic,getter=isShowBar) BOOL showBar; //是否显示状态栏
@property (nonatomic,strong) LSYMenuView *menuView; //菜单栏
@property (nonatomic,strong) LSYCatalogViewController *catalogVC;   //侧边栏
@property (nonatomic,strong) UIView * catalogView;  //侧边栏背景
@property (nonatomic,strong) LSYReadViewController *readView;   //当前阅读视图
@property (nonatomic,assign) UIPageViewControllerTransitionStyle transitionStyle;
@property (nonatomic, strong) UILabel *pageLbl;
@property (nonatomic, strong) UIView *maskLightView;

@end

@implementation LSYReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitionStyle = UIPageViewControllerTransitionStylePageCurl;
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:self.transitionStyle navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageViewController.view];
    [self addChildViewController:self.pageViewController];
    _chapter = _model.record.chapter;
    _page = _model.record.page;
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
        tap.delegate = self;
        tap;
    })];
    
    if ([kUserDefaults boolForKey:@"show_page"] && _model.record.chapterModel.pageCount > 0) {
        [self.view addSubview:self.pageLbl];
        self.pageLbl.text = [NSString stringWithFormat:@"%ld / %ld", (_page+1), _model.record.chapterModel.pageCount];
    }
    [self.view addSubview:self.maskLightView];
    [self.view addSubview:self.menuView];
    
    [self addChildViewController:self.catalogVC];
    [self.view addSubview:self.catalogView];
    [self.catalogView addSubview:self.catalogVC.view];

    //添加笔记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotes:) name:LSYNoteNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.bookInfoModel.begin_time = (NSInteger)floor([[NSDate date] timeIntervalSince1970]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    __block NSInteger total = 0;
    [self.model.chapters enumerateObjectsUsingBlock:^(LSYChapterModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        total += obj.pageCount;
    }];
    CGFloat current = 0.f;
    for (int i = 0; i < _chapter; i++) {
        LSYChapterModel *model = self.model.chapters[i];
        current += model.pageCount;
    }
    current += _page + 1;
    self.bookInfoModel.readProgress = current / total;
    self.bookInfoModel.end_time = (NSInteger)floor([[NSDate date] timeIntervalSince1970]);
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appDelegate.staticsBookArr) {
        appDelegate.staticsBookArr = [NSMutableArray arrayWithObjects:self.bookInfoModel, nil];
    } else {
        [appDelegate.staticsBookArr addObject:self.bookInfoModel];
    }
}

-(void)addNotes:(NSNotification *)no
{
    LSYNoteModel *model = no.object;
    model.recordModel = [_model.record copy];
    [[_model mutableArrayValueForKey:@"notes"] addObject:model];    //这样写才能KVO数组变化
    [LSYReadUtilites showAlertTitle:nil content:@"保存笔记成功"];
}

-(BOOL)prefersStatusBarHidden
{
    return [kUserDefaults boolForKey:@"full_screen"];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)showToolMenu
{
    [_readView.readView cancelSelected];
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    
    id state = _model.marksRecord[key];
    state?(_menuView.topView.state=1): (_menuView.topView.state=0);
    [self.menuView showAnimation:YES];
    
}

#pragma mark - init
-(LSYMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[LSYMenuView alloc] initWithFrame:self.view.frame];
        _menuView.hidden = YES;
        _menuView.delegate = self;
        _menuView.recordModel = _model.record;
    }
    return _menuView;
}

-(LSYCatalogViewController *)catalogVC
{
    if (!_catalogVC) {
        _catalogVC = [[LSYCatalogViewController alloc] init];
        _catalogVC.readModel = _model;
        _catalogVC.catalogDelegate = self;
    }
    return _catalogVC;
}
-(UIView *)catalogView
{
    if (!_catalogView) {
        _catalogView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.width, 0, 2*self.view.width, self.view.height)];
        _catalogView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _catalogView.hidden = YES;
        [_catalogView addGestureRecognizer:({
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenCatalog)];
            tap.delegate = self;
            tap;
        })];
    }
    return _catalogView;
}

- (UILabel *)pageLbl {
    if(!_pageLbl) {
        _pageLbl = [[UILabel alloc]init];
        _pageLbl.frame = CGRectMake(ScreenWidth - 200 - 20, ScreenHeight - 30 - 20, 200, 30);
        _pageLbl.textColor = [UIColor grayColor];
        _pageLbl.font = Font(13);
        _pageLbl.textAlignment = NSTextAlignmentRight;
    }
    return _pageLbl;
}

- (UIView *)maskLightView {
    if(!_maskLightView) {
        _maskLightView=[[UIView alloc]initWithFrame:self.view.frame];
        _maskLightView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        _maskLightView.userInteractionEnabled=NO;
    }
    return _maskLightView;
}

#pragma mark - CatalogViewController Delegate
-(void)catalog:(LSYCatalogViewController *)catalog didSelectChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
    [self hiddenCatalog];
    
}
#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
#pragma mark - Privite Method
-(void)catalogShowState:(BOOL)show
{
    WEAKSELF
    show?({
        STRONGSELF
        strongSelf.catalogView.hidden = !show;
        [UIView animateWithDuration:AnimationDelay animations:^{
            STRONGSELF
            strongSelf.catalogView.frame = CGRectMake(0, 0,2*self.view.width, self.view.height);
            
        } completion:^(BOOL finished) {

        }];
    }):({
        STRONGSELF
        if ([strongSelf.catalogView.subviews.firstObject isKindOfClass:[UIImageView class]]) {
            [strongSelf.catalogView.subviews.firstObject removeFromSuperview];
        }
        [UIView animateWithDuration:AnimationDelay animations:^{
            STRONGSELF
             strongSelf.catalogView.frame = CGRectMake(-self.view.width, 0, 2*self.view.width, self.view.height);
        } completion:^(BOOL finished) {
            STRONGSELF
            strongSelf.catalogView.hidden = !show;
        }];
    });
}
-(void)hiddenCatalog
{
    [self catalogShowState:NO];
}
#pragma mark - Menu View Delegate
-(void)menuViewDidHidden:(LSYMenuView *)menu
{
     _showBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)menuViewDidAppear:(LSYMenuView *)menu
{
    _showBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
}
-(void)menuViewInvokeCatalog:(LSYBottomMenuView *)bottomMenu
{
    [_menuView hiddenAnimation:NO];
    [self catalogShowState:YES];
    
}

-(void)menuViewJumpChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    [_pageViewController setViewControllers:@[[self readViewWithChapter:chapter page:page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:chapter page:page];
}
-(void)menuViewFontSize
{
    [_model.record.chapterModel updateFont];
    [_pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self updateReadModelWithChapter:_model.record.chapter page:(_model.record.page>_model.record.chapterModel.pageCount-1)?_model.record.chapterModel.pageCount-1:_model.record.page];
}

- (void)changeTransitionStyle:(UIPageViewControllerTransitionStyle)transitionStyle {
    self.transitionStyle = transitionStyle;
    if (_pageViewController) {
        [_pageViewController.view removeFromSuperview];
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:self.transitionStyle navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [self.pageViewController setViewControllers:@[[self readViewWithChapter:_model.record.chapter page:_model.record.page]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self.view addSubview:_pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.view bringSubviewToFront:_pageLbl];
    [self.view bringSubviewToFront:self.maskLightView];
    [self.view bringSubviewToFront:self.menuView];
    [self.view bringSubviewToFront:self.catalogView];
    _chapter = _model.record.chapter;
    _page = _model.record.page;
}

- (void)changeMaskViewLight:(CGFloat)alpha {
    self.maskLightView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
}

-(void)menuViewMark:(LSYTopMenuView *)topMenu
{
    NSString * key = [NSString stringWithFormat:@"%d_%d",(int)_model.record.chapter,(int)_model.record.page];
    id state = _model.marksRecord[key];
    if (state) {
//如果存在移除书签信息
        [_model.marksRecord removeObjectForKey:key];
        [[_model mutableArrayValueForKey:@"marks"] removeObject:state];
    }
    else{
//记录书签信息
        LSYMarkModel *model = [[LSYMarkModel alloc] init];
        model.date = [NSDate date];
        model.recordModel = [_model.record copy];
        [[_model mutableArrayValueForKey:@"marks"] addObject:model];
        [_model.marksRecord setObject:model forKey:key];
    }
    _menuView.topView.state = !state;


}
#pragma mark - Create Read View Controller

-(LSYReadViewController *)readViewWithChapter:(NSUInteger)chapter page:(NSUInteger)page{
    if (_model.record.chapter != chapter) {
        [_model.record.chapterModel updateFont];
        if (_model.type == ReaderEpub) {
            if (!_model.chapters[chapter].epubframeRef) {
                NSString *path = [kDocuments stringByAppendingPathComponent:_model.chapters[chapter].chapterpath];
                NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] encoding:NSUTF8StringEncoding];
                _model.chapters[chapter].content = [html stringByConvertingHTMLToPlainText];
                [_model.chapters[chapter] parserEpubToDictionary];
            }
            [ _model.chapters[chapter] paginateEpubWithBounds:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
        }
    }
    _readView = [[LSYReadViewController alloc] init];
    _readView.recordModel = _model.record;
//     NSLog(@"---%@",[NSURL fileURLWithPath:_model.chapters[chapter].chapterpath]);
    if (_model.type == ReaderEpub) {
        _readView.type = ReaderEpub;
        if (!_model.chapters[chapter].epubframeRef) {
            NSString *path = [kDocuments stringByAppendingPathComponent:_model.chapters[chapter].chapterpath];
            NSString* html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] encoding:NSUTF8StringEncoding];
            _model.chapters[chapter].content = [html stringByConvertingHTMLToPlainText];
            [_model.chapters[chapter] parserEpubToDictionary];
            [_model.chapters[chapter] paginateEpubWithBounds:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-LeftSpacing-RightSpacing, [UIScreen mainScreen].bounds.size.height-TopSpacing-BottomSpacing)];
        }
        
        _readView.epubFrameRef = _model.chapters[chapter].epubframeRef[page];
        _readView.imageArray = _model.chapters[chapter].imageArray;
        _readView.content = _model.chapters[chapter].content;
    }
    else{
        _readView.type = ReaderTxt;
        _readView.content = [_model.chapters[chapter] stringOfPage:page];
    }
    _readView.delegate = self;

    
    return _readView;
}
-(void)updateReadModelWithChapter:(NSUInteger)chapter page:(NSUInteger)page
{
    _chapter = chapter;
    _page = page;
    _model.record.chapterModel = _model.chapters[chapter];
    _model.record.chapter = chapter;
    _model.record.page = page;
    [LSYReadModel updateLocalModel:_model url:_resourceURL];
    _pageLbl.text = [NSString stringWithFormat:@"%ld / %ld", (page+1), _model.record.chapterModel.pageCount];
}
#pragma mark - Read View Controller Delegate
-(void)readViewEndEdit:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = YES;
            break;
        }
    }
}
-(void)readViewEditeding:(LSYReadViewController *)readView
{
    for (UIGestureRecognizer *ges in self.pageViewController.view.gestureRecognizers) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled = NO;
            break;
        }
    }
}
#pragma mark -PageViewController DataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;

    if (_chapterChange==0 &&_pageChange == 0) {
        return nil;
    }
    if (_pageChange==0) {
        _chapterChange--;
        _pageChange = _model.chapters[_chapterChange].pageCount-1;
    }
    else{
        _pageChange--;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

    _pageChange = _page;
    _chapterChange = _chapter;
    if (_pageChange == _model.chapters.lastObject.pageCount-1 && _chapterChange == _model.chapters.count-1) {
        return nil;
    }
    if (_pageChange == _model.chapters[_chapterChange].pageCount-1) {
        _chapterChange++;
        _pageChange = 0;
    }
    else{
        _pageChange++;
    }
    
    return [self readViewWithChapter:_chapterChange page:_pageChange];
}
#pragma mark -PageViewController Delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) {
        LSYReadViewController *readView = previousViewControllers.firstObject;
        _readView = readView;
        _page = readView.recordModel.page;
        _chapter = readView.recordModel.chapter;
    }
    else{
        [self updateReadModelWithChapter:_chapter page:_page];
    }
}
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    _chapter = _chapterChange;
    _page = _pageChange;
}
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // 纵 单页
    UIViewController *currentViewController = [pageViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:currentViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    
    //Important- Set the doubleSided property to NO.
    pageViewController.doubleSided = NO;
    //Return the spine location
    return UIPageViewControllerSpineLocationMin;
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _pageViewController.view.frame = self.view.frame;
    _catalogVC.view.frame = CGRectMake(0, 0, self.view.width-100, self.view.height);
    [_catalogVC reload];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass(self.class));
    
}

@end

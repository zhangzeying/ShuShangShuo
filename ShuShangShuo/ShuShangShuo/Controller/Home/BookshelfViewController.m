//
//  BookshelfViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BookshelfViewController.h"
#import "BookshelfCollectionCell.h"
#import "LSYReadPageViewController.h"
#import "LSYReadUtilites.h"
#import "LSYReadModel.h"
#import "NSString+HTML.h"
#import "BookInfoModel.h"
#import "ToolView.h"
#import "UIResponder+Router.h"
#import "HSDownloadManager.h"
#import "UIImageView+WebCache.h"
#import "DownLoadEpubFileTool.h"

static NSString *const CellID = @"BookshelfCollectionCell";

@interface BookshelfViewController () <UICollectionViewDelegate, UICollectionViewDataSource, ToolViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ToolView *toolView;
@property (nonatomic, assign) BOOL isEditing;

@end

@implementation BookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    if (self.pageStyle == PageStyle_BrowseHistory) {
        NOTIF_ADD(ReloadHistoryPage, reloadHistoryPage);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isNotFristAppear) {
        [self loadData];
        self.isNotFristAppear = YES;
    }
}

- (void)loadData {
    if (self.pageStyle == PageStyle_BrowseHistory) {
        self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kBrowserHistoryFilePath];
        
    } else {
        self.dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kMyBookshelfFilePath];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)reloadHistoryPage {
    [self loadData];
}

- (void)setupUI {
    [self.view addSubview:self.collectionView];
    [self autoLayout];
}

- (void)autoLayout {
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:BookshelfCollectionCellLongPressKey]) {
        if (!_toolView) {
            [self.navigationController.view addSubview:self.toolView];
        }
        NSInteger index = [userInfo[@"rowIndex"] integerValue];
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BookInfoModel *model = obj;
            if (index == idx) {
                model.isSelected = YES;
            } else {
                model.isSelected = NO;
            }
        }];
        self.isEditing = YES;
        NOTIF_POST(@"ChangeScrollState", @"1");
        [self.collectionView reloadData];
    } else if ([eventName isEqualToString:BookshelfCollectionCellCheckBtnClickKey]) {
//        BOOL flag = NO;
//        for (BookInfoModel *model in self.dataArr) {
//            if (model.isSelected) {
//                flag = YES;
//                break;
//            }
//        }
//        self.toolView.finishBtn.selected = flag;
    }
}

- (UIImage *)parserEpubCoverImg:(NSString *)content imagePath:(NSString *)imagePath
{
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:content];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            img = [img stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *imageString = [[imagePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:img];
            UIImage *image = [UIImage imageWithContentsOfFile:imageString];
            CGFloat width = ScreenBounds.size.width - LeftSpacing - RightSpacing;
            CGFloat height = ScreenBounds.size.height - TopSpacing - BottomSpacing;
            CGFloat scale = image.size.width / width;
            CGFloat realHeight = image.size.height / scale;
            CGSize size = CGSizeMake(width, realHeight);
            if (size.height > (height - 20)) {
                size.height = height - 20;
            }
            return image;
        } else{
            NSString *content;
            [scanner scanUpToString:@"<img>" intoString:&content];
        }
    }
    return nil;
}

- (void)dealloc {
    if (self.pageStyle == PageStyle_BrowseHistory) {
        NOTIF_REMV();
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookshelfCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.bookTitle.hidden = YES;
    cell.index = indexPath.row;
    cell.checkBoxBtn.hidden = !self.isEditing;
    BookInfoModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    if (model.isNeedDownLoad) {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPath] placeholderImage:nil options:SDWebImageRetryFailed];
        
    } else {
        [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil options:SDWebImageRetryFailed];
        if (model.coverPath.length > 0) {
            cell.bookImageView.image = [UIImage imageWithContentsOfFile:[kDocuments stringByAppendingPathComponent:model.coverPath]];
            
        } else {
            cell.bookTitle.text = model.title;
            cell.bookTitle.hidden = NO;
            cell.bookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BookInfoModel *bookModel = self.dataArr[indexPath.row];
    if (self.isEditing) {
        BookshelfCollectionCell *cell = (BookshelfCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.checkBoxBtn.selected = !cell.checkBoxBtn.selected;
        bookModel.isSelected = cell.checkBoxBtn.selected;
        return;
    }
    
    if (bookModel.isNeedDownLoad) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"此书籍还未下载，是否下载？"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [[DownLoadEpubFileTool sharedtool] downloadEpubFile:bookModel.fileUrl code:bookModel.code isContinue:NO];
                                                              }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        
    } else {
        NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",bookModel.fileUrl]];
        NSURL *fileURL = [NSURL URLWithString:fullPath];
        [SProgressHUD showWaiting:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            LSYReadModel *model = [LSYReadModel getLocalModelWithURL:fileURL];
            LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
            pageView.resourceURL = model.resource;    //文件位置
            pageView.bookInfoModel = bookModel;
            pageView.model = model;
            NSMutableArray *historyDataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kBrowserHistoryFilePath];
            if (!historyDataArr) {
                historyDataArr = [NSMutableArray arrayWithObjects:bookModel, nil];
                
            } else {
                __block NSInteger index = -1;
                [historyDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BookInfoModel *item = obj;
                    if ([item.fileUrl isEqualToString:bookModel.fileUrl]) {
                        index = idx;
                        *stop = YES;
                    }
                }];
                if (index > -1) {
                    [historyDataArr removeObjectAtIndex:index];
                }
                [historyDataArr insertObject:bookModel atIndex:0];
            }
            [NSKeyedArchiver archiveRootObject:historyDataArr toFile:kBrowserHistoryFilePath];
            NOTIF_POST(ReloadHistoryPage, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SProgressHUD hideHUDfromView:nil];
                [self presentViewController:pageView animated:YES completion:nil];
            });
        });
    }
}

- (void)checkAll:(BOOL)isSelected {
    for (BookInfoModel *model in self.dataArr) {
        model.isSelected = isSelected;
    }
    [self.collectionView reloadData];
    self.toolView.finishBtn.selected = isSelected;
}

- (void)finish:(BOOL)isSelected {
    if (isSelected) { //完成
        if (_toolView) {
            [self.toolView removeFromSuperview];
            self.toolView = nil;
        }
        for (BookshelfCollectionCell *cell in self.collectionView.visibleCells) {
            cell.checkBoxBtn.hidden = YES;
        }
        self.isEditing = NO;
        NOTIF_POST(@"ChangeScrollState", @"0");
        
    } else { //删除
        NSMutableArray *tempArr = self.dataArr.mutableCopy;
        NSMutableArray *downloadUrlArr = [NSMutableArray arrayWithContentsOfFile:kDownloadUrlFilePath];
        for (BookInfoModel *model in tempArr) {
            if (model.isSelected) {
                [self.dataArr removeObject:model];
                [downloadUrlArr removeObject:model.fileUrl];
            }
        }
        if (self.pageStyle == PageStyle_BrowseHistory) {
            [NSKeyedArchiver archiveRootObject:self.dataArr toFile:kBrowserHistoryFilePath];
        } else {
            [NSKeyedArchiver archiveRootObject:self.dataArr toFile:kMyBookshelfFilePath];
        }
        [downloadUrlArr writeToFile:kDownloadUrlFilePath atomically:YES];
        [self.collectionView reloadData];
        
        if (_toolView) {
            [self.toolView removeFromSuperview];
            self.toolView = nil;
        }
        for (BookshelfCollectionCell *cell in self.collectionView.visibleCells) {
            cell.checkBoxBtn.hidden = YES;
        }
        self.isEditing = NO;
        NOTIF_POST(@"ChangeScrollState", @"0");
    }
}

#pragma mark - getter and setter
- (NSMutableArray *)dataArr {
    if(!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        CGFloat itemW = (ScreenWidth - 10 * 2 - 2 * 20) / 3;
        layout.itemSize = CGSizeMake(itemW, 115 * itemW / 90);
        layout.sectionInset = UIEdgeInsetsMake(15, 0, 0, 0);
        layout.minimumLineSpacing = 25;
        [_collectionView registerClass:BookshelfCollectionCell.class forCellWithReuseIdentifier:CellID];
    }
    return _collectionView;
}

- (ToolView *)toolView {
    if(!_toolView) {
        _toolView = [[ToolView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, ScreenWidth, 50)];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

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

static NSString *const CellID = @"BookshelfCollectionCell";

@interface BookshelfViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

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

- (UIImage *)parserEpubCoverImg:(NSString *)content imagePath:(NSString *)imagePath
{
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:content];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
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
    BookInfoModel *model = self.dataArr[indexPath.row];
    if (model.coverPath.length > 0) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *mediaType = [dict objectForKey:@"mediaType"];
            UIImage *coverImg = nil;
            NSString *path = [kDocuments stringByAppendingPathComponent:model.coverPath];
            NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] encoding:NSUTF8StringEncoding];
            coverImg = [self parserEpubCoverImg:[html stringByConvertingHTMLToPlainText] imagePath:path];
//            if ([mediaType containsString:@"image/"]) {
//                coverImg = [UIImage imageWithContentsOfFile:path];
//
//            } else {
//                NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] encoding:NSUTF8StringEncoding];
//                coverImg = [self parserEpubCoverImg:[html stringByConvertingHTMLToPlainText] imagePath:path];
//            }
            if (!coverImg) {
                coverImg = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.bookTitle.text = model.title;
                    cell.bookTitle.hidden = NO;
                    cell.bookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.bookImageView.image = coverImg;
                });
            }
            
        });
        
    } else {
        cell.bookTitle.text = model.title;
        cell.bookTitle.hidden = NO;
        cell.bookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BookInfoModel *bookModel = self.dataArr[indexPath.row];
    NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",bookModel.fileUrl]];
    NSURL *fileURL = [NSURL URLWithString:fullPath];
    [SProgressHUD showWaiting:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        LSYReadModel *model = [LSYReadModel getLocalModelWithURL:fileURL];
        LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
        pageView.resourceURL = model.resource;    //文件位置
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

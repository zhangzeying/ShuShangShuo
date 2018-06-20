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

static NSString *const CellID = @"BookshelfCollectionCell";

@interface BookshelfViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation BookshelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.pageStyle == PageStyle_BrowseHistory) {
        self.dataArr = [[NSMutableArray alloc] initWithContentsOfFile:kBrowserHistoryFilePath];
        
    } else {
        self.dataArr = [[NSMutableArray alloc] initWithContentsOfFile:kMyBookshelfFilePath];
    }
    [self.collectionView reloadData];
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
        }
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pageStyle == PageStyle_MyBookshelf ? self.dataArr.count + 1 : self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookshelfCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.bookTitle.hidden = YES;
    if (self.pageStyle == PageStyle_MyBookshelf && indexPath.row == self.dataArr.count) {
        cell.bookImageView.image = IMAGENAMED(@"add");
        
    } else {
        NSString *urlMD5 = self.dataArr[indexPath.row];
        NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",urlMD5]];
        NSString *zipFile = [[fullPath stringByDeletingPathExtension] lastPathComponent];
        NSString *OPFPath = [LSYReadUtilites OPFPath:zipFile];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[LSYReadUtilites parseEpubInfo:OPFPath]];
        NSString *str = [NSString stringWithFormat:@"%@/%@", [OPFPath stringByDeletingLastPathComponent],[dict objectForKey:@"coverHtmlPath"]];
        if (str.length > 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *path = [kDocuments stringByAppendingPathComponent:str];
                NSString *html = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]] encoding:NSUTF8StringEncoding];
                UIImage *coverImg = [self parserEpubCoverImg:[html stringByConvertingHTMLToPlainText] imagePath:path];
                if (!coverImg) {
                    coverImg = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.bookTitle.text = [dict objectForKey:@"title"];
                        cell.bookTitle.hidden = NO;
                    });
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.bookImageView.image = coverImg;
                });
            });
            
        } else {
            cell.bookTitle.text = [dict objectForKey:@"title"];
            cell.bookTitle.hidden = NO;
            cell.bookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pageStyle == PageStyle_MyBookshelf && indexPath.row == self.dataArr.count) {
        
    } else {
        NSString *urlMD5 = self.dataArr[indexPath.row];
        NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",urlMD5]];
        NSURL *fileURL = [NSURL URLWithString:fullPath];
        [SProgressHUD showWaiting:nil];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            LSYReadModel *model = [LSYReadModel getLocalModelWithURL:fileURL];
            LSYReadPageViewController *pageView = [[LSYReadPageViewController alloc] init];
            pageView.resourceURL = model.resource;    //文件位置
            pageView.model = model;
            NSMutableArray *historyDataArr = [[NSMutableArray alloc] initWithContentsOfFile:kBrowserHistoryFilePath];
            if (!historyDataArr) {
                historyDataArr = [NSMutableArray arrayWithObjects:urlMD5, nil];
                
            } else {
                if ([historyDataArr containsObject:urlMD5]) {
                    [historyDataArr removeObject:urlMD5];
                }
                [historyDataArr insertObject:urlMD5 atIndex:0];
            }
            [historyDataArr writeToFile:kBrowserHistoryFilePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SProgressHUD hideHUDfromView:nil];
                [self presentViewController:pageView animated:YES completion:nil];
            });
        });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

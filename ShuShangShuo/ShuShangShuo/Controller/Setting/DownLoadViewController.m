//
//  DownLoadViewController.m
//  ShuShangShuo
//
//  Created by zhangzey on 29/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "DownLoadViewController.h"
#import "BookshelfCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "DownloadBookModel.h"
#import "HSDownloadManager.h"
#import "NSString+Hash.h"
#import "BookInfoModel.h"
#import "DownLoadEpubFileTool.h"

static NSString *const CellID = @"CellID";

@interface DownLoadViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"书上说";
    self.index = 0;
    [self setupUI];
    [self autoLayout];
    self.titleLbl.text = [NSString stringWithFormat:@"%@小朋友专属书单", self.grade];
}

- (void)setupUI {
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.subTitleLbl];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.collectionView];
}

- (void)autoLayout {
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavigationBarHeight+10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [_subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
        make.centerY.mas_equalTo(self.subTitleLbl);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLbl.mas_bottom).offset(10);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)addBtnClick {
    [SProgressHUD showWaiting:@"正在下载..."];
    [self download];
}

- (void)download {
    DownloadBookModel *model = self.dataArr[self.index];
    NSString *url = model.download_url;
    WEAKSELF
    [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        NSLog(@"%f",progress);
        
    } state:^(DownloadState state) {
        if (state == DownloadStateStart) {

        } else if (state == DownloadStateCompleted) {
            STRONGSELF
            __block NSMutableArray *downloadUrlArr = [NSMutableArray arrayWithContentsOfFile:kDownloadUrlFilePath];
            NSString *filePath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",HSFileName(url)]];
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            BOOL flag = [[DownLoadEpubFileTool sharedtool] decodeEpubFile:fileData fileName:HSFileName(url)];
            if (flag) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    STRONGSELF
                    NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",HSFileName(url)]];
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
                            model.coverPath = str;
                            model.fileUrl = HSFileName(url);
                            NSMutableArray *dataArr = [NSKeyedUnarchiver unarchiveObjectWithFile:kMyBookshelfFilePath];
                            if (!dataArr) {
                                dataArr = [NSMutableArray arrayWithObjects:model, nil];
                                
                            } else {
                                [dataArr addObject:model];
                            }
                            
                            if (!downloadUrlArr) {
                                downloadUrlArr = [NSMutableArray arrayWithObjects:HSFileName(url), nil];
                                
                            } else {
                                [downloadUrlArr addObject:HSFileName(url)];
                            }
                            if ([NSKeyedArchiver archiveRootObject:dataArr toFile:kMyBookshelfFilePath] && [downloadUrlArr writeToFile:kDownloadUrlFilePath atomically:YES]) {
                                [[HSDownloadManager sharedInstance] deleteFile:url];
                                if (strongSelf.index == strongSelf.dataArr.count - 1) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [SProgressHUD hideHUDfromView:nil];
                                        [SProgressHUD showSuccess:@"添加成功"];
                                    });
                                    NOTIF_POST(DownloadSucces, nil);
                                }
                            }
                        }
                        
                    }
                    strongSelf.index++;
                    [strongSelf download];
                });
                
            } else {
                strongSelf.index++;
                [strongSelf download];
            }
 
        } else if (state == DownloadStateFailed) {
            STRONGSELF
            if (strongSelf.index == strongSelf.dataArr.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SProgressHUD hideHUDfromView:nil];
                    [SProgressHUD showFailure:@"添加失败"];
                });
            }
            strongSelf.index++;
            [strongSelf download];
        }
    }];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DownloadBookModel *model = self.dataArr[indexPath.row];
    BookshelfCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:nil options:SDWebImageRetryFailed];
    return cell;
}

- (UIView *)contentView {
    if(!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _contentView;
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = Font(16);
        _titleLbl.textColor = [UIColor darkGrayColor];
    }
    return _titleLbl;
}

- (UILabel *)subTitleLbl {
    if(!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc]init];
        _subTitleLbl.font = Font(13);
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _subTitleLbl.text = @"请点击右侧加号，将书加入书架";
    }
    return _subTitleLbl;
}

- (UIButton *)addBtn {
    if(!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setBackgroundImage:IMAGENAMED(@"add") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
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
@end

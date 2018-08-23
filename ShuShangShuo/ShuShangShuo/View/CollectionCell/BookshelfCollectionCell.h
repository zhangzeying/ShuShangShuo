//
//  BookshelfCollectionCell.h
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookInfoModel;

static NSString *const BookshelfCollectionCellLongPressKey = @"BookshelfCollectionCellLongPressKey";
static NSString *const BookshelfCollectionCellCheckBtnClickKey = @"BookshelfCollectionCellCheckBtnClickKey";

@interface BookshelfCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *bookTitle;
@property (nonatomic, strong) UIButton *checkBoxBtn;
@property (nonatomic, strong) BookInfoModel *model;
@property (nonatomic, assign) NSInteger index;

@end

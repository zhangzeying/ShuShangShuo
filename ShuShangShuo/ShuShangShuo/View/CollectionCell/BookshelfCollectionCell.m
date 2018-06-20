//
//  BookshelfCollectionCell.m
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BookshelfCollectionCell.h"

@interface BookshelfCollectionCell ()

@end

@implementation BookshelfCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.bookImageView];
    [self.contentView addSubview:self.bookTitle];
}

- (void)autoLayout {
    [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [_bookTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (UIImageView *)bookImageView {
    if(!_bookImageView) {
        _bookImageView = [[UIImageView alloc]init];
        _bookImageView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    }
    return _bookImageView;
}

- (UILabel *)bookTitle {
    if(!_bookTitle) {
        _bookTitle = [[UILabel alloc]init];
        _bookTitle.textColor = [UIColor whiteColor];
        _bookTitle.font = Font(13);
        _bookTitle.hidden = YES;
    }
    return _bookTitle;
}
@end

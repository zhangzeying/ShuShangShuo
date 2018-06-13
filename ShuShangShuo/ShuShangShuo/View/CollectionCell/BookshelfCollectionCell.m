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
}

- (void)autoLayout {
    [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
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
@end

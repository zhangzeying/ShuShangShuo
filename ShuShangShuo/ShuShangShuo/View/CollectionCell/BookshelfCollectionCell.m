//
//  BookshelfCollectionCell.m
//  ShuShangShuo
//
//  Created by zhangzey on 05/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BookshelfCollectionCell.h"
#import "UIResponder+Router.h"
#import "BookInfoModel.h"

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
    [self.bookImageView addSubview:self.checkBoxBtn];
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 1.0;
    [self.bookImageView addGestureRecognizer:longPressReger];

}

- (void)autoLayout {
    [_bookImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [_bookTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [_checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bookImageView);
        make.right.mas_equalTo(self.bookImageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [self.bookImageView routerEventWithName:BookshelfCollectionCellLongPressKey userInfo:@{@"rowIndex":@(self.index)}];
        
    }
    
}

- (void)checkBoxBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.model.isSelected = sender.selected;
    [sender routerEventWithName:BookshelfCollectionCellCheckBtnClickKey userInfo:@{@"isSelected":@(sender.isSelected)}];
}

- (void)setModel:(BookInfoModel *)model {
    _model = model;
    self.checkBoxBtn.selected = model.isSelected;
}

- (UIImageView *)bookImageView {
    if(!_bookImageView) {
        _bookImageView = [[UIImageView alloc]init];
        _bookImageView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _bookImageView.userInteractionEnabled = YES;
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

- (UIButton *)checkBoxBtn {
    if(!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxBtn setBackgroundImage:IMAGENAMED(@"checkbox_normal") forState:UIControlStateNormal];
        [_checkBoxBtn setBackgroundImage:IMAGENAMED(@"checkbox_selected") forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(checkBoxBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _checkBoxBtn.hidden = YES;
    }
    return _checkBoxBtn;
}

@end

//
//  ToolView.m
//  ShuShangShuo
//
//  Created by zhangzey on 28/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "ToolView.h"
#import "UIResponder+Router.h"

@interface ToolView ()

@end

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.finishBtn];
    [self addSubview:self.deleteBtn];
}

//- (void)checkBtnClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    if ([self.delegate respondsToSelector:@selector(checkAll:)]) {
//        [self.delegate checkAll:sender.selected];
//    }
//}

- (void)finishBtnClick {
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:YES];
    }
}

- (void)deleteBtnClick {
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:NO];
    }
}

- (void)autoLayout {
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (UIButton *)finishBtn {
    if(!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = Font(15);
        [_finishBtn addTarget:self action:@selector(finishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIButton *)deleteBtn {
    if(!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = Font(15);
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end

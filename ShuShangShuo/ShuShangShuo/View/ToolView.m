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
    [self addSubview:self.checkBtn];
    [self addSubview:self.finishBtn];
}

- (void)checkBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(checkAll:)]) {
        [self.delegate checkAll:sender.selected];
    }
}

- (void)finishBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(finish:)]) {
        [self.delegate finish:sender.selected];
    }
}

- (void)autoLayout {
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(60);
    }];
}

- (UIButton *)checkBtn {
    if(!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_checkBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = Font(15);
        [_checkBtn addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (UIButton *)finishBtn {
    if(!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitle:@"删除" forState:UIControlStateSelected];
        [_finishBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = Font(15);
        [_finishBtn addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

@end

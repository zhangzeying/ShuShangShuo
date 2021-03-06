//
//  SettingTableCell.m
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "SettingTableCell.h"

@implementation SettingTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.arrow];
    [self autoLayout];
}

- (void)autoLayout {
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).offset(15);
    }];
    
//    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.titleLbl);
//        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-15);
//    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLbl);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
    }];
    
//    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
//    }];
    
    [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)switchChange:(UISwitch *)sender {
    if (self.indexPath.row == 0) {
        [kUserDefaults setObject:@(sender.isOn) forKey:@"full_screen"];
        [kUserDefaults synchronize];
        
    } else {
        [kUserDefaults setObject:@(sender.isOn) forKey:@"show_page"];
        [kUserDefaults synchronize];
    }
}

#pragma mark - getter and setter
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [self setupUI];
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = Font(14);
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _titleLbl;
}

- (UILabel *)contentLbl {
    if(!_contentLbl) {
        _contentLbl = [[UILabel alloc]init];
        _contentLbl.font = Font(12);
        _contentLbl.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _contentLbl;
}

- (UIView *)line {
    if(!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _line;
}

- (UISwitch *)switchView {
    if(!_switchView) {
        _switchView = [[UISwitch alloc]init];
        _switchView.onTintColor = [UIColor colorWithHexString:@"fb7027"];
        _switchView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
        _switchView.layer.cornerRadius = _switchView.height / 2.0;
        _switchView.layer.masksToBounds = YES;
        [_switchView addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

- (UIImageView *)arrow {
    if(!_arrow) {
        _arrow = [[UIImageView alloc]init];
        _arrow.image = IMAGENAMED(@"arrow_right");
    }
    return _arrow;
}

@end

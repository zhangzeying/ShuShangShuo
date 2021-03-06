//
//  SearchTableCell.m
//  ShuShangShuo
//
//  Created by zhangzey on 21/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "SearchTableCell.h"
#import "BookInfoModel.h"
#import "NSString+HTML.h"

@interface SearchTableCell ()

@property (nonatomic, strong) UIImageView *cover;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *creatorLbl;
@property (nonatomic, strong) UIView *line;

@end

@implementation SearchTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.cover];
    [self.contentView addSubview:self.titleLbl];
    [self.contentView addSubview:self.creatorLbl];
    [self.contentView addSubview:self.line];
    [self autoLayout];
}

- (void)autoLayout {
    [_cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo((ScreenWidth - 10 * 2 - 2 * 20) / 3);
        make.height.equalTo(self.cover.mas_width).multipliedBy(115.0/90);
    }];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cover.mas_right).offset(5);
        make.top.mas_equalTo(self.cover.mas_top).offset(8);
    }];
    
    [_creatorLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cover.mas_right).offset(5);
        make.top.mas_equalTo(self.titleLbl.mas_bottom).offset(5);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

- (NSString *)parserEpubCoverImg:(NSString *)content
{
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:content];
    while (![scanner isAtEnd]) {
        if ([scanner scanString:@"<img>" intoString:NULL]) {
            NSString *img;
            [scanner scanUpToString:@"</img>" intoString:&img];
            img = [img stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            return img;
        } else{
            NSString *content;
            [scanner scanUpToString:@"<img>" intoString:&content];
        }
    }
    return nil;
}

- (void)setModel:(BookInfoModel *)model {
    if (model.coverPath.length > 0) {
        self.cover.image = [UIImage imageWithContentsOfFile:[kDocuments stringByAppendingPathComponent:model.coverPath]];
    } else {
        self.cover.image = [UIImage imageNamed:[NSString stringWithFormat:@"default%ld", (long)arc4random() % 3]];
    }
    
    self.titleLbl.text = model.title;
    self.creatorLbl.text = model.creator;
}

- (UIImageView *)cover {
    if(!_cover) {
        _cover = [[UIImageView alloc]init];
    }
    return _cover;
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.font = Font(15);
        _titleLbl.textColor = [UIColor darkGrayColor];
    }
    return _titleLbl;
}

- (UILabel *)creatorLbl {
    if(!_creatorLbl) {
        _creatorLbl = [[UILabel alloc]init];
        _creatorLbl.font = Font(12);
        _creatorLbl.textColor = [UIColor darkGrayColor];
    }
    return _creatorLbl;
}

- (UIView *)line {
    if(!_line) {
        _line = [[UIView alloc]init];
        _line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _line;
}

@end

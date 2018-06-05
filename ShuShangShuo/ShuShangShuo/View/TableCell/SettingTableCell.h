//
//  SettingTableCell.h
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) NSIndexPath *indexPath;


@end

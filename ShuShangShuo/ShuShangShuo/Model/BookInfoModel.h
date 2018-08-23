//
//  BookInfoModel.h
//  ShuShangShuo
//
//  Created by zhangzey on 21/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookInfoModel : NSObject<NSCoding>

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *creator;
@property (nonatomic,copy) NSString *coverPath;
@property (nonatomic,copy) NSString *fileUrl;
@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger begin_time;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, assign) CGFloat readProgress;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) BOOL isNeedDownLoad;

@end

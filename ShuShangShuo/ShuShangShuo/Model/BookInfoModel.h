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

@end

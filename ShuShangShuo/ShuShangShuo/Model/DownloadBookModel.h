//
//  DownloadBookModel.h
//  ShuShangShuo
//
//  Created by zhangzey on 29/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadBookModel : NSObject

@property (nonatomic, copy) NSString *download_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *img_url;

@end

//
//  LSYReadPageViewController.h
//  LSYReader
//
//  Created by Labanotation on 16/5/30.
//  Copyright © 2016年 okwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSYReadModel.h"
@class BookInfoModel;
@interface LSYReadPageViewController : UIViewController
@property (nonatomic,strong) NSURL *resourceURL;
@property (nonatomic,strong) LSYReadModel *model;
@property (nonatomic, strong) BookInfoModel *bookInfoModel;
//+(void)loadURL:(NSURL *)url;
@end

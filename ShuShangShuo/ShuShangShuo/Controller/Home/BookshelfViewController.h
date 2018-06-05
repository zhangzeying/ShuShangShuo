//
//  BookshelfViewController.h
//  ShuShangShuo
//
//  Created by zhangzey on 04/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, PageStyle) {
    PageStyle_BrowseHistory, //浏览历史
    PageStyle_MyBookshelf //我的书架
};

@interface BookshelfViewController : BaseViewController

@property (nonatomic,assign) PageStyle pageStyle;

@end

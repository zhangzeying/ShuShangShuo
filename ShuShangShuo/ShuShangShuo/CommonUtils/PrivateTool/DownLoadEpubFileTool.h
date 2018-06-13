//
//  DownLoadEpubFileTool.h
//  ShuShangShuo
//
//  Created by zhangzey on 14/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadEpubFileTool : NSObject
SingletonH(tool)

- (void)downloadEpubFile:(NSString *)url;

@end

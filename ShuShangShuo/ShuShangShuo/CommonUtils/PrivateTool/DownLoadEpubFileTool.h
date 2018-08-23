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

- (void)downloadEpubFile:(NSString *)url code:(NSString *)code isContinue:(BOOL)isContinue;
- (BOOL)decodeEpubFile:(NSData *)data fileName:(NSString *)fileName;
- (NSString *)currentWifiSSID;

@end

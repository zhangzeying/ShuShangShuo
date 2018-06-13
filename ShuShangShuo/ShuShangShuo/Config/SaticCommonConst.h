//
//  SaticCommonConst.h
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#ifndef SaticCommonConst_h
#define SaticCommonConst_h

//---- FileName ----
#define kSearchHistoryFileName @"SearchHistoryFileName"

//---- epub file ----
// 缓存主目录
#define HSCachesDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"HSCache"]
// 保存文件名
#define HSFileName(url) url.md5String
// 文件的存放路径（caches）
#define HSFileFullpath(url) [HSCachesDirectory stringByAppendingPathComponent:HSFileName(url)]
// 文件的已下载长度
#define HSDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:HSFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件总长度的文件路径（caches）
#define HSTotalLengthFullpath [HSCachesDirectory stringByAppendingPathComponent:@"totalLength.plist"]

//---- Notification ----
#define LSYNoteNotification @"LSYNoteNotification"
#define LSYThemeNotification @"LSYThemeNotification"
#define LSYEditingNotification @"LSYEditingNotification"
#define LSYEndEditNotification @"LSYEndEditNotification"


#endif /* SaticCommonConst_h */

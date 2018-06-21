//
//  DownLoadEpubFileTool.m
//  ShuShangShuo
//
//  Created by zhangzey on 14/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "DownLoadEpubFileTool.h"
#import "NSString+Hash.h"
#import "NSData+CommonCrypto.h"
#import "AESCipher.h"
#import "HSDownloadManager.h"
#import "BookInfoModel.h"

@implementation DownLoadEpubFileTool
SingletonM(tool)

- (NSString *)getMD5WithData:(NSData *)sourceData {
    
    if (!sourceData) {
        return nil;//判断sourceString如果为空则直接返回nil。
    }
    //需要MD5变量并且初始化
    CC_MD5_CTX  md5;
    CC_MD5_Init(&md5);
    //开始加密(第一个参数：对md5变量去地址，要为该变量指向的内存空间计算好数据，第二个参数：需要计算的源数据，第三个参数：源数据的长度)
    CC_MD5_Update(&md5, sourceData.bytes, (CC_LONG)sourceData.length);
    //声明一个无符号的字符数组，用来盛放转换好的数据
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //将数据放入result数组
    CC_MD5_Final(result, &md5);
    //将result中的字符拼接为OC语言中的字符串，以便我们使用。
    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultString appendFormat:@"%02x",result[i]];
    }
    NSLog(@"resultString=========%@",resultString);
    return  resultString;
    
}

- (int)byteToInt:(Byte *)byte {
    return (int)((byte[0]&0xff) | ((byte[1] << 8)&0xff00) | ((byte[2]<<16)&0xff0000) | ((byte[3]<<24)&0xff000000));
}

- (void)reverse:(Byte [])byte index:(int)index length:(int)length {
    int mid = length / 2;
    mid = mid + index;
    int end = index + length;
    for (int i = 0; i < mid; i++) {
        Byte temp = byte[index + i];
        byte[index + i] = byte[end - i - 1];
        byte[end - i - 1] = temp;
    }
}

- (NSString *)getKey:(NSInteger)index {
    NSArray *keyArr = @[@"dxwFHIGUtWd5wDpz",
                        @"5RwErSelKXKuCTOH",
                        @"X4gvUfHW4Yg95AXm",
                        @"Xph7OXr4CMDtQEej",
                        @"XfCY7koCtS3rsPfG",
                        @"JjBAOTCFTWDD12cN",
                        @"M3qAMiBDeaXtEf7E",
                        @"cdLT2gADcWcWtDoJ",
                        @"TH1glEUDa49y10jF",
                        @"xmwAHIMSBdfHBPQx",
                        @"B5nU7QmMUSCpXcjy",
                        @"VQsZ0OIRLzYc8lkT",
                        @"SWzhTAuhce5llmQL",
                        @"oCsfDUbq5J6otU98",
                        @"qTZWA1F71600TMgb",
                        @"6CeLoHoLao7e2Ddp",
                        @"7DTdIT7ngpjoCbzM",
                        @"KUXHzSQ5Qj1SrsyY",
                        @"w9YQsCOuMw67s2nC",
                        @"YMmnJwJE77LzWetd",
                        @"y6C8NDgElaYnCBoD",
                        @"cg21ifV7wi7lo7Ck",
                        @"Z8VmjA0WuUUzWUAZ",
                        @"LxCqu33kjsN3j9eV",
                        @"4X7OctwRXnN78VpX",
                        @"thXU41QYKypydGeu",
                        @"lSkkyEF4Hszd3wu3",
                        @"jqDNPxcmuf0wOCJI",
                        @"n4xtk8kGf0Es5JDt",
                        @"LPVlaeDC7uZrQ9EO",
                        @"GzEwFrvdKX0jOyBN",
                        @"yOCF5pHMuFNENzQQ",
                        @"FNPlcjyQlt6umnxB",
                        @"fpMv7s8kGowGQCnw",
                        @"G473bUC8bRmV4g45",
                        @"VpcrIxeoDKiAhd4j",
                        @"htyRArAqH5KYmt5w",
                        @"EmU5nZQUO74PlJAB",
                        @"rzSTQzOjTB2LPbsl",
                        @"bBqWkhiIYl8A9Wpp",
                        @"MLjFgP7BRpWxMCUo",
                        @"p4Suf7tuBfrJS5oI",
                        @"uSoywAbdRvm7PESf",
                        @"mUFhQnjVjBEt3HfN",
                        @"IST1jDaJDjRCNFhH",
                        @"0ix4Dg6MhLilFYn3",
                        @"Kk6aE9zgrybn4jgC",
                        @"AouCHJILbLy67CRe",
                        @"FazMW1Omg4y7Pv8P",
                        @"zGweTSIUleKuTEyX",
                        @"paQ0c6rh43Z4bK9T",
                        @"qEp09YW1Zanf2HqM",
                        @"EktNSS9e1IjspBP0",
                        @"uyALQXiFEnXRO2QD",
                        @"cC96tdLEDtkbx6Ef",
                        @"SmgCahQlOtOyw3wQ",
                        @"ke8NmTG4Xpr1OUpV",
                        @"zmGPiarlw9SIaFBW",
                        @"YMSKlDTHcRkZ7i04",
                        @"UeWNshaWWLqtsx5v",
                        @"243pha6caEZNnJRT",
                        @"H8F8Ngs3uOBi7PE6",
                        @"Q0CgXeBCwixCCC0d",
                        @"Ro2W10JaPDWPEhm1",
                        @"6HVtEGJSg1o2uewW",
                        @"Lu2cpWeqnjojs6CT",
                        @"8S4a7OujHhGQSkUs",
                        @"F7ZaGe0rvQ3zmfsU",
                        @"qiEJ0imuiNq5ZjyB",
                        @"nxoNlHYyqOKS7DZZ",
                        @"94NIuC0AmmG4neOM",
                        @"gF2nchAJuf7CppL8",
                        @"dAycoLeKVvHJVPPB",
                        @"05nT5L0t85iji9gI",
                        @"EKBi2OoAs8yOj3IP",
                        @"LkoGW4mQGXa3PbMo",
                        @"Q3IKNBe7wQXkYacD",
                        @"65WY11CoURNBF3hw",
                        @"jfN5TS9Nr9BTtJOF",
                        @"MTdaEeA63at0VpU6",
                        @"M7ynPzCzD92Ku8Kr",
                        @"sILH6q1FKAtVUo99",
                        @"75yQsa2CPu5mlyK0",
                        @"XvUh3R9ODpPUMq4R",
                        @"5rYRJXgrEMtkJGFS",
                        @"ZccSexIml9kAZMPw",
                        @"FRTdiDEtjnGhtzgu",
                        @"M8xrTBQ8faKB9kVV",
                        @"kJdglZoS6fx1A4Zc",
                        @"wWPXNaZl29L0HpxO",
                        @"zIwbtlX8GT0S9xmd",
                        @"KlkqHnNoBhlmS896",
                        @"5vutkWsHrSLlRq5s",
                        @"QOzPIa03Tkv5NcUN",
                        @"N2hS0FqrF5u7qYdi",
                        @"dqlvYvcw1ccH8Mtw",
                        @"elD4paBXpwOfC7mN",
                        @"kN2tnMWgSA05Uaor",
                        @"qtOtrZyCLjboxOCu",
                        @"ujo4lsNmJLKuF3rJ"
                        ];
    return keyArr[index];
}

- (BOOL)decodeEpubFile:(NSData *)data fileName:(NSString *)fileName {
    
    Byte flagByte[8];
    [data getBytes:flagByte length:8];
    NSString *flag = [[NSString alloc] initWithBytes:flagByte length:8 encoding:NSUTF8StringEncoding];
    if (![flag hasPrefix:@"5cbk"]) {
        NSLog(@"不是5cbk格式");
        return NO;
    }
    
    Byte keyIndexByte[4];
    [data getBytes:keyIndexByte range:NSMakeRange(8, 4)];
    int keyindex = [self byteToInt:keyIndexByte];
    NSString *key = [self getKey:keyindex];
    
    
    Byte md5Byte[16];
    [data getBytes:md5Byte range:NSMakeRange(12, 16)];
    NSString *md5 = [[NSString alloc] initWithBytes:md5Byte length:16 encoding:NSUTF8StringEncoding];
    
    Byte lenthByte[4];
    [data getBytes:lenthByte range:NSMakeRange(28, 4)];
    int lenth = [self byteToInt:lenthByte];
    
    Byte *org_content = (Byte *)malloc(lenth);
    [data getBytes:org_content range:NSMakeRange(32, lenth)];
    NSData *org_data = [[NSData alloc] initWithBytes:org_content length:lenth];
    
    NSString *org_md5 = [self getMD5WithData:org_data];
    NSString *org_sub_md5 = [org_md5 substringWithRange:NSMakeRange(8, 16)];
    if (![org_sub_md5 isEqualToString:md5]) {
        NSLog(@"文件损坏");
        return NO;
    }
    
    NSData *decryptedData = aesDecryptString(org_data, key);
    Byte *rByte = (Byte *)malloc(decryptedData.length);
    
    [decryptedData getBytes:rByte length:decryptedData.length];
    [self reverse:rByte index:0 length:100];
    
    NSData *src_data = [[NSData alloc] initWithBytes:rByte length:decryptedData.length];
    
    BOOL writeFlag = [src_data writeToFile:[HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",fileName]] atomically:YES];
    
    return writeFlag;
}

- (void)downloadEpubFile:(NSString *)url {
    if (([url hasPrefix:@"http"] || [url hasPrefix:@"https"]) && [url containsString:@"/5cepub/appdownload"]) {
        __block NSMutableArray *downloadUrlArr = [NSMutableArray arrayWithContentsOfFile:kDownloadUrlFilePath];
        if ([downloadUrlArr containsObject:HSFileName(url)]) {
            WEAKSELF
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"此书籍已下载过，是否重新下载？"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      STRONGSELF
                                                                      [[HSDownloadManager sharedInstance] deleteFile:url];
                                                                      [downloadUrlArr removeObject:HSFileName(url)];
                                                                      [downloadUrlArr writeToFile:kDownloadUrlFilePath atomically:YES];
                                                                      [strongSelf downloadEpubFile:url];
                                                                  }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action) {
                                                                 }];
            
            [alert addAction:defaultAction];
            [alert addAction:cancelAction];
            [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            return;
        }
        [kUserDefaults setObject:url forKey:@"current_download_url"];
        [kUserDefaults synchronize];
        [[HSDownloadManager sharedInstance] download:url progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SProgressHUD showProgressValue:progress title:@"正在下载..."];
            });
        } state:^(DownloadState state) {
            if (state == DownloadStateStart) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SProgressHUD showProgressValue:0.f title:@"正在下载..."];
                });
                
            } else if (state == DownloadStateCompleted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SProgressHUD hideHUDfromView:nil];
                    [SProgressHUD showWaiting:@"下载成功，正在解析..."];
                });
                [kUserDefaults removeObjectForKey:@"current_download_url"];
                [kUserDefaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString *filePath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@",HSFileName(url)]];
                    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                    BOOL flag = [self decodeEpubFile:fileData fileName:HSFileName(url)];
                    if (flag) {
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            NSString *fullPath = [HSCachesDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.epub",HSFileName(url)]];
                            NSURL *fileURL = [NSURL URLWithString:fullPath];
                            if ([fileURL.pathExtension isEqualToString:@"epub"]) {
                                NSString *zipFile = [LSYReadUtilites unZip:fullPath];
                                if (zipFile.length > 0) {
                                    NSString *OPFPath = [LSYReadUtilites OPFPath:zipFile];
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[LSYReadUtilites parseEpubInfo:OPFPath]];
                                    NSString *str = [NSString stringWithFormat:@"%@/%@", [OPFPath stringByDeletingLastPathComponent],[dict objectForKey:@"coverHtmlPath"]];
                                    BookInfoModel *model = [[BookInfoModel alloc]init];
                                    model.title = [dict objectForKey:@"title"];
                                    model.creator = [dict objectForKey:@"creator"];
                                    model.coverPath = str;
                                    model.fileUrl = HSFileName(url);
                                    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:kMyBookshelfFilePath];
                                    if (!dataArr) {
                                        dataArr = [NSMutableArray arrayWithObjects:model, nil];
                                        
                                    } else {
                                        [dataArr addObject:model];
                                    }
                                    
                                    if (!downloadUrlArr) {
                                        downloadUrlArr = [NSMutableArray arrayWithObjects:HSFileName(url), nil];
                                        
                                    } else {
                                        [downloadUrlArr addObject:HSFileName(url)];
                                    }
                                    if ([NSKeyedArchiver archiveRootObject:dataArr toFile:kMyBookshelfFilePath] && [downloadUrlArr writeToFile:kDownloadUrlFilePath atomically:YES]) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [SProgressHUD hideHUDfromView:nil];
                                            [SProgressHUD showSuccess:@"解析成功"];
                                            NSString *key = [fileURL.path lastPathComponent];
                                            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                                            [[HSDownloadManager sharedInstance] deleteFile:url];
                                            NOTIF_POST(DownloadSucces, nil);
                                        });
                                        
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [SProgressHUD hideHUDfromView:nil];
                                            [SProgressHUD showFailure:@"解析出错，请重新下载"];
                                            [[HSDownloadManager sharedInstance] deleteFile:url];
                                        });
                                    }
                                }
                                
                            }
                        });
                        
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [SProgressHUD hideHUDfromView:nil];
                            [[HSDownloadManager sharedInstance] deleteFile:url];
                            [SProgressHUD showFailure:@"解析出错，请重新下载"];
                        });
                    }
                    
                });
                
            } else if (state == DownloadStateFailed)  {
                [kUserDefaults removeObjectForKey:@"current_download_url"];
                [kUserDefaults synchronize];
                [[HSDownloadManager sharedInstance] deleteFile:url];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SProgressHUD hideHUDfromView:nil];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                   message:@"请连接本机WiFi，默认Wi-Fi名称5csss和默认密码12345678"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"去设置网络" style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                                          }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction * action) {
                                                                         }];
                    
                    [alert addAction:defaultAction];
                    [alert addAction:cancelAction];
                    [kWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                });
                
            }
        }];
    }
}

- (void)test {
//    NSString *zipFile = [[fullPath stringByDeletingPathExtension] lastPathComponent];

}

@end

//
//  AppDelegate.m
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import <Bugly/Bugly.h>
#import "AFNetworking.h"
#import "BookInfoModel.h"

@interface AppDelegate ()

@property (nonatomic, assign) NSInteger appBeginTime;
@property (nonatomic, copy) NSString *serviceVesion;
@property (nonatomic, assign) BOOL isForce;
@property (nonatomic, copy) NSString *updateContent;
@property (nonatomic, copy) NSString *title;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    RootTabBarController *rootVC = [[RootTabBarController alloc]init];
    self.window.rootViewController = rootVC;
    [Bugly startWithAppId:@"5b45d23945"];
    [self.window makeKeyAndVisible];
    [self checkVerisonRequest];
    if (![kUserDefaults boolForKey:@"ShowActivationCode"]) {
        [self checkShowActivationCode];
    }
    return YES;
}

- (void)checkVerisonRequest {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSDictionary *params = @{@"type":@(1)};
    WEAKSELF
    [manager POST:@"http://wx.5csss.com/booklist/index/version" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        STRONGSELF
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSDictionary *dict = [responseObject objectForKey:@"msg"];
            strongSelf.isForce = [[dict objectForKey:@"is_force"] boolValue];
            strongSelf.updateContent = [dict objectForKey:@"update_content"];
            strongSelf.serviceVesion = [dict objectForKey:@"version"];
            strongSelf.title = [NSString stringWithFormat:@"%@版本更新", strongSelf.serviceVesion];
            if ([strongSelf.serviceVesion compare:KCurrentVersion options:NSNumericSearch] == NSOrderedDescending) {
                [strongSelf showAlert:strongSelf.title content:strongSelf.updateContent isForce:strongSelf.isForce];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)checkShowActivationCode {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 15.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSDictionary *params = @{@"type":@(1)};
    [manager POST:@"http://wx.5csss.com/booklist/index/is_display" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            BOOL isShowActivationCode = [[responseObject objectForKey:@"msg"] boolValue];
            if (isShowActivationCode) {
                [kUserDefaults setBool:YES forKey:@"ShowActivationCode"];
                [kUserDefaults synchronize];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)showAlert:(NSString *)title content:(NSString *)content isForce:(BOOL)isForce {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1402465221?mt=8";
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }];
    if (!isForce) {
        [actionSheet addAction:action1];
    }
    [actionSheet addAction:action2];
    [self.window.rootViewController presentViewController:actionSheet animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (BookInfoModel *model in self.staticsBookArr) {
        NSDictionary *dict = @{@"title":model.title?:@"",
                               @"begin_time":[NSString stringWithFormat:@"%ld",(long)model.begin_time]?:@"",
                               @"end_time":[NSString stringWithFormat:@"%ld",(long)model.end_time]?:@"",
                               @"code":model.code?:@"",
                               @"app_begin_time":@(self.appBeginTime),
                               @"app_close_time":@((NSInteger)floor([[NSDate date] timeIntervalSince1970])),
                               @"progress":@(model.readProgress)
                               };
        [arr addObject:dict];
    }
    if (arr.count > 0) {
        [self.staticsBookArr removeAllObjects];
        NSData *data = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                         error:nil];
        NSString *jsonStr;
        if (data != nil) {
            jsonStr = [[NSString alloc] initWithData:data
                                            encoding:NSUTF8StringEncoding];
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 15.f;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
        NSDictionary *params = @{@"data":jsonStr?:@""};
        [manager POST:@"http://wx.5csss.com/booklist/index/read" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if (self.isForce) {
        if ([self.serviceVesion compare:KCurrentVersion options:NSNumericSearch] == NSOrderedDescending) {
            [self showAlert:self.title content:self.updateContent isForce:self.isForce];
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.appBeginTime = (NSInteger)floor([[NSDate date] timeIntervalSince1970]);
}


- (void)applicationWillTerminate:(UIApplication *)application {

}

@end

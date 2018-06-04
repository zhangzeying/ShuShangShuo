//
//  UIResponder+Router.m
//  ShuShangShuo
//
//  Created by zhangzey on 03/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([self nextResponder]) {
        [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
    }
}

@end

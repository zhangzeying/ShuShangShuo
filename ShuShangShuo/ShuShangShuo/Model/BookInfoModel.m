//
//  BookInfoModel.m
//  ShuShangShuo
//
//  Created by zhangzey on 21/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "BookInfoModel.h"

@implementation BookInfoModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.creator forKey:@"creator"];
    [aCoder encodeObject:self.coverPath forKey:@"coverPath"];
    [aCoder encodeObject:self.fileUrl forKey:@"fileUrl"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.creator = [aDecoder decodeObjectForKey:@"creator"];
        self.coverPath = [aDecoder decodeObjectForKey:@"coverPath"];
        self.fileUrl = [aDecoder decodeObjectForKey:@"fileUrl"];
    }
    return self;
}

@end

//
//  SVerticalButton.m
//  ShuShangShuo
//
//  Created by zhangzey on 08/06/2018.
//  Copyright © 2018 lanmao. All rights reserved.
//

#import "SVerticalButton.h"

@implementation SVerticalButton

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat midX = self.frame.size.width / 2;
    CGFloat midY = self.frame.size.height/ 2 ;
    self.titleLabel.center = CGPointMake(midX, midY + self.centerOffset);
    self.imageView.center = CGPointMake(midX, midY - 10);
}

- (void)setCenterOffset:(CGFloat)centerOffset {
    
    _centerOffset = centerOffset;
    [self setNeedsLayout];
}
@end

//
//  PaddedButton.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "PaddedButton.h"

@implementation PaddedButton

- (instancetype)init{
    self = [super init];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}
- (void)awakeFromNib{
    [self setup];
}

- (void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets{
    [super setTitleEdgeInsets:titleEdgeInsets];
}
- (void)setup{
    self.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    self.titleEdgeInsets = UIEdgeInsetsMake(4, 20, 4, 20);
    self.layer.cornerRadius = 4.0;
}
- (CGSize) intrinsicContentSize {
    CGSize s = [super intrinsicContentSize];
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
    
}

@end

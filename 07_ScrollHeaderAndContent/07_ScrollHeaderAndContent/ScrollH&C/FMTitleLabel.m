//
//  FMTitleLabel.m
//  05_DIYUI
//
//  Created by Windy on 2017/2/21.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMTitleLabel.h"

static const CGFloat XMGRed = 0.4;
static const CGFloat XMGGreen = 0.6;
static const CGFloat XMGBlue = 0.7;

@implementation FMTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textColor = [UIColor colorWithRed:XMGRed green:XMGGreen blue:XMGBlue alpha:1.0];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setFm_scale:(CGFloat)fm_scale {
    _fm_scale = fm_scale;
    CGFloat red = XMGRed + (1 - XMGRed) * fm_scale;
    CGFloat green = XMGGreen + (0 - XMGGreen) * fm_scale;
    CGFloat blue = XMGBlue + (0 - XMGBlue) * fm_scale;
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    CGFloat transformScale = 1 + fm_scale * 0.3;
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end

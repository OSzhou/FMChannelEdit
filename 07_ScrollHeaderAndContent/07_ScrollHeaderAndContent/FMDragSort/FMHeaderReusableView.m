//
//  FMHeaderReusableView.m
//  DraggingSort
//
//  Created by Windy on 2017/3/21.
//  Copyright © 2017年 YL. All rights reserved.
//

#import "FMHeaderReusableView.h"

@interface FMHeaderReusableView ()

@property (nonatomic, strong) UILabel *headerLabel;

@end

@implementation FMHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
        _headerLabel.text = @"频道推荐";
        _headerLabel.textColor = RGBColorMake(110, 110, 110, 1);
        _headerLabel.font = kFont(13);
        _headerLabel.backgroundColor = [UIColor clearColor];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_headerLabel.frame), SCREEN_WIDTH - 20, kLineHeight)];
        bottomLine.backgroundColor = RGBColorMake(110, 110, 110, 1);
        [self addSubview:bottomLine];
        [self addSubview:_headerLabel];
    }
    return self;
}

@end

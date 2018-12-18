
//
//  FMPhotoEditItem.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "FMPhotoEditItem.h"
#import "Masonry.h"

@interface FMPhotoEditItem () <UIGestureRecognizerDelegate>

@end
static const CGFloat margin = 5.f;
@implementation FMPhotoEditItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    
    [self addGestureRecognizer:longPress];
    /*
     UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
     [self addGestureRecognizer:pan];
     */
    [self addSubview:self.shadowView];
    [self addSubview: self.contentImageView];
    [self addSubview:self.maskImageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [UIView animateWithDuration:.25 animations:^{
        _contentImageView.frame = CGRectMake(margin, margin, self.width - 2 * margin, self.height - 2 * margin);
        _shadowView.frame = self.bounds;
        _maskImageView.frame = self.bounds;
    }];
    
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoItem:tapGesture:)]) {
        [self.delegate photoItem:self tapGesture:gesture];
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoItem:longPressGesture:)]) {
        [self.delegate photoItem:self longPressGesture:gesture];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoItem:longPressGestureShouldBegin:)]) {
        return [self.delegate photoItem:self longPressGestureShouldBegin:(UILongPressGestureRecognizer *)gestureRecognizer];
    }
    
    return YES;
}


/*
 - (void)panGesture:(UIPanGestureRecognizer *)gesture {
 if (self.delegate && [self.delegate respondsToSelector:@selector(photoItem:panGesture:)]) {
 [self.delegate photoItem:self panGesture:gesture];
 }
 }
 */

- (UIImageView *)maskImageView{
    
    if (!_maskImageView) {
        
        UIImageView *imageView = [UIImageView new];
        //        imageView.layer.cornerRadius = 4.5;
        imageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        imageView.hidden = YES;
        _maskImageView = imageView;
        
    }
    
    return _maskImageView;
}

- (UIView *)shadowView{
    
    if (!_shadowView) {
        
        UIView *view = [UIView new];
        
        view.layer.cornerRadius = 4.5;
        view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowOpacity = 0.25;
        view.layer.shadowRadius = 4.5;
        view.layer.shadowOffset = CGSizeMake(0,5);
        view.hidden = YES;
        _shadowView = view;
        
    }
    
    return _shadowView;
}

// 注意更换为：YYAnimatedImageView
- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _contentImageView.backgroundColor = [UIColor colorWithRed:(arc4random() % 255) / 255.0 green:(arc4random() % 255) / 255.0 blue:(arc4random() % 255) / 255.0 alpha:1.0];
        _contentImageView.layer.cornerRadius = 4.5;
        _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _contentImageView.image = [UIImage imageNamed:@"finsh-1"];
        _contentImageView.clipsToBounds = YES;
    }
    return _contentImageView;
}

@end

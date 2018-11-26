//
//  FMPhotoEditItem.h
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMPhotoEditItem;
@protocol FMPhotoEditItemDelegate <NSObject>

@required
/// 点击事件
- (void)photoItem:(FMPhotoEditItem *)photoItem tapGesture:(UITapGestureRecognizer *)gesture;

/// 点击长按事件
- (void)photoItem:(FMPhotoEditItem *)photoItem longPressGesture:(UILongPressGestureRecognizer *)gesture;
/*
 /// 点击拖拽事件(无编辑按钮时 - 用不到 - )
 - (void)photoItem:(FMPhotoEditItem *)photoItem panGesture:(UIPanGestureRecognizer *)gesture;
 */
@end

@interface FMPhotoEditItem : UIView
@property (nonatomic, strong) UIImageView *contentImageView;
//@property (nonatomic, strong) UILabel *contentLabel;
//@property (nonatomic, strong) UIImageView *closeImageView;
//// 拖拽
//@property (nonatomic, strong) UIPanGestureRecognizer *pan;
//// 点击
//@property (nonatomic, strong) UITapGestureRecognizer *tap;
//// 长按
//@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, weak) id <FMPhotoEditItemDelegate> delegate;
// 是不是第一张的大图
@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, assign) BOOL isPlaceHolder;
// 遮罩
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UIView *shadowView;
//-(void)inOrOutTouching:(BOOL)inOrOut;

@end

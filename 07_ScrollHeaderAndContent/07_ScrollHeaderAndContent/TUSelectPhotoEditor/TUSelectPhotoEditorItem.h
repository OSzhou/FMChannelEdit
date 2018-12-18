//
//  TUSelectPhotoEditorItem.h
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/22.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUSelectPhotoEditorItem;
@protocol TUSelectPhotoEditorItemDelegate <NSObject>

@required
/// 点击事件
- (void)photoItem:(TUSelectPhotoEditorItem *)photoItem tapGesture:(UITapGestureRecognizer *)gesture;

/// 拖拽事件
- (void)photoItem:(TUSelectPhotoEditorItem *)photoItem panGesture:(UIPanGestureRecognizer *)gesture;

/// 是否开始该手势
- (BOOL)photoItem:(TUSelectPhotoEditorItem *)photoItem panGestureShouldBegin:(UIPanGestureRecognizer *)gesture;

@end

@interface TUSelectPhotoEditorItem : UIView

// 是不是第一张的大图
@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, assign) BOOL isPlaceHolder;
@property (nonatomic, strong) UIImageView *contentImageView;
// 遮罩
@property (nonatomic, strong) UIImageView *maskImageView;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, weak) id <TUSelectPhotoEditorItemDelegate> delegate;



@end

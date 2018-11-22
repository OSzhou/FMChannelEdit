//
//  FMPhotoEditView.h
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMPhotoEditView;
@class FMPhotoEditItem;
@protocol FMPhotoEditViewDelegate <NSObject>
@required
/// 图片点击手势
- (void)photoEditView:(FMPhotoEditView *)photoEditView item:(FMPhotoEditItem *)item itemAtIndex:(NSInteger)index;

/// 图片长按开始
- (void)photoEditView:(FMPhotoEditView *)photoEditView longPressBeginWithItem:(FMPhotoEditItem *)item;
/// 图片长按移动
- (void)photoEditView:(FMPhotoEditView *)photoEditView longPressStateChangedWithItem:(FMPhotoEditItem *)item;
/// 图片长按结束
- (void)photoEditView:(FMPhotoEditView *)photoEditView longPressEndWithItem:(FMPhotoEditItem *)item atIndex:(NSInteger)index;
/// 图片长按取消或失败
- (void)photoEditView:(FMPhotoEditView *)photoEditView longPressCancelOrFailWithItem:(FMPhotoEditItem *)item;

/// 添加图片按钮点击事件
- (void)photoEditView:(FMPhotoEditView *)photoEditView addButton:(UIButton *)addButton;

@end
@interface FMPhotoEditView : UIView

@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, weak) id <FMPhotoEditViewDelegate> delegate;

- (void)deleteWith:(FMPhotoEditItem *)item;

@end

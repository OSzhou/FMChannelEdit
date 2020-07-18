//
//  TUSelectPhotoEditorView.h
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/22.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TUSelectPhotoEditorView;
@class TUSelectPhotoEditorItem;
@protocol TUSelectPhotoEditorViewDelegate <NSObject>
@required
/// 图片点击手势
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView item:(TUSelectPhotoEditorItem *)item itemAtIndex:(NSInteger)index;

/// 图片拖拽开始
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panBeginWithItem:(TUSelectPhotoEditorItem *)item;
/// 图片拖拽移动
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panStateChangedWithItem:(TUSelectPhotoEditorItem *)item;
/// 图片拖拽结束 - 并返回删除结果
- (BOOL)photoEditView:(TUSelectPhotoEditorView *)photoEditView panEndWithItem:(TUSelectPhotoEditorItem *)item atIndex:(NSInteger)index;
/// 图片拖拽取消或失败
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panCancelOrFailWithItem:(TUSelectPhotoEditorItem *)item;

/// 添加图片按钮点击事件
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView addButton:(UIButton *)addButton;

@end
@interface TUSelectPhotoEditorView : UIView

@property (nonatomic, strong) NSMutableArray *photosArr;
@property (nonatomic, weak) id <TUSelectPhotoEditorViewDelegate> delegate;

@end

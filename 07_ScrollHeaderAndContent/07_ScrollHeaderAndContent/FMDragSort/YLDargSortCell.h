//
//   YLDargSortCell.h
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMDragSortModel;
@protocol SKDragSortDelegate <NSObject>
//拖拽排序
- (void)YLDargSortCellGestureAction:(UIGestureRecognizer *)gestureRecognizer;
//点击删除按钮
- (void)YLDargSortCellCancelSubscribe:(NSString *)subscribe;

@end

@interface YLDargSortCell : UICollectionViewCell
@property (nonatomic, weak) FMDragSortModel *dataModel;
@property (nonatomic,weak) id<SKDragSortDelegate> delegate;

- (void)showDeleteBtn;
@end

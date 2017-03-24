//
//  FMDragSortModel.h
//  DraggingSort
//
//  Created by Windy on 2017/3/23.
//  Copyright © 2017年 YL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDragSortModel : NSObject
/// 按钮名称
@property (nonatomic, copy) NSString *title;
/// 上部 or 下部
@property (nonatomic, assign) BOOL isTop;
@end

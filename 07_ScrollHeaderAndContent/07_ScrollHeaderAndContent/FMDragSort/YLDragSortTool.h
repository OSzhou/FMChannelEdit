//
//   YLDragSortTool.h
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDragSortModel.h"

@interface YLDragSortTool : NSObject
@property (nonatomic,assign) BOOL isEditing;//记录是否是编辑状态
/** 上部数据源 */
@property (nonatomic, strong) NSMutableArray<FMDragSortModel *> *topChannelArr;
/** 下部数据源 */
@property (nonatomic, strong) NSMutableArray<FMDragSortModel *> *bottomChannelArr;

+ (instancetype)shareInstance;
@end

//
//  SKDragSortTool.m
//   
//
//  Created by HelloYeah on 2016/11/30.
//  Copyright © 2016年 YeLiang. All rights reserved.
//

#import "YLDragSortTool.h"

@interface YLDragSortTool ()

@property (nonatomic,strong) NSMutableArray * subscribeArray;
@property (nonatomic, strong) NSMutableArray *recommendArray;

@end

@implementation YLDragSortTool
static YLDragSortTool *DragSortTool = nil;

+ (instancetype)shareInstance
{
    @synchronized (self) {
        if (DragSortTool == nil) {
            DragSortTool = [[self alloc] init];
        }
    }
    
    return DragSortTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized (self) {
        if (DragSortTool == nil) {
            DragSortTool = [super allocWithZone:zone];
        }
    }
    return DragSortTool;
}

- (id)copy
{
    return DragSortTool;
}

- (id)mutableCopy{
    return DragSortTool;
}

#pragma mark --- lazyLaoding
-(NSMutableArray<FMDragSortModel *> *)topChannelArr{
    if (!_topChannelArr) {
        NSArray *subscribleArr = @[@"推荐",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女"];
        _topChannelArr = [NSMutableArray array];
        for (int i = 0; i < subscribleArr.count; ++i) {
            FMDragSortModel *channelModel = [[FMDragSortModel alloc] init];
            channelModel.title = subscribleArr[i];
            channelModel.isTop = YES;
            [_topChannelArr addObject:channelModel];
        }
    }
    return _topChannelArr;
}
-(NSMutableArray<FMDragSortModel *> *)bottomChannelArr{
    if (!_bottomChannelArr) {
        NSArray *recommendArr = @[@"数码",@"文化",@"美文",@"星座",@"旅游",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码"];
        _bottomChannelArr = [NSMutableArray array];
        for (int i = 0; i < recommendArr.count; ++i) {
            FMDragSortModel *channelModel = [[FMDragSortModel alloc] init];
            channelModel.title = recommendArr[i];
            channelModel.isTop = NO;
            [_bottomChannelArr addObject:channelModel];
        }
    }
    return _bottomChannelArr;
}

- (NSMutableArray *)subscribeArray {
    if (!_subscribeArray) {
        _subscribeArray = [@[@"推荐",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码",@"文化",@"美文",@"星座",@"旅游",@"视频",@"军事",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女"] mutableCopy];
    }
    return _subscribeArray;
}

- (NSMutableArray *)recommendArray {
    if (!_recommendArray) {
        _recommendArray = [@[@"数码",@"文化",@"美文",@"星座",@"旅游",@"娱乐",@"问答",@"娱乐",@"汽车",@"段子",@"趣图",@"财经",@"热点",@"房产",@"社会",@"数码",@"美女",@"数码"] mutableCopy];
    }
    return _recommendArray;
}

@end

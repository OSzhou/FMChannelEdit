//
//  FMBasicViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/2/22.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMBasicViewController.h"
#import "FMTitleLabel.h"
#import "PopoverView.h"
#import "LRLChannelEditController.h"
#import "ChannelUnitModel.h"
#import "YLDragSortViewController.h"

@interface FMBasicViewController () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger childVCCount;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, strong) UIButton *sortBtn;
/** 上部数据源 */
@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *topChannelArr;
/** 下部数据源 */
@property (nonatomic, strong) NSMutableArray<ChannelUnitModel *> *bottomChannelArr;
/** 选中的按钮的索引 */
@property (nonatomic, assign) NSInteger chooseIndex;


@end

@implementation FMBasicViewController

- (instancetype)init {
    if (self = [super init]) {
        self.middleMargin = 80.f;
        self.fontSize = 20.f;
        self.isScale = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupChildVC];
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.contentScrollView];
    [self.view addSubview:self.sortBtn];
    [self setupTitle];
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}

- (void)setupChildVC {
    for (int i = 0; i < _childVCCount; i ++) {
        UIViewController *vc = [[NSClassFromString(self.controllerClassArr[i]) alloc] init];
        if (self.controllerTitleArr.count) {
            vc.title = self.controllerTitleArr[i];
        }
        [self addChildViewController:vc];
    }
}

- (void)setupTitle {
    // 底部的红色指示器
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleScrollView.frame.size.height - 2, 0, 2)];
    indicatorView.backgroundColor = [UIColor redColor];
    self.indicatorView = indicatorView;

    // 定义临时变量
    CGFloat labelH = self.titleScrollView.frame.size.height;
    CGFloat labelX = 0;
    
    // 添加label
    for (NSInteger i = 0; i < _childVCCount; i++) {
        FMTitleLabel *label = [[FMTitleLabel alloc] init];
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.text = [self.childViewControllers[i] title];
        CGRect frame = label.frame;
        frame.origin.x = labelX + self.middleMargin;
        frame.origin.y = (labelH - self.fontSize) / 2;
        label.frame = frame;
        [label sizeToFit];
        labelX += label.frame.size.width + self.middleMargin;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.tag = i;
        [self.titleScrollView addSubview:label];
        if (i == 0) { // 最前面的label
            label.fm_scale = _isScale ? 1.0 : 0.0;
            CGRect lineFrame = self.indicatorView.frame;
            lineFrame.size.width = label.frame.size.width;
            self.indicatorView.frame = lineFrame;
            CGPoint center = self.indicatorView.center;
            center.x = label.center.x;
            self.indicatorView.center = center;
        }
    }
    [self.titleScrollView addSubview:indicatorView];
    
    // 设置contentSize
    self.titleScrollView.contentSize = CGSizeMake(labelX + self.middleMargin, 0);
    self.contentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * _childVCCount, 0);
}

- (void)labelClick:(UITapGestureRecognizer *)tap {
    // 取出被点击label的索引
    NSInteger index = tap.view.tag;
    // 让底部的内容scrollView滚动到对应位置
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark --- contentScrollView Delegate
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 一些临时变量
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    // 让对应的顶部标题居中显示
    FMTitleLabel *label = self.titleScrollView.subviews[index];//当前正在显示的label
    
    [UIView animateWithDuration:0.25 animations:^{
        //指示条宽度跟这变化
        CGRect lineFrame = self.indicatorView.frame;
        lineFrame.size.width = label.frame.size.width;
        self.indicatorView.frame = lineFrame;
        //指示条跟着动
        CGPoint center = self.indicatorView.center;
        center.x = label.center.x;
        self.indicatorView.center = center;
    }];
    
    CGPoint titleOffset = self.titleScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.titleScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titleScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (FMTitleLabel *otherLabel in self.titleScrollView.subviews) {
        if (otherLabel != label && [otherLabel isKindOfClass:[FMTitleLabel class]]) otherLabel.fm_scale = 0.0;
    }
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    if ([willShowVc isViewLoaded]) return;
    
    // 添加控制器的view到contentScrollView中;
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;//float类型
    if (scale < 0 || scale > self.titleScrollView.subviews.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;//整型
    FMTitleLabel *leftLabel = self.titleScrollView.subviews[leftIndex];
    if (![leftLabel isKindOfClass:[FMTitleLabel class]]) return;
    // 获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    FMTitleLabel *rightLabel = (rightIndex == self.titleScrollView.subviews.count) ? nil : self.titleScrollView.subviews[rightIndex];
    if (![rightLabel isKindOfClass:[FMTitleLabel class]]) return;
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    leftLabel.fm_scale = _isScale ? leftScale : 0.0;
    rightLabel.fm_scale = _isScale ? rightScale : 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- lazy Loading

- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
        _titleScrollView.backgroundColor = [UIColor cyanColor];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
        _contentScrollView.backgroundColor = [UIColor lightGrayColor];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
    }
    return _contentScrollView;
}

- (UIButton *)sortBtn {
    if (!_sortBtn) {
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sortBtn.frame = CGRectMake(self.view.frame.size.width - 60, 20, 60, 44);
        _sortBtn.backgroundColor = [UIColor purpleColor];
        [_sortBtn setTitle:@"点" forState:UIControlStateNormal];
        [_sortBtn addTarget:self action:@selector(toSortView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sortBtn;
}


- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
}

- (void)setMiddleMargin:(CGFloat)middleMargin {
    _middleMargin = middleMargin;
}

- (void)setControllerClassArr:(NSArray *)controllerClassArr {
    _controllerClassArr = controllerClassArr;
    _childVCCount = controllerClassArr.count;
}
/************************************我是分割线************************************/

- (void)toSortView:(UIButton *)sender {
    PopoverView *popoverView = [PopoverView new];
    popoverView.menuTitles   = @[@"方式一：自定义按钮", @"方式二：用UICollectionView"];
    __weak __typeof(&*self)weakSelf = self;
    [popoverView showFromView:sender selected:^(NSInteger index) {
        if (!index) {
            LRLChannelEditController *channelEdit = [[LRLChannelEditController alloc] initWithTopDataSource:self.topChannelArr andBottomDataSource:self.bottomChannelArr andInitialIndex:self.chooseIndex];
            
            //编辑后的回调
            channelEdit.removeInitialIndexBlock = ^(NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr){
                weakSelf.topChannelArr = topArr;
                weakSelf.bottomChannelArr = bottomArr;
                NSLog(@"删除了初始选中项的回调:\n保留的频道有: %@", topArr);
            };
            channelEdit.chooseIndexBlock = ^(NSInteger index, NSMutableArray<ChannelUnitModel *> *topArr, NSMutableArray<ChannelUnitModel *> *bottomArr){
                weakSelf.topChannelArr = topArr;
                weakSelf.bottomChannelArr = bottomArr;
                weakSelf.chooseIndex = index;
                NSLog(@"选中了某一项的回调:\n保留的频道有: %@, 选中第%ld个频道", topArr, index);
            };
            
            channelEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:channelEdit animated:YES completion:nil];
        } else {
            YLDragSortViewController *vc = [[YLDragSortViewController alloc] init];
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }
    }];
}

-(NSMutableArray<ChannelUnitModel *> *)topChannelArr{
    if (!_topChannelArr) {
        //这里模拟从本地获取的频道数组
        _topChannelArr = [NSMutableArray array];
        for (int i = 0; i < 50; ++i) {
            ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
            channelModel.name = [NSString stringWithFormat:@"标题%d", i];
            channelModel.cid = [NSString stringWithFormat:@"%d", i];
            channelModel.isTop = YES;
            [_topChannelArr addObject:channelModel];
        }
    }
    return _topChannelArr;
}
-(NSMutableArray<ChannelUnitModel *> *)bottomChannelArr{
    if (!_bottomChannelArr) {
        _bottomChannelArr = [NSMutableArray array];
        for (int i = 30; i < 50; ++i) {
            ChannelUnitModel *channelModel = [[ChannelUnitModel alloc] init];
            channelModel.name = [NSString stringWithFormat:@"标题%d", i];
            channelModel.cid = [NSString stringWithFormat:@"%d", i];
            channelModel.isTop = NO;
            [_bottomChannelArr addObject:channelModel];
        }
    }
    return _bottomChannelArr;
}

@end

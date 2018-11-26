//
//  TUSelectPhotoEditorViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/22.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "TUSelectPhotoEditorViewController.h"

#import "FMTestAddPhotoController.h"
#import "TUSelectPhotoEditorView.h"
#import "TUSelectPhotoEditorItem.h"

@interface TUSelectPhotoEditorViewController () <TUSelectPhotoEditorViewDelegate>
{   // 底线，超过执行删除
    CGFloat _limit;
}
@property (nonatomic, strong) TUSelectPhotoEditorView *photoEditView;
@property (nonatomic, strong) UIView *bottomDeleteItemView;
@property (nonatomic, strong) UIButton *deleteIcon;
@property (nonatomic, strong) NSMutableArray *testArr;
@property (nonatomic, strong) UIButton *dismissBtn;

@end

@implementation TUSelectPhotoEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.dismissBtn];
    [self photoEditTest];
}

- (void)photoEditTest {
    TUSelectPhotoEditorView *photoEditView = [[TUSelectPhotoEditorView alloc] initWithFrame:CGRectMake(5, SCREEN_HEIGHT * 0.25, SCREEN_WIDTH - 10, (SCREEN_WIDTH - 10) / 4 * 3)];
    photoEditView.delegate = self;
    photoEditView.backgroundColor = [UIColor cyanColor];
    //    NSArray *testArr = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];
    NSMutableArray *testArr = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", nil];
    photoEditView.photosArr = testArr;
    _testArr = testArr;
    
    [self.view addSubview:photoEditView];
    _photoEditView = photoEditView;
    [self.view addSubview:self.bottomDeleteItemView];
    [self.bottomDeleteItemView addSubview:self.deleteIcon];
    _limit = SCREEN_HEIGHT - _bottomDeleteItemView.height / 2;
    [self.view bringSubviewToFront:self.photoEditView];
}

#pragma mark --- TUSelectPhotoEditorView Delegate
// 点击图片
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView item:(TUSelectPhotoEditorItem *)item itemAtIndex:(NSInteger)index {
    NSLog(@"click item index --- %ld", (long)index);
}
// 长按开始
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panBeginWithItem:(TUSelectPhotoEditorItem *)item {
    [self bottomDeleteItemViewShowOrHideWithFlag:YES];
}
// 长按移动
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panStateChangedWithItem:(TUSelectPhotoEditorItem *)item {
    CGRect rect = [item convertRect:item.bounds toView:self.view];
    //    NSLog(@" --- %f --- %f",rect.origin.y + rect.size.height, _limit);
    if (rect.origin.y + rect.size.height >= _limit && !_deleteIcon.selected) {
        NSLog(@"更换按钮状态逻辑 button selected --- YES");
        _deleteIcon.selected = YES;
    }
    if (rect.origin.y + rect.size.height < _limit && _deleteIcon.selected) {
        NSLog(@"更换按钮状态逻辑 button selected --- NO");
        _deleteIcon.selected = NO;
    }
}

// 长按结束
- (BOOL)photoEditView:(TUSelectPhotoEditorView *)photoEditView panEndWithItem:(TUSelectPhotoEditorItem *)item atIndex:(NSInteger)index{
    
    [self bottomDeleteItemViewShowOrHideWithFlag:NO];
    
    CGRect rect = [item convertRect:item.bounds toView:self.view];
    //    NSLog(@" --- %f --- %f",rect.origin.y + rect.size.height, _limit);
    if (rect.origin.y + rect.size.height >= _limit) {
        NSLog(@"执行删除逻辑");
        [_photoEditView deleteWith:item];
        [_testArr removeObjectAtIndex:index];
        _photoEditView.photosArr = _testArr;
        return YES;
    }
    return NO;
}
// 长按取消或失败
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView panCancelOrFailWithItem:(TUSelectPhotoEditorItem *)item {
    [self bottomDeleteItemViewShowOrHideWithFlag:NO];
}
// 长按
/*
 - (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView item:(TUSelectPhotoEditorItem *)item panGesture:(UIpanGestureRecognizer *)gesture {
 switch (gesture.state) {
 case UIGestureRecognizerStateBegan: {
 
 }
 break;
 case UIGestureRecognizerStateChanged: {
 NSLog(@"long press Changed --- ");
 
 }
 break;
 case UIGestureRecognizerStateEnded: {
 NSLog(@"long press Ended --- ");
 
 }
 break;
 case UIGestureRecognizerStateCancelled:
 case UIGestureRecognizerStateFailed:{
 NSLog(@"long press cancelled or failed --- ");
 
 }
 break;
 
 default:
 break;
 }
 }*/

- (void)bottomDeleteItemViewShowOrHideWithFlag:(BOOL)flag {
    CGFloat y;
    if (flag) {
        y = SCREEN_HEIGHT - 60;
    } else {
        y = SCREEN_HEIGHT;
    }
    [UIView animateWithDuration:.25 animations:^{
        _bottomDeleteItemView.top = y;
    }];
}

// 点击加号按钮
- (void)photoEditView:(TUSelectPhotoEditorView *)photoEditView addButton:(UIButton *)addButton {
    NSLog(@"add button click ---");
    FMTestAddPhotoController *tvc = [[FMTestAddPhotoController alloc] init];
    __weak typeof(self) weakSelf = self;
    tvc.addPhotoCallbackBlock = ^(NSMutableArray *photosArr) {
        __strong typeof (self) self = weakSelf;
        self.photoEditView.photosArr = photosArr;
        self.testArr = photosArr;
    };
    [self presentViewController:tvc animated:YES completion:nil];
}
- (void)dismissButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- lazy loading

- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        [_dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        _dismissBtn.backgroundColor = [UIColor lightGrayColor];
        [_dismissBtn addTarget:self action:@selector(dismissButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}
- (UIView *)bottomDeleteItemView {
    if (!_bottomDeleteItemView) {
        _bottomDeleteItemView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 60)];
        _bottomDeleteItemView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
    }
    return _bottomDeleteItemView;
}

- (UIButton *)deleteIcon {
    if (!_deleteIcon) {
        _deleteIcon = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 50) / 2, 0, 50, 60)];
        _deleteIcon.backgroundColor = [UIColor blueColor];
        [_deleteIcon setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
        [_deleteIcon setImage:[UIImage imageNamed:@"drag_delete"] forState:UIControlStateSelected];
    }
    return _deleteIcon;
}

@end

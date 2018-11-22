//
//  FMPhotoEditView.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/14.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "FMPhotoEditView.h"
#import "FMPhotoEditItem.h"

@interface FMPhotoEditView () <FMPhotoEditItemDelegate>
{
    CGFloat _smallWidth;
    CGFloat _bigWidth;
}
@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) NSMutableArray *cacheItemFrameArr;

@end
// 一行放 **小图** 的个数
static const NSInteger rowCount = 4;
@implementation FMPhotoEditView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    for (FMPhotoEditItem *item in self.itemsArr.reverseObjectEnumerator) {
        [self addSubview:item];
    }
    [self addSubview:self.addPhotoButton];
    _smallWidth =  self.width / 4;
    _bigWidth = self.width / 2;
}

- (void)setPhotosArr:(NSMutableArray *)photosArr {
    _photosArr = photosArr;
    
    [self refreshItemStatusAndLayout];
}

- (void)refreshItemStatusAndLayout {
    
    NSInteger count = _photosArr.count;
    if (count == 0 || count == 9) {
        _addPhotoButton.hidden = YES;
    } else {// +1为了处理add布局
        count +=1;
    }
    
    for (int i = 0; i < _itemsArr.count; i ++) {
        // 状态回置
        FMPhotoEditItem *item = _itemsArr[i];
        item.isBig = i ? NO : YES;
        item.hidden = YES;
        
        if (count == 0) continue;
        
        // 更新布局
        if ( i < count) {
            if (i != _photosArr.count) {
                FMPhotoEditItem *item = _itemsArr[i];
                item.hidden = NO;
                item.frame = [self getPhotoItemFrameWithIndex:i];
            } else {
                _addPhotoButton.frame = [self getPhotoItemFrameWithIndex:i];
                _addPhotoButton.hidden = NO;
            }
        }
        
    }
}
/*
- (void)originalLayout {
    
    for (int i = 0; i < _itemsArr.count; i ++) {
        FMPhotoEditItem *item = _itemsArr[i];
        item.isBig = i ? NO : YES;
        item.hidden = YES;
    }
    
    NSInteger count = _photosArr.count;
    if (count == 0 || count == 9) {
        _addPhotoButton.hidden = YES;
        if (count == 0) return;
    }
    count = count == 9 ? count : count + 1;
    for (int i = 0; i < count; i ++) {
        if (i != _photosArr.count) {
            FMPhotoEditItem *item = _itemsArr[i];
            item.hidden = NO;
            item.frame = [self getPhotoItemFrameWithIndex:i];
        } else {
            _addPhotoButton.frame = [self getPhotoItemFrameWithIndex:i];
            _addPhotoButton.hidden = NO;
        }
    }
    
}*/
// 计算并缓存布局
- (CGRect)getPhotoItemFrameWithIndex:(NSInteger)i {
    CGRect rect = CGRectZero;
    if (i < self.cacheItemFrameArr.count) {
        
        NSValue *frame = _cacheItemFrameArr[i];
       return rect = [frame CGRectValue];
        
    } else {
        
        if (i == 0) {
            rect = CGRectMake(0, 0, _bigWidth, _bigWidth);
        } else if (i > 0 && i <= 4) {
            CGFloat x = _bigWidth + (i - 1) % 2 * _smallWidth;
            CGFloat y = (i - 1) / 2 * _smallWidth;
            rect = CGRectMake(x, y, _smallWidth, _smallWidth);
        } else {
            CGFloat x = (i - 5) * _smallWidth;
            CGFloat y = _bigWidth;
            rect = CGRectMake(x, y, _smallWidth, _smallWidth);
        }
        
        NSValue *frame = [NSValue valueWithCGRect:rect];
        [_cacheItemFrameArr addObject:frame];
        return rect;
    }
}

// 根据手指位置 -> 变小图
- (void)firstPhotoToSmallSize:(FMPhotoEditItem *)item fingerPoint:(CGPoint)point {

    [UIView animateWithDuration:.25 animations:^{
        
        item.size = CGSizeMake(_smallWidth, _smallWidth);
        item.center = point;
        
    }];
    
}

- (void)deleteWith:(FMPhotoEditItem *)item {
    [_itemsArr removeObject:item];
    [_itemsArr addObject:item];
    FMPhotoEditItem* firstItem = _itemsArr.firstObject;
    firstItem.isBig = YES;
}

#pragma mark --- FMPhotoEditItem Delegate
- (void)photoItem:(FMPhotoEditItem *)photoItem tapGesture:(UITapGestureRecognizer *)gesture {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:item:itemAtIndex:)]) {
        NSInteger index = [_itemsArr indexOfObject:photoItem];
        [self.delegate photoEditView:self item:photoItem itemAtIndex:index];
    }
    
}
/*
- (void)photoItem:(FMPhotoEditItem *)photoItem panGesture:(UIPanGestureRecognizer *)gesture {
    if (_photosArr.count == 1) return;
    NSLog(@" --- pan gesture");
}*/

- (void)photoItem:(FMPhotoEditItem *)photoItem longPressGesture:(UILongPressGestureRecognizer *)gesture {
//    if (_photosArr.count == 1) return;
    
    static CGFloat offsetX;// X 方向的偏移量
    static CGFloat offsetY;// Y 方向的偏移量
    static NSInteger moveToIndex;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self bringSubviewToFront:photoItem];
            if (photoItem.isBig) {
                CGPoint fingerLoc = [gesture locationInView:self];
                [self firstPhotoToSmallSize:photoItem fingerPoint:fingerLoc];
            }
            
            _startIndex = [_itemsArr indexOfObject:photoItem];
            moveToIndex = _startIndex;
            CGPoint touchPoint = [gesture locationInView:photoItem];
            // 获取photoItem 在自己坐标下的中心点
            CGPoint centerPoint = CGPointMake(photoItem.width / 2, photoItem.height / 2);
            offsetX = touchPoint.x - centerPoint.x;
            offsetY = touchPoint.y - centerPoint.y;
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:longPressBeginWithItem:)]) {
                [self.delegate photoEditView:self longPressBeginWithItem:photoItem];
            }
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint movePoint = [gesture locationInView:self];
            photoItem.center = CGPointMake(movePoint.x - offsetX, movePoint.y - offsetY);
            CGFloat x = photoItem.center.x;
            CGFloat y = photoItem.center.y;
            /*UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            CGRect rect1 = [photoItem convertRect:photoItem.bounds toView:keyWindow];
            CGRect rect2 = [self convertRect:self.bounds toView:keyWindow];*/
            //x > 0 && y > 0 && x < self.width && y < self.height
            if (CGRectContainsPoint(self.bounds, photoItem.center)) {
                
//                NSLog(@"x --- %f, y --- %f", x, y);
                NSInteger tempIndex = (NSInteger)(y / (_smallWidth)) * rowCount + (NSInteger)(x / (_smallWidth));
//                NSLog(@"temp index --- %ld", (long)tempIndex);

                if (tempIndex <= 5) {
                    if (tempIndex == 2 || tempIndex == 3) {
                        moveToIndex = tempIndex - 1;
                    } else {
                        moveToIndex = 0;
                    }
                } else {
                    moveToIndex = tempIndex - 3;
                }
//                NSLog(@"true index --- %ld", (long)index);
                if (tempIndex != moveToIndex) {
                    tempIndex = moveToIndex;
//                    NSLog(@" --- 执行交换逻辑！！！");
                }
            } else {
                moveToIndex = _startIndex;
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:longPressStateChangedWithItem:)]) {
                [self.delegate photoEditView:self longPressStateChangedWithItem:photoItem];
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            // 注意代码顺序，代理要放前面
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:longPressEndWithItem:atIndex:)]) {
                [self.delegate photoEditView:self longPressEndWithItem:photoItem atIndex:_startIndex];
            }
            // 更新视图
            NSLog(@"start --- %ld, moveTo --- %ld", (long)_startIndex, (long)moveToIndex);
            [self exchangeItemAtIndex:_startIndex withItemAtIndex:moveToIndex];
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:longPressCancelOrFailWithItem:)]) {
                [self.delegate photoEditView:self longPressCancelOrFailWithItem:photoItem];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)exchangeItemAtIndex:(NSInteger)startIndex withItemAtIndex:(NSInteger)moveToIndex {
    
    FMPhotoEditItem *startItem = _itemsArr[startIndex];
    FMPhotoEditItem *moveToItem = _itemsArr[moveToIndex];
    
    if (startIndex == moveToIndex || moveToIndex >= _photosArr.count) {
        
        [self refreshPhotoItemFrameWith:startItem index:startIndex];
        
    } else {
        if (startItem.isBig) {
            
            startItem.isBig = NO;
            moveToItem.isBig = YES;
           
            [self refreshPhotoItemFrameWith:moveToItem index:startIndex];
            [self refreshPhotoItemFrameWith:startItem index:moveToIndex];
             [_itemsArr exchangeObjectAtIndex:startIndex withObjectAtIndex:moveToIndex];
            
        } else {
            if (moveToItem.isBig) {
                
                startItem.isBig = YES;
                moveToItem.isBig = NO;
                
                [self refreshPhotoItemFrameWith:startItem index:moveToIndex];
                [self refreshPhotoItemFrameWith:moveToItem index:startIndex];
                 [_itemsArr exchangeObjectAtIndex:startIndex withObjectAtIndex:moveToIndex];
                
            } else {
               
                [self refreshPhotoItemFrameWith:startItem index:moveToIndex];
                [self refreshPhotoItemFrameWith:moveToItem index:startIndex];
                 [_itemsArr exchangeObjectAtIndex:startIndex withObjectAtIndex:moveToIndex];
                
            }
        }
    }
}

- (void)refreshPhotoItemFrameWith:(FMPhotoEditItem *)item index:(NSInteger)index {
    [UIView animateWithDuration:.25 animations:^{
        item.frame = [self getPhotoItemFrameWithIndex:index];
    }];
}

- (void)addPhotoButtonClick:(UIButton *)click {
   
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:addButton:)]) {
        [self.delegate photoEditView:self addButton:click];
    }
    
}

/// MARK: lazy loading
- (NSMutableArray *)cacheItemFrameArr {
    if (!_cacheItemFrameArr) {
        _cacheItemFrameArr = [NSMutableArray arrayWithCapacity:9];
    }
    return _cacheItemFrameArr;
}

- (UIButton *)addPhotoButton {
    if (!_addPhotoButton) {
        
        _addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotoButton setImage:[UIImage imageNamed:@"album_add_Button"] forState:UIControlStateNormal];
        [_addPhotoButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_addPhotoButton addTarget:self action:@selector(addPhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addPhotoButton;
}

- (NSMutableArray *)itemsArr {
    if (!_itemsArr) {
        _itemsArr = [NSMutableArray array];
        
        for (int i = 0; i < 9; i ++) {
            FMPhotoEditItem *item = [[FMPhotoEditItem alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                item.isBig = YES;
            }
            item.backgroundColor = [UIColor purpleColor];
            item.delegate = self;
            item.hidden = YES;
            [_itemsArr addObject:item];
        }
    }
    return _itemsArr;
}
@end

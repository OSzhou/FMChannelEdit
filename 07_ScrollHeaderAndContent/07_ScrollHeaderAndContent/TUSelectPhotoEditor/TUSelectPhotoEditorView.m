//
//  TUSelectPhotoEditorView.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/22.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "TUSelectPhotoEditorView.h"
#import "TUSelectPhotoEditorItem.h"

@interface TUSelectPhotoEditorView () <TUSelectPhotoEditorItemDelegate>
{
    CGFloat _smallWidth;
    CGFloat _bigWidth;
}
@property (nonatomic, strong) NSMutableArray *itemsArr;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger moveToIndex;
@property (nonatomic, strong) UIButton *addPhotoButton;
@property (nonatomic, strong) NSMutableArray *cacheItemFrameArr;
@property (nonatomic, strong) TUSelectPhotoEditorItem *placeholderItem;

@end
// 一行放 **小图** 的个数
static const NSInteger rowCount = 4;
@implementation TUSelectPhotoEditorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    for (TUSelectPhotoEditorItem *item in self.itemsArr.reverseObjectEnumerator) {
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
        TUSelectPhotoEditorItem *item = _itemsArr[i];
        item.isBig = i ? NO : YES;
        item.hidden = YES;
        item.shadowView.hidden = YES;
        item.maskImageView.hidden = YES;
        item.contentImageView.hidden = item.isPlaceHolder ? YES : NO;
        if (count == 0) continue;
        
        // 更新布局
        if ( i < count) {
            if (i != _photosArr.count) {
                TUSelectPhotoEditorItem *item = _itemsArr[i];
                item.hidden = NO;
                item.frame = [self getPhotoItemFrameWithIndex:i];
            } else {
                _addPhotoButton.frame = [self getPhotoItemFrameWithIndex:i];
                _addPhotoButton.hidden = NO;
            }
        }
        
    }
}

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
- (void)firstPhotoToSmallSize:(TUSelectPhotoEditorItem *)item fingerPoint:(CGPoint)point {
    
    [UIView animateWithDuration:.25 animations:^{
        
        item.size = CGSizeMake(_smallWidth, _smallWidth);
        item.center = point;
        
    }];
    
}

#pragma mark --- TUSelectPhotoEditorItem Delegate
- (void)photoItem:(TUSelectPhotoEditorItem *)photoItem tapGesture:(UITapGestureRecognizer *)gesture {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:item:itemAtIndex:)]) {
        NSInteger index = [_itemsArr indexOfObject:photoItem];
        [self.delegate photoEditView:self item:photoItem itemAtIndex:index];
    }
    
}

 - (void)photoItem:(TUSelectPhotoEditorItem *)photoItem panGesture:(UIPanGestureRecognizer *)gesture {
 
     static NSInteger markIndex;
     static CGPoint startCenter;
     switch (gesture.state) {
         case UIGestureRecognizerStateBegan: {
             [self bringSubviewToFront:photoItem];
             NSLog(@"pan gesture --- begin");
             if (photoItem.isBig) {
                 CGPoint fingerLoc = [gesture locationInView:self];
                 [self firstPhotoToSmallSize:photoItem fingerPoint:fingerLoc];
             }
//             photoItem.alpha = .5;
             _startIndex = [_itemsArr indexOfObject:photoItem];
             
             _moveToIndex = _startIndex;
             markIndex = _startIndex;
             startCenter = photoItem.center;
             
             [self updateItemShadowAndMaskViewStatusWith:YES];
             [_itemsArr removeObject:photoItem];
             
             if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:panBeginWithItem:)]) {
                 [self.delegate photoEditView:self panBeginWithItem:photoItem];
             }
             
         }
             break;
         case UIGestureRecognizerStateChanged: {

             CGPoint movePoint = [gesture translationInView:self];
             photoItem.center = CGPointMake(startCenter.x + movePoint.x, startCenter.y + movePoint.y);
             CGPoint fingerPoint = [gesture locationInView:self];
             CGFloat x = fingerPoint.x;
             CGFloat y = fingerPoint.y;
             
             if (CGRectContainsPoint(self.bounds, fingerPoint)) {
                 // 九宫格对应的index
                 NSInteger tempIndex = (NSInteger)(y / (_smallWidth)) * rowCount + (NSInteger)(x / (_smallWidth));
                 // 对应后的index
                 NSInteger realIndex = 0;
                 if (tempIndex <= 5) {
                     if (tempIndex == 2 || tempIndex == 3) {
                         realIndex = tempIndex - 1;
                     } else {
                         realIndex = 0;
                     }
                 } else {
                     realIndex = tempIndex - 3;
                 }
                 
                 if (realIndex != markIndex) {
                     markIndex = realIndex;
                     
                     if (realIndex < _photosArr.count && realIndex >= 0) {
                         _moveToIndex = realIndex;
                         if ([_itemsArr containsObject:self.placeholderItem]) {
                             [_itemsArr removeObject:_placeholderItem];
                         }
                         [_itemsArr insertObject:self.placeholderItem atIndex:_moveToIndex];
                         if (!_placeholderItem.superview) {
                             [self addSubview:_placeholderItem];
                             [self sendSubviewToBack:_placeholderItem];
                         }
                         
                         [UIView animateWithDuration:.25 animations:^{
                             [self refreshItemStatusAndLayout];
                         }];
                         [self updateItemShadowAndMaskViewStatusWith:YES];
                     }
                     
                 }
                 
             }
             
             if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:panStateChangedWithItem:)]) {
                 [self.delegate photoEditView:self panStateChangedWithItem:photoItem];
             }
         }
             break;
         case UIGestureRecognizerStateEnded: {
             
             [self moveItem:photoItem toIndex:_moveToIndex];
             
              // 直接调换两张的逻辑
//             NSLog(@"start --- %ld, moveTo --- %ld", (long)_startIndex, (long)moveToIndex);
//             [self exchangeItemAtIndex:_startIndex withItemAtIndex:moveToIndex];

         }
             break;
         case UIGestureRecognizerStateCancelled:
         case UIGestureRecognizerStateFailed:{
             // 状态回置
             [self moveItem:photoItem toIndex:_moveToIndex];
             if (self.delegate && [self.delegate respondsToSelector:@selector(photoEditView:panCancelOrFailWithItem:)]) {
                 [self.delegate photoEditView:self panCancelOrFailWithItem:photoItem];
             }
         }
             break;
             
         default:
             break;
     }
 }

- (void)moveItem:(TUSelectPhotoEditorItem *)photoItem toIndex:(NSInteger)moveToIndex {
//    photoItem.alpha = 1;
    // 更新视图
    if ([_itemsArr containsObject:_placeholderItem]) {
        [_itemsArr removeObject:_placeholderItem];
        [_placeholderItem removeFromSuperview];
    }
    // 判断是否执行了删除逻辑
    BOOL isDeleted = [self.delegate photoEditView:self panEndWithItem:photoItem atIndex:_startIndex];
    
    if (isDeleted) {
        
        [_itemsArr removeObject:photoItem];
        [_itemsArr addObject:photoItem];
        
    } else {
        [_itemsArr insertObject:photoItem atIndex:moveToIndex];
        NSLog(@"111 --- %ld 222 --- %ld", _startIndex, moveToIndex);
        if (moveToIndex < _photosArr.count && moveToIndex >= 0) {
            if (_startIndex != moveToIndex) {
                NSString * temp = _photosArr[_startIndex];
                [_photosArr removeObjectAtIndex:_startIndex];
                [_photosArr insertObject:temp atIndex:moveToIndex];
            };
        }
        
    }
    [UIView animateWithDuration:.25 animations:^{
        [self refreshItemStatusAndLayout];
    }];
    NSLog(@"itemArr count --- %ld", (long)_itemsArr.count);
    NSLog(@"photoArr count --- %ld", (long)_photosArr.count);
    [self updateItemShadowAndMaskViewStatusWith:NO];
}

// isMoving 是否正在移动 YES 是 NO 移动结束
- (void)updateItemShadowAndMaskViewStatusWith:(BOOL)isMoving {
    
    NSInteger count = _photosArr.count;
    count = count == 9 ? count : count + 1;
    
    for (int i = 0; i < count; i ++) {
        TUSelectPhotoEditorItem *item = _itemsArr[i];
        if (item.isPlaceHolder) continue;
        if (isMoving) {
            
            if (i == _moveToIndex) {
                item.shadowView.hidden = !isMoving;
            } else {
                item.maskImageView.hidden = !isMoving;
                item.userInteractionEnabled = NO;
            }
            
            if (_photosArr.count != 9 && i == _photosArr.count) {
                item.hidden = NO;
                item.frame = _addPhotoButton.frame;
                item.contentImageView.hidden = YES;
                [self bringSubviewToFront:item];
                NSLog(@"add button up --- %@", NSStringFromCGRect(item.frame));
                _addPhotoButton.enabled = NO;
            }
            
        } else {
            
            item.shadowView.hidden = !isMoving;
            item.maskImageView.hidden = !isMoving;
            item.userInteractionEnabled = YES;
            _addPhotoButton.enabled = YES;
            if (count != 9 && i == _photosArr.count) {
                item.hidden = !isMoving;
            }
            
        }
        
    }
}

- (void)exchangeItemAtIndex:(NSInteger)startIndex withItemAtIndex:(NSInteger)moveToIndex {
    
    TUSelectPhotoEditorItem *startItem = _itemsArr[startIndex];
    TUSelectPhotoEditorItem *moveToItem = _itemsArr[moveToIndex];
    
    if (startIndex == moveToIndex || moveToIndex >= _photosArr.count) {
        
        [self refreshPhotoItemFrameWith:startItem index:startIndex];
        
    } else {

        [self refreshPhotoItemFrameWith:moveToItem index:startIndex];
        [self refreshPhotoItemFrameWith:startItem index:moveToIndex];
        [_itemsArr exchangeObjectAtIndex:startIndex withObjectAtIndex:moveToIndex];
        
    }
}

- (void)refreshPhotoItemFrameWith:(TUSelectPhotoEditorItem *)item index:(NSInteger)index {
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
- (TUSelectPhotoEditorItem *)placeholderItem {
    if (!_placeholderItem) {
        _placeholderItem = [[TUSelectPhotoEditorItem alloc] init];
        _placeholderItem.backgroundColor = [UIColor clearColor];//[UIColor blueColor];
        _placeholderItem.contentImageView.hidden = YES;
        _placeholderItem.isPlaceHolder = YES;
    }
    return _placeholderItem;
}

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
            
            TUSelectPhotoEditorItem *item = [[TUSelectPhotoEditorItem alloc] initWithFrame:CGRectZero];
            if (i == 0) {
                item.isBig = YES;
            }
            item.backgroundColor = [UIColor clearColor];
            item.delegate = self;
            item.hidden = YES;
            [_itemsArr addObject:item];
            
        }
    }
    return _itemsArr;
}
@end

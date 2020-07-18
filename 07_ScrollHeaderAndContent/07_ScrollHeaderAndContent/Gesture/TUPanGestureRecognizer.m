//
//  TUPanGestureRecognizer.m
//  tataufo
//
//  Created by Zhouheng on 2018/12/21.
//  Copyright © 2018年 tataufo. All rights reserved.
//

#import "TUPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface TUPanGestureRecognizer ()

@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) CGPoint   beginP;
@end

@implementation TUPanGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    NSLog(@"TUState --- %d", self.state);
    CGPoint nowPoint = [self translationInView:self.view];// 不准
    _beginP = [[touches anyObject] locationInView:self.view];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@" 2222222222 ");
    [super touchesMoved:touches withEvent:event];
    NSLog(@" 3333333333333 ");
//    CGPoint nowPoint = [self translationInView:self.view];
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    NSLog(@"x --- %f y --- %f", nowPoint.x, nowPoint.y);
    if (!_isMoving) {
        
        if (nowPoint.y - _beginP.y > 1) {
            _isMoving = YES;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
        
    }
   
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@" --- end");
    _isMoving = NO;
}

@end

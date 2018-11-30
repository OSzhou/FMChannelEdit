//
//  ControlTestView.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/29.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "ControlTestView.h"
#import "TouchTestControl.h"

@implementation ControlTestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
/*
    gesture vs btn -> btn
    gesture vs control -> gesture
    btn vs control -> 谁后添加，执行谁
 */
- (void)createUI {
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTest)];
//    [self addGestureRecognizer:tap];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:self.bounds];
    btn.backgroundColor = [UIColor purpleColor];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    TouchTestControl *control = [[TouchTestControl alloc] initWithFrame:self.bounds];
    self.backgroundColor = [UIColor cyanColor];
    [control addTarget:self action:@selector(controlTest) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    
    
}

- (void)buttonClick {
    NSLog(@"btn --- test");
}

- (void)tapTest {
    NSLog(@"tap gesture --- test");
}

- (void)controlTest {
    NSLog(@"control --- Test");
}

@end

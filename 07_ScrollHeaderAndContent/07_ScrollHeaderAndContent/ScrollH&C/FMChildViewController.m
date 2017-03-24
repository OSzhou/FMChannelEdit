//
//  FMChildViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/2/22.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "FMChildViewController.h"
/** 代码来源网址：http://blog.it985.com/7986.html*/
@interface FMChildViewController ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation FMChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self colorChangeTest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)colorChangeTest {
    //初始化imageView
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"95789_1421722187ll70"]];
    imageView.frame = CGRectMake(0, 64, self.view.frame.size.width, 200);
    [self.view addSubview:imageView];
    
    //初始化渐变层
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = imageView.bounds;
    [imageView.layer addSublayer:self.gradientLayer];
    
    //设置颜色的渐变方向
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    
    //设定颜色组
    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:42.0 / 255.0 green:143.0 / 255.0 blue:199.0 / 255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:52.0 / 255.0 green:182.0 / 255.0 blue:162.0/ 255.0 alpha:1.0].CGColor];
    
    //设置颜色分割点
//    self.gradientLayer.locations = @[@(0.5f), @(0.5f)];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    
}

- (void)timerEvent {
    //定时改变颜色
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor colorWithRed:arc4random() % 255 / 255.0
                                                               green:arc4random() % 255 / 255.0
                                                                blue:arc4random() % 255 / 255.0
                                                               alpha:1.0].CGColor];
    
    //定时改变分割点
//    self.gradientLayer.locations = @[@(arc4random() % 10 / 10.0f), @(1.0f)];
}

@end

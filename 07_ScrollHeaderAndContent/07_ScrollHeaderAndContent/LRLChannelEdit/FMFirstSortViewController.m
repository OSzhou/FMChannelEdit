//
//  FMFirstSortViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/3/23.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "LRLChannelEditController.h"
#import "FMFirstSortViewController.h"

@interface FMFirstSortViewController ()
@end

@implementation FMFirstSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(50, 280, 250, 40)];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"排序删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToTheChannelEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}


#pragma mark - 跳转到频道编辑页面
- (void)goToTheChannelEdit:(id)sender {

}

@end

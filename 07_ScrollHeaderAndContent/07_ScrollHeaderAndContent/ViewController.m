//
//  ViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/2/22.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "FMBasicViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)testButtonClick:(id)sender {
    [self scrollHeaderAndContentTest];
}

- (void)scrollHeaderAndContentTest {
    FMBasicViewController *bvc = [[FMBasicViewController alloc] init];
//    bvc.isScale = NO;
    bvc.controllerClassArr = @[@"FMChildViewController",
                               @"FMChildViewController",
                               @"FMChildViewController",
                               @"FMChildViewController",
                               @"FMChildViewController",
                               @"FMChildViewController"];
    bvc.controllerTitleArr = @[@"全部课程",
                               @"政治",
                               @"军事",
                               @"明星八卦",
                               @"体育",
                               @"财富"];;
    [self presentViewController:bvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

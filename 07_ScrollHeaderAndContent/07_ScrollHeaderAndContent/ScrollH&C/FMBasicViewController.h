//
//  FMBasicViewController.h
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/2/22.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMBasicViewController : UIViewController

@property (nonatomic, strong) NSArray *controllerClassArr;
@property (nonatomic, strong) NSArray *controllerTitleArr;
/// 标题间距
@property (nonatomic, assign) CGFloat middleMargin;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) BOOL isScale;

@end

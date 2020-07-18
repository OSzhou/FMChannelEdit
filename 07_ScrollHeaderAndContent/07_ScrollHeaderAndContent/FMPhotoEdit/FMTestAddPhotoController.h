//
//  FMTestAddPhotoController.h
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/20.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddPhotoCallbackBlock)(NSMutableArray *photosArr);
@interface FMTestAddPhotoController : UIViewController

@property (nonatomic, copy) AddPhotoCallbackBlock addPhotoCallbackBlock;

@end

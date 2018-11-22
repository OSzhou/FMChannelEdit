

//
//  FMTestAddPhotoController.m
//  07_ScrollHeaderAndContent
//
//  Created by Zhouheng on 2018/11/20.
//  Copyright © 2018年 Windy. All rights reserved.
//

#import "FMTestAddPhotoController.h"

@interface FMTestAddPhotoController () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIButton *dismissBtn;

@end

@implementation FMTestAddPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:self.dismissBtn];
    
    [self.view addSubview:self.btn];
    
    [self.view addSubview:self.tf];
}

- (void)completedButtonClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    int count = [_tf.text intValue];
    if (count > 9) {
        count = 9;
    }
    NSMutableArray *testArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        [testArr addObject:@""];
    }
    
    !_addPhotoCallbackBlock ?: _addPhotoCallbackBlock(testArr);
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)textFieldInputChange:(NSNotification *)noti {

    if (_tf.text.length > 1) {
        _tf.text = [ _tf.text substringToIndex:1];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dismissButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- lazy loading

- (UIButton *)dismissBtn {
    if (!_dismissBtn) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
        _dismissBtn.backgroundColor = [UIColor lightGrayColor];
        [_dismissBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(dismissButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UITextField *)tf {
    if (!_tf) {
        _tf = [[UITextField alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 200) / 2, 100, 200, 30)];
        _tf.delegate = self;
        _tf.backgroundColor = [UIColor lightGrayColor];
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldInputChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return _tf;
}

- (UIButton *)btn {
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake((SCREEN_WIDTH - 100) / 2, (SCREEN_HEIGHT - 50) / 2, 100, 50);
        btn.backgroundColor = [UIColor cyanColor];
        [btn setTitle:@"completed" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(completedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _btn = btn;
    }
    return _btn;
}


@end

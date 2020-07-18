//
//  ViewController.m
//  07_ScrollHeaderAndContent
//
//  Created by Windy on 2017/2/22.
//  Copyright © 2017年 Windy. All rights reserved.
//

#import "ViewController.h"
#import "FMBasicViewController.h"
#import "UIView+FMBoom.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)testButtonClick:(id)sender {
//    [self scrollHeaderAndContentTest];
    [self viewBoomTest];
}

- (void)viewBoomTest {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    v.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:v];
    [v boom];
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

- (void)stringLength {
    NSString *str = @"Hdhdhdjdkxkjxjdndnllwmdxhhxhw 你想你想你了男男女女想你几点了一天啊。不能和人在一起就不应该在你的世界纪录了我自己去了一回宿舍休息时间的话去吧？就算我们也只是自己一个过客……我在这里等你回来我给你打电话了，就是这样一种感觉叫做不应该做朋友好朋友一起分享生活中我们看到大家这么努力这么好吧。一切也没有发生变化。。我们都在这里等你来时路走到我这里IDIDIE is my偶弟弟妹妹的孩子地下经济学家说我在这里等你激动激动激动激动就觉得激动激动就疾风劲草经济学家激动激动激动激动解决午饭就大呼小叫的就抓紧时间问设计建设就积极激动激动激动非常就军训亟待椒的满錒鳖蹿蹬㘥珐辊在你就抓紧时间就觉得激动就想哭激动就像精彩即将放假人坚持坚持坚持经济学家空间打开的可可可可可可可可快点快点开几个客人开发开放可可疯狂的可可快点快点开的可可可可可疯狂快让开让开疯狂的可可想快点快点快点开可可快点开放可可疯狂认可开发考察课下课上课就犯困曾经是可可妇女看过 v 可可 vi 哟哟哟看过可别可可就喜欢 v 家附近警方近日房价贵妇人纠纷解决冲突 v 肌肤激动激动解决我耐心耐心才叫几个客人坚持呢次看个客人开车就疾风劲草激动快点疯狂意义更加可贵军车冷峻个可可高考体检冠军拒绝的可可买给妈妈过高考个可可透明公开vkvkfkk开发开放看个可可个人可可他今天看过可考察课下课可可看天空广阔看过看个可可高考工厂可可想快点开疯狂下课可可高考 v 看 v 可可高考高考高考开发开放可可可可高考高考开发课程名称女们麻烦哦估vmmccmkkfmfif 开疯狂疯狂可可开疯狂高考太快让开客人Hdhdhdjdkxkjxjdndnllwmdxhhxhw 你想你想你了男男女女想你几点了一天啊。不能和人在一起就不应该在你的世界纪录了我自己去了一回宿舍休息时间的话去吧？就算我们也只是自己一个过客……我在这里等你回来我给你打电话了，就是这样一种感觉叫做不应该做朋友好朋友一起分享生活中我们看到大家这么努力这么好吧。一切也没有发生变化。。我们都在这里等你来时路走到我这里IDIDIE is my偶弟弟妹妹的孩子地下经济学家说我在这里等你激动激动激动激动就觉得激动激动就疾风劲草经济学家激动激动激动激动解决午饭就大呼小叫的就抓紧时间问设计建设就积极激动激动激动非常就军训亟待椒的满錒鳖蹿蹬㘥珐辊在你就抓紧时间就觉得激动就想哭激动就像精彩即将放假人坚持坚持坚持经济学家空间打开的可可可可可可可可快点快点开几个客人开发开放可可疯狂的可可快点快点开的可可可dff，";
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"str length --- %ld", data.length);
}

@end

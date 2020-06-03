//
//  DBUIModule.m
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "DBUIModule.h"

@implementation DBUIModule
- (void)run{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.moduleManage.viewController.view addSubview:btn];

    NSLog(@"run  DBUIModule");
}
- (void)btnClick{
    [self.moduleManage.messageBusManager postMessageWithMessageName:@"hhh1"];
    [self.moduleManage.messageBusManager postMessageWithMessageName:@"hhh"];
    [self.moduleManage.messageBusManager postMessageWithMessageName:@"hhh" data:@{@"1111":@"1111"}];


}
- (void)onDestroy{
    NSLog(@"onDestroy  DBUIModule");
}

- (void)onReceiveMessage:(DBMessage *)message{
    NSLog(@"DBTestModule message.name:%@ data:%@",message.messageName,message.data);
}




@end

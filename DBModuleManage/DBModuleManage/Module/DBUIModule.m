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
    [self.moduleManage.viewController.view addSubview:btn];

//    NSLog(@"run  DBUIModule");
}

- (void)onDestroy{
//    NSLog(@"onDestroy  DBUIModule");
}

- (void)onReceiveMessage:(NSString *)message{
        NSLog(@"message");

}
@end

//
//  DBTestModule.m
//  DBModuleManage
//
//  Created by dengbinOld on 2020/6/3.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "DBTestModule.h"

@implementation DBTestModule
- (void)run{

    NSLog(@"run  DBTestModule");
}

- (void)onDestroy{
    NSLog(@"onDestroy  DBTestModule");
}

- (void)onReceiveMessage:(DBMessage *)message{
    NSLog(@"DBTestModule message.name:%@ data:%@",message.messageName,message.data);

}
@end

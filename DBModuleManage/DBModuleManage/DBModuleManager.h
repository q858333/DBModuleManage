//
//  DBModuleManage.h
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBModuleConfig.h"

NS_ASSUME_NONNULL_BEGIN
@class MessageBusManager;
@interface DBModuleManager : NSObject
@property (nonatomic, weak) MessageBusManager *messageBusManager;


@property (nonatomic, weak) UIViewController *viewController;
- (void)registerModule:(DBModuleConfig *)module;

- (void)installModule;
- (void)checkRegisterModuleWithMessage:(NSString *)messageName;



@end

NS_ASSUME_NONNULL_END

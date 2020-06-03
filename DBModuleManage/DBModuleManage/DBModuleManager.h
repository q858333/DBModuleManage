//
//  DBModuleManage.h
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBModuleConfig.h"
#import "MessageBusManager.h"

NS_ASSUME_NONNULL_BEGIN
@interface DBModuleManager : NSObject
@property (nonatomic, weak) MessageBusManager *messageBusManager;


@property (nonatomic, weak) UIViewController *viewController;
//注册模块
- (void)registerModule:(DBModuleConfig *)module;

//检查模块是否初始化
- (void)checkRegisterModuleWithMessage:(NSString *)messageName;

//安装/卸载模块
- (void)installModule;
- (void)uninstallModule;

@end

NS_ASSUME_NONNULL_END

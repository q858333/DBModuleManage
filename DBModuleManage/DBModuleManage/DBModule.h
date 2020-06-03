//
//  DBModule.h
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DBModuleManager.h"
#import "DBMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBModule : NSObject
@property (nonatomic, weak) DBModuleManager *moduleManage;
- (void)run;
- (void)onDestroy;
- (void)onReceiveMessage:(DBMessage *)message;

@end

NS_ASSUME_NONNULL_END

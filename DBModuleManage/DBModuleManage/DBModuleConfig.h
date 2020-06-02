//
//  DBModule.h
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, DBModulePriority) {
    DBModulePriorityLow = 0,
    DBModulePriorityNormal = 1,
    DBModulePriorityHight = 2,
    DBModulePriorityWhenUse = 3,

};

NS_ASSUME_NONNULL_BEGIN

@interface DBModuleConfig : NSObject

@property (nonatomic, copy) NSString *className; //模块类

@property (nonatomic, copy) NSString *idenfiter; //唯一标示

@property (nonatomic, copy) NSString *des; //模块介绍

@property (nonatomic, assign) DBModulePriority  priority;//优先级

@property (nonatomic, copy) NSArray  *messages; //消息列表


@end

NS_ASSUME_NONNULL_END

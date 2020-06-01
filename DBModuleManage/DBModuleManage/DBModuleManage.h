//
//  DBModuleManage.h
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DBModuleConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBModuleManage : NSObject
@property (nonatomic, weak) UIViewController *viewController;
- (void)registerModule:(DBModuleConfig *)module;

- (void)installModule;



@end

NS_ASSUME_NONNULL_END

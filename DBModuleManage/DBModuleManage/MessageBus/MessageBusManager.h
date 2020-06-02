//
//  MessageBusManager.h
//  CustomNotification
//
//  Created by dengbinOld on 2020/4/8.
//  Copyright © 2020 DengBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DBModuleManage;
@interface MessageBusManager : NSObject

@property (nonatomic, weak) DBModuleManage *moduleManager;

+(id)shareMessageManager;

- (void)addAppObserver:(NSObject *)observer messageName:(NSString *)messageName selector:(SEL)selector priority:(NSInteger)priority excuteThreadMode:(NSInteger)excuteThreadMode;
- (void)postMessageWithMessageName:(NSString *)messageName;
- (void)sortObserver;

@end

NS_ASSUME_NONNULL_END

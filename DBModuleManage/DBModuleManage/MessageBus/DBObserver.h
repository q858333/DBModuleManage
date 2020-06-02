//
//  DBObserver.h
//  CustomNotification
//
//  Created by dengbinOld on 2020/4/8.
//  Copyright © 2020 DengBin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ObserverEcuteThreadMode) {
    ObserverEcuteThreadModeCurrent = 0,               //当前线程
    ObserverEcuteThreadModeMain ,  //主线程

};


@interface DBObserver : NSObject
//监听者
@property (nonatomic, strong) NSObject *observer;
//监听的消息
@property (nonatomic, copy) NSString   *messageName;
//监听到消息后调用的方法
@property (nonatomic, assign) SEL selector;
//优先级
@property (nonatomic, assign) NSInteger priority;
//执行线程
@property (nonatomic, assign) ObserverEcuteThreadMode excuteThreadMode;


@end

NS_ASSUME_NONNULL_END

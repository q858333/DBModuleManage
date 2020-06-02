//
//  MessageBusManager.m
//  CustomNotification
//
//  Created by dengbinOld on 2020/4/8.
//  Copyright © 2020 DengBin. All rights reserved.
//

#import "MessageBusManager.h"
#import "DBObserver.h"
#import "DBMessage.h"
#import "DBModuleManage.h"

#define CP_DISPATCH_MAIN_ASYNC(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
@interface MessageBusManager ()
@property (nonatomic, strong) NSMutableDictionary *messageDic;

@property (nonatomic, strong) NSMutableArray *watingHandleMessageList;

@end

@implementation MessageBusManager
+(id)shareMessageManager{

    static MessageBusManager *messageBus = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageBus = [[MessageBusManager alloc]init];
    });
    return messageBus;
}


- (void)addAppObserver:(NSObject *)observer messageName:(NSString *)messageName selector:(SEL)selector priority:(NSInteger)priority excuteThreadMode:(NSInteger)excuteThreadMode{

    @synchronized (self) {
        if(![self.messageDic objectForKey:messageName]){
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [self.messageDic setObject:arr forKey:messageName];
        }
            
        DBObserver *object = [[DBObserver alloc] init];
        object.observer = observer;
        object.messageName = messageName;
        object.selector = selector;
        object.priority = priority;
        object.excuteThreadMode = excuteThreadMode;
        
        NSMutableArray *observerList = [self.messageDic objectForKey:messageName];
        [observerList addObject:object];
    }
    
}
- (void)postMessageWithMessageName:(NSString *)messageName data:(id)data{
    DBMessage *message = [[DBMessage alloc] init];
    message.data = data;
    message.messageName = messageName;
    [self beginHandleMessage:message];
    
}
- (void)postMessageWithMessageName:(NSString *)messageName{
    [self postMessageWithMessageName:messageName data:nil];
}

- (void)beginHandleMessage:(DBMessage *)message{
    
    @synchronized (self) {
        [self.watingHandleMessageList addObject:message];
        [self handleMessage];
    }
}

- (void)handleMessage{
    if(self.watingHandleMessageList.count == 0){
        return;
    }
    DBMessage *message = [self.watingHandleMessageList firstObject];
    [self checkMessageObserver:message];
    [self invokeObserverSelctor:message];
    [self.watingHandleMessageList removeObject:message];
    [self handleMessage];
}
- (void)checkMessageObserver:(DBMessage *)message{
    if(message){
        [self.moduleManager checkRegisterModuleWithMessage:message.messageName];
    }

}
- (void)invokeObserverSelctor:(DBMessage *)message{
    NSMutableArray *observerList = [self.messageDic objectForKey:message.messageName];
    [observerList enumerateObjectsUsingBlock:^(DBObserver  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.excuteThreadMode == ObserverEcuteThreadModeMain){
            CP_DISPATCH_MAIN_ASYNC(^{
                [self invokeWithTarget:obj.observer selector:obj.selector object:message];
            })
        }else{
            [self invokeWithTarget:obj.observer selector:obj.selector object:message];
        }
        
    }];
}
- (void)invokeWithTarget:(id)target selector:(SEL)selector object:(id)object{
//
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:selector withObject:object];
#pragma clang diagnostic pop

//    IMP imp = [target methodForSelector:selector];
//    void (*func)(id, SEL,id) = (void *)imp;
//    func(target, selector,object);

}

- (void)removeObserver:(NSObject *)observer{
    @synchronized (self) {
        [self.messageDic enumerateKeysAndObjectsUsingBlock:^(NSString  *key, NSMutableArray  *observers, BOOL * _Nonnull stop) {
            [observers enumerateObjectsUsingBlock:^(DBObserver  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.observer == observer){
                    [observers removeObject:obj];
                }
                
            }];
            if(observers.count == 0){
                [self.messageDic removeObjectForKey:key];
            }
            
        }];
    }
}

- (void)sortObserver{
    @synchronized (self) {
        [self.messageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *  _Nonnull observerQueue, BOOL * _Nonnull stop) {
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
            NSArray *sortedArray = [observerQueue sortedArrayUsingDescriptors:@[descriptor]];
            [self.messageDic setValue:[NSMutableArray arrayWithArray:sortedArray] forKey:key];
        }];
    }
}


- (NSMutableArray *)watingHandleMessageList{
    if(!_watingHandleMessageList){
        _watingHandleMessageList = [[NSMutableArray alloc] init];
    }
    return _watingHandleMessageList;
}
- (NSMutableDictionary *)messageDic{
    if(!_messageDic){
        _messageDic = [[NSMutableDictionary alloc] init];
    }
    return _messageDic;
}
@end

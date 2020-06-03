//
//  DBModuleManage.m
//  ModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "DBModuleManager.h"
#import "DBModule.h"
#import "MessageBusManager.h"

@interface DBModuleManager ()
@property (nonatomic, strong) NSMutableDictionary <NSString *,DBModuleConfig *> *lowModuleConfig;
@property (nonatomic, strong) NSMutableDictionary <NSString *,DBModuleConfig *> *normalModuleConfig;
@property (nonatomic, strong) NSMutableDictionary <NSString *,DBModuleConfig *> *highModuleConfig;
@property (nonatomic, strong) NSMutableDictionary  <NSString *,DBModuleConfig *> *whenUseModuleConfig;

@property (nonatomic, strong) NSMutableDictionary <NSString *,DBModule*> *installedModule;


@property (nonatomic, strong) NSMutableDictionary <NSString *,NSMutableArray <DBModule *>*> *messageConfig;


@end

@implementation DBModuleManager

- (void)registerModule:(DBModuleConfig *)module{
    if(!module || module.className.length == 0){
        NSAssert(NO, @"注册失败");
        return ;
    }
    if (module.priority == DBModulePriorityNormal){
        [self.normalModuleConfig setObject:module forKey:module.idenfiter];
    }else if(module.priority == DBModulePriorityHight){
        [self.highModuleConfig setObject:module forKey:module.idenfiter];
    }else if (module.priority == DBModulePriorityWhenUse){
        [self.whenUseModuleConfig setObject:module forKey:module.idenfiter];
    }else{
        [self.lowModuleConfig setObject:module forKey:module.idenfiter];
    }
    
//    for (NSString *messageName in module.messages) {
//        NSMutableArray *modules = [self.messageConfig objectForKey:messageName];
//        if(!modules){
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            [arr addObject:module.idenfiter];
//            [self.messageConfig setObject:arr forKey:messageName];
//        }else{
//            [modules addObject:module.idenfiter];
//        }
//
//    }
//
}

- (void)installModule{
    [self performInMainThreadBlock:^{
        [self.highModuleConfig enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DBModuleConfig * _Nonnull obj, BOOL * _Nonnull stop) {
            
            [self moduleInitWithModuleConfig:obj];
            
        }];
        [self.highModuleConfig removeAllObjects];
        [self performSelector:@selector(installNormalModule) withObject:nil afterDelay:5];
    }];
    
 
}

- (void)uninstallModule{
    [NSThread cancelPreviousPerformRequestsWithTarget:self];
    [self.installedModule enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DBModule * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj onDestroy];
    }];
    
    [self.installedModule removeAllObjects];
}
- (void)installNormalModule{
    [self.normalModuleConfig enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DBModuleConfig * _Nonnull obj, BOOL * _Nonnull stop) {
           
           [self moduleInitWithModuleConfig:obj];
           
       }];
    [self.normalModuleConfig removeAllObjects];
    
    [self performSelector:@selector(installLowModule) withObject:nil afterDelay:5];
}

- (void)installLowModule{

    [self.lowModuleConfig enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DBModuleConfig * _Nonnull obj, BOOL * _Nonnull stop) {
        
        [self moduleInitWithModuleConfig:obj];
    }];
    [self.normalModuleConfig removeAllObjects];
}

- (void)checkRegisterModuleWithMessage:(NSString *)messageName{
    [self performInMainThreadBlock:^{
         
        NSArray *configs = @[self.whenUseModuleConfig,self.highModuleConfig,self.normalModuleConfig,self.lowModuleConfig];
        
        
        for (NSMutableDictionary *dic in configs) {
            [dic enumerateKeysAndObjectsUsingBlock:^(NSString  *indenfier, DBModuleConfig *config, BOOL * _Nonnull stop) {
                if([config.messages containsObject:messageName]){
                  [self moduleInitWithModuleConfig:config moduleDic:dic];
                }
                
            }];
            
        }
    }];
    
}
- (DBModule *)moduleByIdenfiter:(NSString *)idenfiter{
    __block DBModule *module = nil;

    [self performInMainThreadBlock:^{
        if([self.installedModule objectForKey:idenfiter]){
            module = self.installedModule[idenfiter];
        }
        
        if(!module){

            NSArray *configs = @[self.whenUseModuleConfig,self.highModuleConfig,self.normalModuleConfig,self.lowModuleConfig];
               [configs enumerateObjectsUsingBlock:^(NSMutableDictionary  *dic, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                   [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DBModuleConfig * _Nonnull config, BOOL * _Nonnull stop) {
                       
                       if(idenfiter == config.idenfiter){
                           module = [self moduleInitWithModuleConfig:config moduleDic:dic];
                           *stop = YES;
                       }

                   }];
                   
                   if(module){
                       *stop = YES;
                   }
                   
               }];

            
        }
        
        
    }];
   
    return module;
    
}
- (DBModule *)moduleInitWithModuleConfig:(DBModuleConfig *)config moduleDic:(NSMutableDictionary *)moduleDic{
    DBModule *module  = [self moduleInitWithModuleConfig:config];
    [moduleDic removeObjectForKey:config.idenfiter];
    
    return module;
}
- (DBModule *)moduleInitWithModuleConfig:(DBModuleConfig *)config{
    
    if([self.installedModule objectForKey:config.idenfiter]){
        return self.installedModule[config.idenfiter];
    }
    
    Class class = NSClassFromString(config.className);
    DBModule *module = [[class alloc] init];
    module.moduleManage = self;
    [self.installedModule setObject:module forKey:config.idenfiter];
    for (NSString *messageName in config.messages) {
        [self.messageBusManager addAppObserver:module messageName:messageName selector:@selector(onReceiveMessage:) priority:0 excuteThreadMode:0];
    }
    [self.messageBusManager sortObserver];
    
    [module run];
    
    
    return module;
    
}

- (void)performInMainThreadBlock:(void(^)(void))block {
    if([NSThread isMainThread]){
        if(block){
            block();
        }
    }
    else{
        NSAssert(NO, @"module manager must run in mainThread");
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(block){
                block();
            }
        });
    }
    if (!block) {
        return;
    }
}


#pragma  mark - lazy load
- (NSMutableDictionary *)lowModuleConfig{
    if(!_lowModuleConfig){
        _lowModuleConfig = [[NSMutableDictionary alloc] init];
    }
    return _lowModuleConfig;
}
- (NSMutableDictionary *)normalModuleConfig{
    if(!_normalModuleConfig){
        _normalModuleConfig = [[NSMutableDictionary alloc] init];
    }
    return _normalModuleConfig;
}
- (NSMutableDictionary *)highModuleConfig{
    if(!_highModuleConfig){
        _highModuleConfig = [[NSMutableDictionary alloc] init];
    }
    return _highModuleConfig;
}
- (NSMutableDictionary *)whenUseModuleConfig{
    if(!_whenUseModuleConfig){
        _whenUseModuleConfig = [[NSMutableDictionary alloc] init];
    }
    return _whenUseModuleConfig;
}
- (NSMutableDictionary *)installedModule{
    if(!_installedModule){
        _installedModule = [[NSMutableDictionary alloc] init];
    }
    return _installedModule;
}
@end

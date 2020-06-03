//
//  TestVC.m
//  DBModuleManage
//
//  Created by dengbinOld on 2020/6/3.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "TestVC.h"
#import "DBModuleManager.h"
#import "DBUIModule.h"
#import "MessageBusManager.h"
@interface TestVC ()
@property (nonatomic, strong) DBModuleManager *moduleManage;
@property (nonatomic, strong) MessageBusManager *messageBusManager;

@end

@implementation TestVC
- (instancetype)init
{
    self = [super init];
    if (self) {
            self.moduleManage = [[DBModuleManager alloc] init];
           
           self.messageBusManager = [[MessageBusManager alloc] init];
           
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    
    
    {
        DBModuleConfig *config = [[DBModuleConfig alloc] init];
        config.className =@"DBUIModule";
        config.idenfiter = @"DBModuleUI";
        config.priority = DBModulePriorityNormal;
        config.messages = @[];
        [self.moduleManage registerModule:config];
    }
    
    {
        DBModuleConfig *config = [[DBModuleConfig alloc] init];
        config.className =@"DBTestModule";
        config.idenfiter = @"DBModuleTest";
        config.priority = DBModulePriorityWhenUse;
        config.messages = @[@"hhh"];
        [self.moduleManage registerModule:config];
    }
    
    
    
    
    
    
    self.moduleManage.viewController = self;
    self.moduleManage.messageBusManager = self.messageBusManager;
    self.messageBusManager.moduleManager = self.moduleManage;
    [self.moduleManage installModule];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.moduleManage uninstallModule];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

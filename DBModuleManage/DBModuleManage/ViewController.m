//
//  ViewController.m
//  DBModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "ViewController.h"
#import "DBModuleManage.h"
#import "DBUIModule.h"
#import "MessageBusManager.h"
@interface ViewController ()
@property (nonatomic, strong) DBModuleManage *moduleManage;
@property (nonatomic, strong) MessageBusManager *messageBusManager;

@end

@implementation ViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         self.moduleManage = [[DBModuleManage alloc] init];
           self.moduleManage.viewController = self;
        
        self.messageBusManager = [[MessageBusManager alloc] init];
        
        DBModuleConfig *config = [[DBModuleConfig alloc] init];
        config.className =@"DBUIModule";
        config.idenfiter = @"DBModuleUI";
        config.priority = DBModulePriorityWhenUse;
        config.messages = @[@"hhh"];
        [self.moduleManage registerModule:config];
 

        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.messageBusManager postMessageWithMessageName:@"hhh"];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.moduleManage.messageBusManager = self.messageBusManager;
    self.messageBusManager.moduleManager = self.moduleManage;
    [self.moduleManage installModule];

    // Do any additional setup after loading the view.
}


@end

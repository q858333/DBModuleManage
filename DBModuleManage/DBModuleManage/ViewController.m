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
@interface ViewController ()
@property (nonatomic, strong) DBModuleManage *moduleManage;
@end

@implementation ViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         self.moduleManage = [[DBModuleManage alloc] init];
           self.moduleManage.viewController = self;
        
        
        
        DBModuleConfig *config = [[DBModuleConfig alloc] init];
        config.className =@"DBUIModule";
        config.idenfiter = @"DBModuleUI";
        config.priority = DBModulePriorityNormal;
        [self.moduleManage registerModule:config];
 
        
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.moduleManage installModule];
    
    // Do any additional setup after loading the view.
}


@end

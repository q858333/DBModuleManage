//
//  ViewController.m
//  DBModuleManage
//
//  Created by dengbinOld on 2020/6/1.
//  Copyright © 2020 dengsir. All rights reserved.
//

#import "ViewController.h"

#import "TestVC.h"
@interface ViewController ()

@end

@implementation ViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {

 

        
    }
    return self;
}
- (IBAction)btnClick:(id)sender{
    TestVC *vc = [[TestVC alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];

    
}



- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view.
}



@end

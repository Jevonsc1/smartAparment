//
//  SATakeoutFinish.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/16.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SATakeoutFinish.h"

@interface SATakeoutFinish ()

@end

@implementation SATakeoutFinish

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)backHomeVC:(id)sender {
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    
    if(index>3){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-3)] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)backMasterBank:(id)sender {
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    
    if(index>2){
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end

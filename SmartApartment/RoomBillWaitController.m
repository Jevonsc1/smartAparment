//
//  RoomBillWaitController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RoomBillWaitController.h"

@interface RoomBillWaitController ()

@end

@implementation RoomBillWaitController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickToSure:( id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"payBillSureEdit" object:nil];
    
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

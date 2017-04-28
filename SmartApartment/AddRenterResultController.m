//
//  AddRenterResultController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "AddRenterResultController.h"
//#import "AccessListController.h"
@interface AddRenterResultController ()

@end

@implementation AddRenterResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickToPop:(id)sender {
    if ([self.wayIn isEqualToString:@"renterList"]) {
        
//        [PopHome popToController:@"renterListController" andVC:self];
    }else{
//         [PopHome popToController:@"SignRoomOKController" andVC:self];
    }
}
- (IBAction)clickToAddAgain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickToRoomList:(id)sender {
    if ([self.wayIn isEqualToString:@"renterList"]) {
//         [PopHome popToController:@"renterListController" andVC:self];
    }else{
//        AccessListController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"AccessList"];
//        
//        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

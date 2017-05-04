//
//  SAcreathouseFinishEditViewController.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/19.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAcreathouseFinishEditViewController.h"

@interface SAcreathouseFinishEditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *depositMoney;

@property (weak, nonatomic) IBOutlet UITextField *rentMoney;
@end

@implementation SAcreathouseFinishEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.house.houseNum.stringValue;
    self.depositMoney.text = self.house.houseRequestRentDeposit;
    self.rentMoney.text = self.house.houseMonthRent;
}


- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishEdit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.TDPersonMyDataDetailViewControllerBlock) {
        self.house.houseMonthRent = self.rentMoney.text;
        self.house.houseRequestRentDeposit = self.depositMoney.text;
        self.TDPersonMyDataDetailViewControllerBlock(self.house);
    }
}

@end

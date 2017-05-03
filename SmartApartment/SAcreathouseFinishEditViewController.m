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
    self.title=self.homeNum;
    self.depositMoney.text=self.depositMoneyString;
    self.rentMoney.text=self.rentMoneyString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishEdit:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (self.TDPersonMyDataDetailViewControllerBlock) {
        self.TDPersonMyDataDetailViewControllerBlock(self.rentMoney.text,self.depositMoney.text);
    }
}

@end

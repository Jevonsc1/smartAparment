//
//  ForNavigationController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "ForNavigationController.h"
#import "AuthtionSureController.h"
@interface ForNavigationController ()

@end

@implementation ForNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"实名认证"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"passImage"]) {
        AuthtionSureController *vc = [segue destinationViewController];
        vc.imageDic = self.imageDic;
        vc.renterType = self.renterType;
        vc.idName = self.idName;
        vc.idnumber = self.idNumber;
        vc.mutDictionary = self.mutDictionary;
    }
}
- (IBAction)clickToPoP:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

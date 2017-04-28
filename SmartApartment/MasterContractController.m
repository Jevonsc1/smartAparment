//
//  MasterContractController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "MasterContractController.h"

@interface MasterContractController ()
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation MasterContractController

- (void)viewDidLoad {
    [super viewDidLoad];
    float scale = self.view.frame.size.width/320.0;
    self.content.font = [UIFont systemFontOfSize:10.0*scale];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

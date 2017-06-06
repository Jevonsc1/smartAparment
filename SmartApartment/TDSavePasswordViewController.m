//
//  TDSavePasswordViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDSavePasswordViewController.h"

@interface TDSavePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telecomPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation TDSavePasswordViewController

- (void)submitTelecomPassword {
    if (!_orderID) {
        NSLog(@"没有传入（orderID）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"orderID":_orderID,
                                 @"telecomPassword":[_telecomPasswordTextField text],
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband submitTelecomPassword:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWayIn" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (IBAction)touchUpInside:(UIButton *)button {
    
    if (button == _saveButton) {
        if ([[_telecomPasswordTextField text] isEqualToString:@""]) {
            return;
        }
        
        [self submitTelecomPassword];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"设置宽带密码"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//
//  TDOrderHistoryInfoViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDOrderHistoryInfoViewController.h"

@interface TDOrderHistoryInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *orderSNLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomServiceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@end

@implementation TDOrderHistoryInfoViewController

- (void)loadHistoryOrderInfoDetail {
    if (!_orderID) {
        NSLog(@"没有传入（orderID）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"orderID":_orderID,
                                 @"version":@"2.0"};
    [WebAPIForBroadband loadHistoryOrderInfoDetail:dictionary callback:^(NSError *err, id response) {
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            NSLog(@"%@",result);
            //[result createPropertyCode];
            [self reloadData:result];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (void)reloadData:(NSDictionary *)dictionary {
    if (dictionary) {
        [_orderSNLabel setText:[dictionary stringForKey:@"orderSN"]];
        [_telecomNameLabel setText:[dictionary stringForKey:@"telecomName"]];
        [_telecomServiceDescLabel setText:[dictionary stringForKey:@"telecomServiceDesc"]];
        [_orderPricesLabel setText:[dictionary RMBForKey:@"orderPrices"]];
        [_orderPricesDescriptionLabel setText:[NSString stringWithFormat:@"含%@初装费和%@预存费",[dictionary RMBForKey:@"telecomInstallationFees"],[dictionary RMBForKey:@"telecomAdvancedPayment"]]];
        
        switch ([dictionary intForKey:@"orderState"]) {
            case 0:
            {
                [_orderStateLabel setText:@"已预约"];
            }
                break;
            case 10:
            {
                [_orderStateLabel setText:@"已支付"];
            }
                break;
            case 20:
            {
                [_orderStateLabel setText:@"已完成"];
            }
                break;
            case 30:
            {
                [_orderStateLabel setText:@"已取消"];
            }
                break;
            case 40:
            {
                [_orderStateLabel setText:@"默认"];
            }
                break;
            default:
                break;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的宽带"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHistoryOrderInfoDetail];
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

//
//  TDOrderInfoViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDOrderInfoViewController.h"
#import "TDOrderHistoryListViewController.h"
#import "HMSegmentedControl.h"

@interface TDOrderInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UILabel *orderSNLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPricesDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *telecomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageHandleInstructionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *packageDescriptionWebView;
@property (weak, nonatomic) IBOutlet UIWebView *packageHandleInstructionWebView;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelTheAppointmentButton;

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@end

@implementation TDOrderInfoViewController

- (void)showAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"工作人员将尽快联系您，是否仍然要取消本次预约？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"继续等待" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确认取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self telecomCancelTheAppointment];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)leftBarButtonItem:(UIBarButtonItem *)item {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)telecomCancelTheAppointment {
    if (!_dictionary) {
        NSLog(@"缺少参数（dictionary）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"orderID":[_dictionary stringForKey:@"orderID"],
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband telecomCancelTheAppointment:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            [_orderStateLabel setText:@"已取消"];
            [_cancelTheAppointmentButton setHidden:YES];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (void)updateForUI {
    if (_dictionary) {
        [_orderSNLabel setText:[_dictionary stringForKey:@"orderSN"]];
        [_orderPricesLabel setText:[_dictionary RMBForKey:@"orderPrices"]];
        [_orderPricesDescriptionLabel setText:[NSString stringWithFormat:@"含%@初装费和%@预存费",[_dictionary RMBForKey:@"telecomInstallationFees"],[_dictionary RMBForKey:@"telecomAdvancedPayment"]]];
        [_packageDescriptionLabel setText:[_dictionary stringForKey:@"telecomServiceDesc"]];
        [_packageHandleInstructionLabel setText:[_dictionary stringForKey:@"telecomHandleInstruction"]];
        
        [_packageDescriptionWebView setScalesPageToFit:YES];
        [_packageDescriptionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_dictionary stringForKey:@"telecomServiceDescURL"]]]];
        [_packageHandleInstructionWebView setScalesPageToFit:YES];
        [_packageHandleInstructionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_dictionary stringForKey:@"telecomHandleInstructionURL"]]]];
        
        switch ([_dictionary intForKey:@"orderState"]) {
            case 0:
            {
                [_orderStateLabel setText:@"已预约"];
                [_cancelTheAppointmentButton setHidden:NO];
            }
                break;
            case 10:
            {
                [_orderStateLabel setText:@"已支付"];
                //[_orderStateLabel setText:@"处理中"];
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

- (IBAction)touchUpInside:(UIButton *)button {
    
    if (button == _cancelTheAppointmentButton) {
        [self showAlertController];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    switch ([segmentedControl selectedSegmentIndex]) {
        case 0:
        {
            [self.view bringSubviewToFront:_firstView];
        }
            break;
        case 1:
        {
            [self.view bringSubviewToFront:_secondView];
        }
            break;
        case 2:
        {
            [self.view bringSubviewToFront:_thirdView];
        }
        default:
            break;
    }
}

- (void)setupHMSegmentedControl {
    _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"套餐办理", @"套餐内容", @"办理须知"]];
    _segmentedControl.frame = CGRectMake(0, 64, SCREEN_WIDTH, 44);
    _segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _segmentedControl.selectionIndicatorHeight = 4.0f;
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:46/255.0 green:125/255.0 blue:225/255.0 alpha:1.0];
    //_segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.verticalDividerEnabled = YES;
    _segmentedControl.verticalDividerColor = RGB(223, 223, 223);
    _segmentedControl.verticalDividerWidth = 1.0f;
    [_segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        
        
        if (selected) {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1.0],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
            return attString;
        }else {
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : TDRGB(102, 102, 102),NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
            return attString;
        }
        
    }];
    [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

- (void)rightBarButtonItem:(UIBarButtonItem *)item {
    TDOrderHistoryListViewController *controller = [[TDOrderHistoryListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的宽带"];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"历史订单"style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem:)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*ratio],NSFontAttributeName, nil] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navgation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItem:)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self setupHMSegmentedControl];
    
    [_cancelTheAppointmentButton cornerRadius:7 color:[UIColor lightGrayColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateForUI];
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

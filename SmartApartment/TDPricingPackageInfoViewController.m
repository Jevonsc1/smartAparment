//
//  TDPricingPackageInfoViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/23.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDPricingPackageInfoViewController.h"
#import "TDPerfectOrderViewController.h"
#import "HMSegmentedControl.h"

@interface TDPricingPackageInfoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagePricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageInstallationFeesLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageAdvancedPaymentLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageHandleInstructionLabel;
@property (weak, nonatomic) IBOutlet UIWebView *packageDescriptionWebView;
@property (weak, nonatomic) IBOutlet UIWebView *packageHandleInstructionWebView;
@property (weak, nonatomic) IBOutlet UILabel *packageTipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *eligiblyOneButton;
@property (weak, nonatomic) IBOutlet UIButton *eligiblyTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *eligiblyThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *eligiblyFourButton;
@property (weak, nonatomic) IBOutlet UIButton *eligiblyCustomButton;
@property (weak, nonatomic) IBOutlet UILabel *totalCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextStepButton;

@property (strong, nonatomic) HMSegmentedControl *segmentedControl;
@property (assign, nonatomic) double telecomPrices;
@property (assign, nonatomic) double installationFees;
@property (assign, nonatomic) double advancedPaymentMin;
@property (assign, nonatomic) double advancedPaymentCurrent;
@property(assign,nonatomic)BOOL hadSelectMoney;

//自定义框
@property (weak, nonatomic) IBOutlet UIView *selfView;
@property (weak, nonatomic) IBOutlet UITextField *selfDayTexr;

@end

@implementation TDPricingPackageInfoViewController

- (void)loadTelecomOrderInfoDetail {
    if (!_telecomID) {
        NSLog(@"没有传入（telecomID）");
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"telecomID":_telecomID,
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband loadTelecomInfoDetail:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            NSLog(@"%@",result);
           
            [self reloadData:result];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (void)reloadData:(NSDictionary *)dictionary {
    if (dictionary) {
        [_packageNameLabel setText:[dictionary stringForKey:@"telecomName"]];
        [_packagePricesLabel setText:[NSString stringWithFormat:@"%@/%@",[dictionary RMBForKey:@"telecomPrices"],[dictionary stringForKey:@"telecomPricesPeriod"]]];
        [_packageInstallationFeesLabel setText:[dictionary RMBForKey:@"telecomInstallationFees"]];
        
//        [_packageAdvancedPaymentLabel setText:[dictionary RMBForKey:@"telecomAdvancedPaymentMin"]];
        [_packageTipsLabel setText:[NSString stringWithFormat:@"开通首月按天计费，次月开始%@/%@\n预存金额不得低于%@",[dictionary RMBForKey:@"telecomPrices"],[dictionary stringForKey:@"telecomPricesPeriod"],[dictionary RMBForKey:@"telecomAdvancedPaymentMin"]]];
        
        _installationFees = [dictionary doubleForKey:@"telecomInstallationFees"];
        _telecomPrices = [dictionary doubleForKey:@"telecomPrices"];
        _advancedPaymentMin = [dictionary doubleForKey:@"telecomAdvancedPaymentMin"];
        _advancedPaymentCurrent = _advancedPaymentMin;
        
        NSArray *array = [dictionary arrayForKey:@"telecomAdvancedPaymentEligibly"];
        if ([array count] > 0) {
            [_eligiblyOneButton setTitle:[array RMBAtIndex:0] forState:UIControlStateNormal];
            //默认选择第一个按钮
            _advancedPaymentCurrent = [array doubleAtIndex:0];
             [_packageAdvancedPaymentLabel setText:[array RMBAtIndex:0]];
            [self btnSelected:_eligiblyOneButton];
            _hadSelectMoney = YES;
        }
        if ([array count] > 1) {
            [_eligiblyTwoButton setTitle:[array RMBAtIndex:1] forState:UIControlStateNormal];
        }
        if ([array count] > 2) {
            [_eligiblyThreeButton setTitle:[array RMBAtIndex:2] forState:UIControlStateNormal];
        }
        if ([array count] > 3) {
            [_eligiblyFourButton setTitle:[array RMBAtIndex:3] forState:UIControlStateNormal];
        }
        
        [_totalCostLabel setText:[NSString stringWithFormat:@"%.2f元",fmax(_telecomPrices,_installationFees+_advancedPaymentCurrent)]];
        [_packageDescriptionLabel setText:[dictionary stringForKey:@"telecomServiceDesc"]];
        [_packageHandleInstructionLabel setText:[dictionary stringForKey:@"telecomHandleInstruction"]];
        
        [_packageDescriptionWebView setScalesPageToFit:YES];
        [_packageDescriptionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary stringForKey:@"telecomServiceDescURL"]]]];
        [_packageHandleInstructionWebView setScalesPageToFit:YES];
        [_packageHandleInstructionWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dictionary stringForKey:@"telecomHandleInstructionURL"]]]];
    }
}

- (void)showAlertController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"自定义预存费用" message:nil preferredStyle:UIAlertControllerStyleAlert];

    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakAlert.textFields.firstObject resignFirstResponder];
        if ([[weakAlert.textFields.firstObject text] doubleValue] >= _advancedPaymentMin) {
            
            [self btnNormal];
            [self btnSelected:_eligiblyCustomButton];
            
            NSString *custom = [NSString stringWithFormat:@"%@元",[weakAlert.textFields.firstObject text]];
            //[_eligiblyCustomButton setTitle:custom forState:UIControlStateNormal];
            [_packageAdvancedPaymentLabel setText:custom];
            _advancedPaymentCurrent = [[weakAlert.textFields.firstObject text] doubleValue];
            [_totalCostLabel setText:[NSString stringWithFormat:@"%.2f元",fmax(_telecomPrices,_installationFees+_advancedPaymentCurrent)]];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [weakAlert.textFields.firstObject resignFirstResponder];
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textColor = [UIColor lightGrayColor];
        textField.placeholder = [NSString stringWithFormat:@"不得小于%.2f元",_advancedPaymentMin];
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)touchUpInside:(UIButton *)button {
    
    switch (button.tag) {
        case eligiblyCustom:
        {
            if (_advancedPaymentMin != -1) {
                [self showAlertController];
            }
        }
            break;
        case nextStep:
        {
            if (_hadSelectMoney) {
                if (_advancedPaymentCurrent<_advancedPaymentMin) {
                    [Alert showFail:[NSString stringWithFormat:@"预存金额不能少于%.2f元",_advancedPaymentMin] View:self.view andTime:1.5 complete:nil];
                    return;
                }
                TDPerfectOrderViewController *controller = [[TDPerfectOrderViewController alloc] init];
                controller.telecomID = _telecomID;
                controller.telecomInstallationFees = [NSString stringWithFormat:@"%.2f",_installationFees];
                controller.telecomAdvancedPayment = [NSString stringWithFormat:@"%.2f",_advancedPaymentCurrent];;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [Alert showFail:@"请选择预存费用" View:self.view andTime:1.5 complete:nil];
            }
        }
            break;
        default:
        {
            [self btnNormal];
            [self btnSelected:button];
            _hadSelectMoney = YES;
            [_packageAdvancedPaymentLabel setText:[button currentTitle]];
            _advancedPaymentCurrent = [[[button currentTitle] stringByReplacingOccurrencesOfString:@"元" withString:@""] integerValue];
            [_totalCostLabel setText:[NSString stringWithFormat:@"%.2f元",fmax(_telecomPrices,_installationFees+_advancedPaymentCurrent)]];
        }
            break;
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
    //_segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
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

- (void)btnNormal {
    [_eligiblyOneButton setBackgroundColor:RGB(235, 235, 235)];
    [_eligiblyTwoButton setBackgroundColor:RGB(235, 235, 235)];
    [_eligiblyThreeButton setBackgroundColor:RGB(235, 235, 235)];
    [_eligiblyFourButton setBackgroundColor:RGB(235, 235, 235)];
    [_eligiblyCustomButton setBackgroundColor:RGB(235, 235, 235)];
    
    [_eligiblyOneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eligiblyTwoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eligiblyThreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eligiblyFourButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_eligiblyCustomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_eligiblyOneButton cornerRadius];
    [_eligiblyTwoButton cornerRadius];
    [_eligiblyThreeButton cornerRadius];
    [_eligiblyFourButton cornerRadius];
    [_eligiblyCustomButton cornerRadius];
}

- (void)btnSelected:(UIButton *)button {
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:TDRGB(46, 126, 224) forState:UIControlStateNormal];
    [button cornerRadius:7 color:TDRGB(46, 126, 224)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"套餐详情"];
    
    [_eligiblyOneButton setTag:eligiblyOne];
    [_eligiblyTwoButton setTag:eligiblyTwo];
    [_eligiblyThreeButton setTag:eligiblyThree];
    [_eligiblyFourButton setTag:eligiblyFour];
    [_eligiblyCustomButton setTag:eligiblyCustom];
    [_nextStepButton setTag:nextStep];
    
    _hadSelectMoney = NO;
    [_nextStepButton cornerRadius];
    
    [self btnNormal];
    
    [self setupHMSegmentedControl];
    
    [self loadTelecomOrderInfoDetail];
    
    _selfDayTexr.keyboardType = UIKeyboardTypeDecimalPad;
    _selfDayTexr.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //NSString *custom = [NSString stringWithFormat:@"%.2f",_advancedPaymentCurrent];
    //[_packageAdvancedPaymentLabel setText:custom];
    //_advancedPaymentCurrent = [_selfDayTexr.text doubleValue];
    [_totalCostLabel setText:[NSString stringWithFormat:@"%.2f元",fmax(_telecomPrices,_installationFees+_advancedPaymentCurrent)]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 点击View区域隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    _hadSelectMoney = YES;
    [self btnNormal];
    [self btnSelected:_eligiblyCustomButton];
    NSString *custom = [NSString stringWithFormat:@"%@元",[_selfDayTexr text]];
    [_packageAdvancedPaymentLabel setText:custom];
    _advancedPaymentCurrent = [_selfDayTexr.text doubleValue];
    [_totalCostLabel setText:[NSString stringWithFormat:@"%.2f元",fmax(_telecomPrices,_installationFees+_advancedPaymentCurrent)]];
    
    
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length == 0)
        return YES;
    
    if ([string isEqualToString:@"."]) {
        if ([textField.text rangeOfString:@"."].location != NSNotFound) {
            return NO;
        }else {
            return YES;
        }
    }
    
    int asciiCode = [string characterAtIndex:0];
    if (asciiCode >= 48 && asciiCode <= 57) {
        return YES;
    }
    else {
        return NO;
    }
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

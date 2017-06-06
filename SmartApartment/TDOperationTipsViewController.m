//
//  TDOperationTipsViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/24.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDOperationTipsViewController.h"
#import "AuthtionFirstController.h"
#import "TDOrderInfoViewController.h"
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>
#import <AlipaySDK/AlipaySDK.h>
#import "payView.h"
#import "AuthtionResultController.h"
@interface TDOperationTipsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tipsImageView;
@property (weak, nonatomic) IBOutlet UILabel *tipsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end

@implementation TDOperationTipsViewController
{

}
- (IBAction)touchUpInside:(UIButton *)button {
    NSMutableDictionary *mutDictionary = [[NSMutableDictionary alloc] initWithDictionary:_dictionary];
    
    // 已支付
    if (_operationTips == OnlinePaymentSuccess || _operationTips == OnlinePaymentSuccess_Aut) {
        [mutDictionary setObject:@"10" forKey:@"orderState"];
    }
    // 已预约
    if (_operationTips == MakeAnAppointmentSuccess || _operationTips == MakeAnAppointmentSuccess_Aut) {
        [mutDictionary setObject:@"0" forKey:@"orderState"];
    }
    if ([[button currentTitle] isEqualToString:@"返回订单详情"]) {
        
        if (_dictionary) {
            NSMutableDictionary *mutDictionary = [[NSMutableDictionary alloc] initWithDictionary:_dictionary];
            
            // 已支付
            if (_operationTips == OnlinePaymentSuccess || _operationTips == OnlinePaymentSuccess_Aut) {
                [mutDictionary setObject:@"10" forKey:@"orderState"];
            }
            // 已预约
            if (_operationTips == MakeAnAppointmentSuccess || _operationTips == MakeAnAppointmentSuccess_Aut) {
                [mutDictionary setObject:@"0" forKey:@"orderState"];
            }
            
            TDOrderInfoViewController *controller = [[TDOrderInfoViewController alloc] init];
            controller.dictionary = mutDictionary;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    if ([[button currentTitle] isEqualToString:@"重新支付"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([[button currentTitle] isEqualToString:@"去认证"]) {
        UserData *data = [ModelTool find_UserData];
        [[NSUserDefaults standardUserDefaults] setObject:@"您的认证资料已经提交，请等待工作人员安装开通宽带。" forKey:@"IDMsg"];
        if (data.boStatus == 10 || [data.renterStatus isEqualToString:@"10"]) {
            AuthtionResultController *vc =  [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
            vc.resultType = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            AuthtionFirstController *controller = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
            controller.mutDictionary = mutDictionary;
            controller.renterType = data.memberType;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (void)updateForUI {
    [_firstButton cornerRadius];
    [_secondButton cornerRadius:7 color:[UIColor lightGrayColor]];
    
    switch (_operationTips) {
        case OnlinePaymentSuccess:
        {
            [self setTitle:@"在线支付"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureOk"]];
            [_tipsTitleLabel setText:@"支付成功"];
            [_tipsTitleLabel setTextColor:[UIColor colorWithRed:126/255.0 green:195/255.0 blue:105/255.0 alpha:1.0]];
            [_tipsMsgLabel setText:@"工作人员稍后会与您联系，请注意接听来电"];
            [_firstButton setTitle:@"返回订单详情" forState:UIControlStateNormal];
            [_secondButton setHidden:YES];
        }
            break;
        case OnlinePaymentSuccess_Aut:
        {
            [self setTitle:@"在线支付"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureOk"]];
            [_tipsTitleLabel setText:@"支付成功"];
            [_tipsTitleLabel setTextColor:[UIColor colorWithRed:126/255.0 green:195/255.0 blue:105/255.0 alpha:1.0]];
            [_tipsMsgLabel setText:@"请提交实名认证信息\n通过实名认证才能开通宽带服务\n工作人员稍后会与您联系，请注意接听来电"];
            [_firstButton setTitle:@"去认证" forState:UIControlStateNormal];
            [_secondButton setTitle:@"返回订单详情" forState:UIControlStateNormal];
        }
            break;
        case OnlinePaymentFailure:
        {
            [self setTitle:@"在线支付"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureBad"]];
            [_tipsTitleLabel setText:@"支付失败"];
            [_tipsTitleLabel setTextColor:[UIColor redColor]];
            [_tipsMsgLabel setText:@""];
            [_firstButton setTitle:@"重新支付" forState:UIControlStateNormal];
            [_secondButton setHidden:YES];
        }
            break;
        case MakeAnAppointmentSuccess:
        {
            [self setTitle:@"线下预约"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureOk"]];
            [_tipsTitleLabel setText:@"预约成功"];
            [_tipsTitleLabel setTextColor:[UIColor colorWithRed:126/255.0 green:195/255.0 blue:105/255.0 alpha:1.0]];
            [_tipsMsgLabel setText:@"工作人员稍后会与您联系，请注意接听来电"];
            [_firstButton setTitle:@"返回订单详情" forState:UIControlStateNormal];
            [_secondButton setHidden:YES];
        }
            break;
        case MakeAnAppointmentSuccess_Aut:
        {
            [self setTitle:@"线下预约"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureOk"]];
            [_tipsTitleLabel setText:@"预约成功"];
            [_tipsTitleLabel setTextColor:[UIColor colorWithRed:126/255.0 green:195/255.0 blue:105/255.0 alpha:1.0]];
            [_tipsMsgLabel setText:@"请提交实名认证信息\n通过实名认证才能开通宽带服务\n工作人员稍后会与您联系，请注意接听来电"];
            [_firstButton setTitle:@"去认证" forState:UIControlStateNormal];
            [_secondButton setTitle:@"返回订单详情" forState:UIControlStateNormal];
        }
            break;
        case MakeAnAppointmentFailure:
        {
            [self setTitle:@"线下预约"];
            [_tipsImageView setImage:[UIImage imageNamed:@"IDSureBad"]];
            [_tipsTitleLabel setText:@"预约失败"];
            [_tipsTitleLabel setTextColor:[UIColor redColor]];
            [_tipsMsgLabel setText:@""];
            [_firstButton setTitle:@"重新预约" forState:UIControlStateNormal];
            [_secondButton setHidden:YES];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:[[UIView alloc]initWithFrame:CGRectZero]];
    
    [self updateForUI];

    [self.view xibAutoLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

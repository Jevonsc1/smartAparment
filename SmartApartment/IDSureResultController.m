//
//  IDSureResultController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/26.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "IDSureResultController.h"
//#import "SelectIDController.h"
#import "MasterMyBankController.h"
#import "SelectPersonController.h"
#import "NewMasterHomeController.h"
@interface IDSureResultController ()
@property (weak, nonatomic) IBOutlet UIImageView *resultIcon;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIButton *resultBtn;
@property (weak, nonatomic) IBOutlet UILabel *failLabel;


@end

@implementation IDSureResultController
{
    UserData *userData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    userData = [ModelTool find_UserData];
    [self initView];

}

- (IBAction)clickToPop:(id)sender {
    
    
        NSArray * ctrlArray = self.navigationController.viewControllers;
        
        for (UIViewController *ctrl in ctrlArray) {
            if ([NSStringFromClass(ctrl.class) isEqualToString:@"NewMasterHomeController"]) {
                [self.navigationController popToViewController:ctrl animated:YES];
            }//SelectPersonController
            else if([NSStringFromClass(ctrl.class) isEqualToString:@"SelectPersonController"]){
                [self.navigationController popToViewController:ctrl animated:YES];
            }
            
            
        }
    
  
}
- (IBAction)clickToDo:(id)sender {
    if ([self.bankType isEqualToString:@"fail"]) {
        MasterMyBankController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMyBank"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if ([self.resultType isEqualToString:@"fail"]) {
//            SelectIDController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectID"];
//            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSArray * ctrlArray = self.navigationController.viewControllers;
            
            for (UIViewController *ctrl in ctrlArray) {
                if ([NSStringFromClass(ctrl.class) isEqualToString:@"NewMasterHomeController"]) {
                    [self.navigationController popToViewController:ctrl animated:YES];
                }   else if([NSStringFromClass(ctrl.class) isEqualToString:@"SelectPersonController"]){
                    [self.navigationController popToViewController:ctrl animated:YES];
                }
                
                
            }
        }
    }
}

#pragma mark -m 判断传入的数值,得出不同的结果界面
-(void)initView{
    self.failLabel.hidden = YES;
    [self.resultBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    if ([self.resultType isEqualToString:@"wait"]) {
        if ([self.bankType isEqualToString:@"wait"]) {
            self.title = @"银行卡认证";
        }
        if ([self.openNet isEqualToString:@"yes"]) {
            self.title = @"公寓宽带";
            [self.resultLabel setText:@"您已成功订购，3个工作日内电信人员会联系您..."];
        }else{
            [self.resultLabel setText:@"您已成功提交资料，请等待审核…"];
        }

        [self.resultIcon setImage:[UIImage imageNamed:@"IDSureWait"]];
        //108.176.241
        [self.resultLabel setTextColor:[UIColor colorWithRed:108.0/255.0 green:176.0/255.0 blue:241.0/255.0 alpha:1]];
               [self.tipsLabel setText:@"您可以进行以下操作"];
    }
    else if([self.resultType isEqualToString:@"pass"])
    {
        [self.resultIcon setImage:[UIImage imageNamed:@"IDSureOk"]];
        
        [self.resultLabel setTextColor:[UIColor colorWithRed:81.0/255.0 green:170.0/255.0 blue:54.0/255.0 alpha:1]];
        [self.resultLabel setText:@"您已通过审核！"];
        [self.tipsLabel setText:@"您可以进行以下操作"];
    }
    else{
        [self.resultIcon setImage:[UIImage imageNamed:@"IDSureBad"]];
        
        [self.resultLabel setTextColor:[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1]];
        [self.resultLabel setText:@"审核不通过!"];
        [self.tipsLabel setText:@"请点击以下按钮重新提交认证资料"];
        if (![self.bankType isEqualToString:@"fail"]) {
            self.title = @"实名认证";
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userData.memberPhone,@"userPhone",userData.key,@"key", nil];
            [WebAPI getMemberInfoByPhone:dic callback:^(NSError *err, id response) {
                if (!err ) {
                    if ([userData.memberType isEqualToString:@"master"]) {
                        self.failLabel.text = [[[response objectForKey:@"data"][0] objectForKey:@"bo"] objectForKey:@"boAuditSuggestion"];
                    }else if([userData.memberType isEqualToString:@"renter"]){
                        self.failLabel.text = [[[response objectForKey:@"data"][0] objectForKey:@"renter"] objectForKey:@"renterAuditSuggestion"];
                    }
                }
            }];
        }else{
            self.title = @"银行卡认证";
            self.failLabel.text = @"您的审核不通过!";
//            self.failLabel.text = self.boAuditSuggestion;
            
        }
        self.failLabel.hidden = NO;
        self.failLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        [self.resultBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    }
}

@end

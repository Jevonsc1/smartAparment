//
//  AuthtionResultController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AuthtionResultController.h"
#import "AuthtionFirstController.h"
#import "NewMasterHomeController.h"
#import "SelectPersonController.h"
#import "TDOperationTipsViewController.h"
#import "TDOrderInfoViewController.h"
@interface AuthtionResultController ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconAutoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconAutoWidth;

@end

@implementation AuthtionResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"实名认证"];
    [_iconAutoWidth setConstant:100*ratio];
    [_iconAutoHeight setConstant:100 *ratio];
    
    //IDSureBad -- IDSureOk --- IDSureWait
    switch (self.resultType) {
        case 1:
            //认证失败
            [self.icon setImage:[UIImage imageNamed:@"IDSureBad"]];
            [self.oneLabel setTextColor:TDRGB(229, 89, 89)];
            [self.oneLabel setText:@"审核不通过!"];
            [self.clickBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            break;
        case 2:
            //提交资料失败
            [self.icon setImage:[UIImage imageNamed:@"IDSureBad"]];
            [self.oneLabel setTextColor:TDRGB(229, 89, 89)];
            [self.oneLabel setText:@"提交失败!"];
            self.threeLabel.hidden = NO;
            [self.clickBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            self.twoLabel.text = self.errMsg;
            break;
        case 3:
            //提交成功 等待审核
            [self.icon setImage:[UIImage imageNamed:@"IDSureWait"]];
            [self.oneLabel setTextColor:TDRGB(108, 176, 241)];
            [self.oneLabel setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"IDMsg"]];
            self.twoLabel.hidden = YES;
            self.threeLabel.hidden = YES;
            [self.clickBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
        default:
            break;
    }
}
- (IBAction)clickToSure:(id)sender {
    if (self.resultType == 1) {
        //重新认证
        AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (self.resultType == 2){
        //提交资料失败
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *temArray = self.navigationController.viewControllers;
        
        for(UIViewController *temVC in temArray)
            
        {
            //跳转到主页
            if ([temVC isKindOfClass:[SelectPersonController class]])
                
            {
                [self.navigationController popToViewController:temVC animated:YES];
                break;
                
            }
            //跳转到宽带支付界面
            else if([temVC isKindOfClass:[TDOperationTipsViewController class]]){
                TDOrderInfoViewController *controller = [[TDOrderInfoViewController alloc] init];
                controller.dictionary = self.mutDictionary;
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
  
}




@end

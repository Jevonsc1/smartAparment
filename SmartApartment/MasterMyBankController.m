//
//  MasterMyBankController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "MasterMyBankController.h"
#import "BankListController.h"
@interface MasterMyBankController ()
@property (weak, nonatomic) IBOutlet UILabel *masterName;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *bankCardNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankNameAutoleading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconAutoWidth;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation MasterMyBankController
{
    
    NSArray *banks;
    UserData *userData;
    BOOL canSelect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    userData = [ModelTool find_UserData];
    [self.masterName setText:userData.trueName];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key", nil];
    canSelect  =YES;
    [WebAPI getBankCardInfo:dic callback:^(NSError *err, id response) {
        NSString *rcode = [response objectForKey:@"rcode"];
        if (!err && rcode.integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
            NSArray *bankArr = [[dic objectForKey:@"bo"] objectForKey:@"boBank"];
            
            if (bankArr.count == 0) {
                self.bankName.text = @"请选择";
                self.bankCardNum.enabled = YES;
                    canSelect  =YES;
            }else{
                NSDictionary *bankDic = bankArr[0];
                banks = bankArr;
                NSString *bankStatus = [bankDic objectForKey:@"bankStatus"];
                if ([[NSString stringWithFormat:@"%@",bankStatus] isEqualToString:@"0"]) {
                        canSelect  =YES;
                    self.bankName.text = @"请选择";
                    self.bankCardNum.enabled = YES;
                }else{
                    self.bankName.text = [bankDic objectForKey:@"bankName"];
                    self.bankCardNum.text = [bankDic objectForKey:@"bankNum"];
                    self.bankCardNum.enabled = YES;
                    [self.bankNameAutoleading setConstant:0];
                    [self.iconAutoWidth setConstant:0];
                    if ([self.changeBank isEqualToString:@"yes"]) {
                        self.sureBtn.hidden = NO;
                    [self.sureBtn setTitle:@"更换银行卡" forState:UIControlStateNormal];
                    }
                }
                
            }
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    NSString *bankName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bankName"];
    if(bankName.length >0){
        self.bankName.text = bankName;
    }
    
   
    
    
}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -m 认证银行卡
- (IBAction)clickToSureBankCard:(id)sender {
    if (self.bankCardNum.text.length<= 0) {
        [Alert showFail:@"请输入银行卡号!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
            
        }];
        return;
    }
    if ([self.bankName.text isEqualToString:@"请选择"]) {
        [Alert showFail:@"请选择开户行!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
            
        }];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:self.bankCardNum.text,@"boBankCard",userData.key,@"key",self.bankName.text,@"boBankName",nil];
    [WebAPI certificateMasterBankCard:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            
            [Alert showSucces:@"提交资料成功!" View:self.navigationController.navigationBar andTime:2.0f complete:^(BOOL isComplete) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
           
        }
        else{
            [Alert showFail:@"认证失败！" View:self.navigationController.navigationBar  andTime:1.5 complete:^(BOOL isComplete) {
            }];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 &&canSelect) {
        BankListController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"BankList"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

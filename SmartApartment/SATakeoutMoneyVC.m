//
//  SATakeoutMoneyVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/16.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SATakeoutMoneyVC.h"


#import "SATakeoutFinish.h"

@interface SATakeoutMoneyVC ()
@property (weak, nonatomic) IBOutlet UILabel *moenyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNum;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UITextField *takeOutMoneyTextField;
@end

@implementation SATakeoutMoneyVC
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.moenyLabel.text=[NSString stringWithFormat:@"待结算金额为%@元",self.money];
    self.bankName.text=self.bobankName;
    
    self.bankNum.text=[self formatBanknum];
    [self.navigationController setNavigationBarHidden:NO];
}

- (NSString *)formatBanknum{
    long long numLong = [self.bobankNum longLongValue];
    NSNumber *number = [NSNumber numberWithLongLong:numLong];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    return  [formatter stringFromNumber:number];
}

//-(NSString *)normalNumToBankNum
//{
//    NSString *tmpStr = [self bankNumToNormalNum];
//    
//    int size = (tmpStr.length / 4);
//    
//    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
//    for (int n = 0;n < size; n++)
//    {
//        [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(n*4, 4)]];
//    }
//    
//    [tmpStrArr addObject:[tmpStr substringWithRange:NSMakeRange(size*4, (tmpStr.length % 4))]];
//    
//    tmpStr = [tmpStrArr componentsJoinedByString:@" "];
//    
//    return tmpStr;
//}
//
//-(NSString *)bankNumToNormalNum
//{
//    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确认转出
- (IBAction)takeMoney:(id)sender {
    if (self.takeOutMoneyTextField.text.length==0) {
        [Alert showFail:@"请输入转出金额" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    [self requestApartmentList];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)requestApartmentList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]= [ModelTool find_UserData].key ;
    params[@"cashAmount"]=self.takeOutMoneyTextField.text;
    [WebAPIForRenthouse takeMoneyOut:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"]==10000) {
            SATakeoutFinish *vc = [[UIStoryboard storyboardWithName:@"moneyget" bundle:nil] instantiateViewControllerWithIdentifier:@"SATakeoutFinish"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NSString *string =[response objectForKey:@"rmsg"];
            if (string.length>0) {
                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            }
        }

    }];
}

@end

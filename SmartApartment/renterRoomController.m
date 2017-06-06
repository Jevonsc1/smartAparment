//
//  renterRoomController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "renterRoomController.h"
#import "renterPayController.h"
#import "RenterBillController.h"

@interface renterRoomController ()
@property (weak, nonatomic) IBOutlet UILabel *houseName;
@property (weak, nonatomic) IBOutlet UILabel *renterNum;
@property (weak, nonatomic) IBOutlet UILabel *renterMainName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *renterMoney;
@property (weak, nonatomic) IBOutlet UILabel *depositLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *payMoney;
@property (weak, nonatomic) IBOutlet UILabel *isHadPay;
@property (weak, nonatomic) IBOutlet UILabel *electric_unit_price;
@property (weak, nonatomic) IBOutlet UILabel *water_unit_price;
@property (weak, nonatomic) IBOutlet UITextField *other_charge_price;

@end

@implementation renterRoomController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated{
    __block renterRoomController *blockSelf = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key", @"2.0",@"version",nil];
    [WebAPI getRentRecordInfo:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            NSArray *dic = [response objectForKey:@"data"];
            if (dic.count != 0){
                NSDictionary *dataDic = dic[0];
                NSDictionary *houseInfo = [dataDic objectForKey:@"houseInfo"];
                NSString *houseID = [houseInfo objectForKey:@"houseID"];
                NSArray *renterInfo = [dataDic objectForKey:@"rentInfo"];
                blockSelf.houseName.text = [NSString stringWithFormat:@"%@",[houseInfo objectForKey:@"houseNum"]];
                blockSelf.renterNum.text = [NSString stringWithFormat:@"%lu人",(unsigned long)renterInfo.count];
                if (renterInfo.count <=0) {
                    [Alert showFail:@"没有租客信息！" View:self.view andTime:1.5 complete:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return;
                }
                for (int i = 0; i < renterInfo.count; i ++) {
                    NSDictionary *dic = renterInfo[0];
                    NSArray *renter = [dic objectForKey:@"renterInfo"];
                    for (int i = 0 ; i<renter.count; i++) {
                        NSDictionary *retPerson = renter[i];
                        NSString *roleID = [retPerson objectForKey:@"renterRoleID"];
                        if(roleID.integerValue == 1){
                            blockSelf.renterMainName.text = [retPerson objectForKey:@"renterTrueName"];
                            blockSelf.depositLabel.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"rentDeposit"]];
                            blockSelf.startTime.text = [self timeWithTimeIntervalString:[dic objectForKey:@"rentTime"]];
                            blockSelf.endTime.text = [self timeWithTimeIntervalString:[dic objectForKey:@"rentDueTime"]];
                            blockSelf.payTime.text = [NSString stringWithFormat:@"%@号",[dic objectForKey:@"payDateMonth"]];
                            blockSelf.renterMoney.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"monthRent"]];
                            
                            blockSelf.electric_unit_price.text = [dic objectForKey:@"electricUnitPrice"];
                            blockSelf.water_unit_price.text = [dic objectForKey:@"waterUnitPrice"];
                            blockSelf.other_charge_price.text= [dic objectForKey:@"otherChargePrice"];
                            blockSelf.other_charge_price.font = [UIFont systemFontOfSize:16];
                        }
                    }
                    
                }
                blockSelf.address.text = [houseInfo objectForKey:@"houseAddress"];
                NSDate *currentDate = [NSDate date];//获取当前时间，日期
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"YYYYMM"];
                NSString *dateString = [dateFormatter stringFromDate:currentDate];
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",houseID,@"houseID", dateString,@"monthDate",nil];
                [WebAPI getHouseBillList:dic callback:^(NSError *err, id response) {
                    if(!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000){
                        ;
                        NSDictionary *billDic =[[response objectForKey:@"data"] objectForKey:@"billInfo"];
                        if (billDic.count>0) {
                            NSDictionary *eleBillDic =[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"electricBill"];
                            NSString *eleBill;
                            if (eleBillDic.count>0) {
                                eleBill = [NSString stringWithFormat:@"%@",[[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"electricBill"] objectForKey:@"orderGoodsAmount"]];
                            }
                            NSDictionary *waterBillDic =[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"waterBill"];
                            NSString *waterBill;
                            if (waterBillDic.count>0) {
                                waterBill = [NSString stringWithFormat:@"%@",[[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"waterBill"] objectForKey:@"orderGoodsAmount"]];
                            }
                            NSDictionary *rentBillDic =[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"rentBill"];
                            NSString *rentBill ;
                            if (rentBillDic.count>0) {
                                rentBill = [NSString stringWithFormat:@"%@",[[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"rentBill"] objectForKey:@"orderGoodsAmount"]];
                            }
                            NSDictionary *otherBillDic =[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"otherBill"];
                            NSString *otherBill;
                            if (otherBillDic.count>0) {
                                otherBill = [NSString stringWithFormat:@"%@",[[[[response objectForKey:@"data"] objectForKey:@"billInfo"] objectForKey:@"otherBill"] objectForKey:@"orderGoodsAmount"]];
                            }
                            self.payMoney.text = [NSString stringWithFormat:@"本期费用%.2f",eleBill.floatValue+waterBill.floatValue+rentBill.floatValue+otherBill.floatValue];
                            NSString *orderState = [NSString stringWithFormat:@"%@",[[[[response objectForKey:@"data"]objectForKey:@"billInfo"] objectForKey:@"rentBill"] objectForKey:@"orderState"]];
                            NSInteger orderNum = orderState.integerValue;
                            if( orderState.integerValue !=10 &&orderNum != 0){
                                self.isHadPay.text =@"(已缴)";
                                [self.isHadPay setTextColor:[UIColor colorWithRed:81.0/255.0 green:170.0/255.0 blue:54.0/255.0 alpha:1]];
                            }else{
                                self.isHadPay.text =@"(未缴)";
                                [self.isHadPay setTextColor:[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1]];
                            }
                            
                            
                        }
                    }else{
                        if(err){
                            [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:3 complete:nil];
                        }else{
                           RequestBad
                        }
                    }
                }];
            }
            else{
                [Alert showFail:@"暂无租房信息" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                }];
            }
            
        }
        else{
           RequestBad 
        }
    }];
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 3) {
//        renterPayController *vc = [[UIStoryboard storyboardWithName:@"Charges" bundle:nil] instantiateViewControllerWithIdentifier:@"renterPay"];
        RenterBillController *vc = [[UIStoryboard storyboardWithName:@"RenterBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterBill"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else if(section == 1){
        return 5;
    }else if(section == 2){
    return 3;
    }
    else{
        return 1;
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.1)];
        [view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        return view;
    }else{
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        [view setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
        oneline.backgroundColor = TDRGB(223, 223, 223);
        UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
        twoline.backgroundColor = TDRGB(223, 223, 223);
        
        
        
        //添加控件
        [view addSubview:oneline];
        [view addSubview:twoline];
        return view;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 20;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  cellHeight;
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
@end

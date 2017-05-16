//
//  RoomWaitEditController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RoomWaitEditController.h"
#import "WaitPayCell.h"
#import "CashPayCell.h"
#import "EditMoneyCell.h"
#import "SurplusMoneyCell.h"
#import "CashPayRecordCell.h"
#import "GlobalPass.h"
@interface RoomWaitEditController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *waitToPay;
@property (weak, nonatomic) IBOutlet UITextField *cashPay;
@property (weak, nonatomic) IBOutlet UITextField *editMoney;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation RoomWaitEditController
{
    NSArray *recordList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.cashPay.delegate = self;
    self.editMoney.delegate = self;
    
    //添加确认修改的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureToEdit:) name:@"payBillSureEdit" object:nil];
    
    self.house = [GlobalPass pass].apartmentBillHouse;
    self.waitToPay.text = [GlobalPass pass].allMoneyPay;

    float notPay = self.house.billInfo.payBillNotPay.floatValue;
    float freezyPay = self.house.billInfo.payBillFreezingPay.floatValue;
    self.resultLabel.text = [NSString stringWithFormat:@"¥%.2f",notPay + freezyPay];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key", self.house.billInfo.payBillID,@"payBillID",nil];
    [WebAPI getHousePayBillLog:dic callback:^(NSError *err, id response) {
        if ([NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000 && !err) {
            recordList = [response objectForKey:@"data"];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
   self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}
#pragma mark -m 点击增加变减号，点击减少变加号
- (IBAction)clickToChangeStatus:(UIButton *)sender {
    NSString * waitPay = self.house.billInfo.payBillNotPay;
    NSIndexPath *surIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    SurplusMoneyCell *surpCell = [self.tableView cellForRowAtIndexPath:surIndex];
    NSIndexPath *editIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    EditMoneyCell *editCell = [self.tableView cellForRowAtIndexPath:editIndex];
    NSString *editMoney = editCell.editMoney.text;
   
    NSIndexPath *cashIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    CashPayCell *cell = [self.tableView cellForRowAtIndexPath:cashIndex];
    if (sender.tag == 1) {
        sender.tag =2;
        [sender setTitle:@"减少" forState:UIControlStateNormal];
        editCell.editLabel.text = @"－¥ ";
        if (waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue <0) {
            surpCell.resultLabel.text = @"¥0";
            editCell.editMoney.text =[NSString stringWithFormat:@"%.2f",waitPay.floatValue - cell.cashPay.text.floatValue];
        }
        else{
              surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue];
        }
    }
    else{
        sender.tag = 1;
        [sender setTitle:@"增加" forState:UIControlStateNormal];
        editCell.editLabel.text = @"＋¥ ";
          surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue + editMoney.floatValue];
    }
}
///根据cell的输入框，调整tableview的contentOffset
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * waitPay = self.house.billInfo.payBillNotPay;
    NSIndexPath *surIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    SurplusMoneyCell *surpCell = [self.tableView cellForRowAtIndexPath:surIndex];
    NSIndexPath *editIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    EditMoneyCell *editCell = [self.tableView cellForRowAtIndexPath:editIndex];
     NSString *editMoney = editCell.editMoney.text;
     self.editBtn = editCell.editBtn;
     NSIndexPath *cashIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    CashPayCell *cell = [self.tableView cellForRowAtIndexPath:cashIndex];
    if (textField.tag == 1) {
        
        if (waitPay.floatValue- cell.cashPay.text.floatValue -editMoney.floatValue <0) {
            cell.cashPay.text = [NSString stringWithFormat:@"%.2f",waitPay.floatValue];
            surpCell.resultLabel.text = @"¥0";
        }else{
            if (waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue <0) {
                surpCell.resultLabel.text = @"¥0";
                editCell.editMoney.text =[NSString stringWithFormat:@"%.2f",waitPay.floatValue - cell.cashPay.text.floatValue];
            }
            else{
                if (self.editBtn.tag == 1) {
                     surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue +  editMoney.floatValue];
                }else{
                     surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue];
                }
            }
            
        }
        
    }else{
        if (editCell.editBtn.tag == 1) {
                surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue + editMoney.floatValue];
        }else{
            if (waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue <0) {
                surpCell.resultLabel.text = @"¥0";
                editCell.editMoney.text =[NSString stringWithFormat:@"%.2f",waitPay.floatValue - cell.cashPay.text.floatValue];
            }
            else{
                if (self.editBtn.tag == 1) {
                    surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue +  editMoney.floatValue];
                }else{
                    surpCell.resultLabel.text =[NSString stringWithFormat:@"¥%.2f",waitPay.floatValue - cell.cashPay.text.floatValue -  editMoney.floatValue];
                }
            }
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else{
        return recordList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 60*ratio;
    }
    return 50*ratio;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0 && indexPath.row == 0) {
        WaitPayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"WaitPayCell"];
        cell.waitToPay.text =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"allMoneyPay"]];
        cell.waitToPay.text = [NSString stringWithFormat:@"¥%@",[cell.waitToPay.text substringToIndex:cell.waitToPay.text.length-1]];
        return cell;
    }else if (indexPath.section == 1 &&indexPath.row == 0){
        CashPayCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CashPayCell"];
        cell.cashPay.delegate = self;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1){
        EditMoneyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditMoneyCell"];
        [cell.editBtn addTarget:self action:@selector(clickToChangeStatus:) forControlEvents:UIControlEventTouchUpInside];
        cell.editBtn.tag = 1;
        cell.editMoney.delegate = self;
        return cell;
    }else if(indexPath.section == 2 && indexPath.row == 0){
        SurplusMoneyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SurplusMoneyCell"];
        float notPay = self.house.billInfo.payBillNotPay.floatValue;
        float freezyPay = self.house.billInfo.payBillFreezingPay.floatValue;
        cell.resultLabel.text = [NSString stringWithFormat:@"¥%.2f",notPay + freezyPay];
        return cell;
    }else{
        CashPayRecordCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CashPayRecordCell"];
        NSDictionary *dic = recordList[indexPath.row];
        NSString *operationId = [dic objectForKey:@"payBillLogOperationID"];
        if (operationId.integerValue == 1) {
            cell.type.text = @"现金缴费";
        }else if(operationId.integerValue == 2){
            cell.type.text = @"线上缴费";
        }else if(operationId.integerValue == 3){
            cell.type.text = @"费用调整";
        }else {
            cell.type.text = @"账单调整为未缴状态";
        }
        cell.time.text = [TimeDate timeDetailWithTimeIntervalString:[dic objectForKey:@"payBillLogTime"]];
        cell.resultMoney.text = [NSString stringWithFormat:@"剩余金额¥%@",[dic objectForKey:@"payBillLogResidueMoney"]];
        cell.editMoney.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"payBillLogOperationMoney"]];
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"payBillLogOperationMoney"]].floatValue <0) {
            cell.editMoney.textColor =MainGreen;
        }else{
            cell.editMoney.textColor = MainRed;
        }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 7 *ratio, 17*ratio)];
    
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    label.text = @"电表";
    label.font = [UIFont systemFontOfSize:14*ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    
    
    if (section == 0) {
        label.text = @"待缴费用";
        smallView.backgroundColor = MainBlue;
    }else if(section == 1){
        label.text = @"已缴费用";
        smallView.backgroundColor = MainRed;
    }else if(section == 2){
        label.text = @"剩余待缴";
        smallView.backgroundColor = MainGreen;
    }else if(section == 3){
        label.text = @"费用调整记录";
        label.textAlignment = NSTextAlignmentCenter;
        smallView.backgroundColor = MainBlue;
    }
    
    
    if (section != 3) {
        //添加控件
        [view addSubview:oneline];
        [view addSubview:twoline];
        [view addSubview:smallView];
        [view addSubview:label];
        smallView.centerY = view.centerY;
        label.centerY = view.centerY;
        label.x = smallView.x+smallView.width+8;
    }else{
        [view addSubview:oneline];
        [view addSubview:twoline];
        [view addSubview:label];
        label.centerX = view.centerX;
    }
    
    return view;
}
//调整金额--在外面的控制器通过通知，调用方法
-(void)sureToEdit:(NSNotification *)info{
    NSDictionary *dic ;
    NSIndexPath *editIndex = [NSIndexPath indexPathForRow:1 inSection:1];
    EditMoneyCell *editCell = [self.tableView cellForRowAtIndexPath:editIndex];
    NSIndexPath *cashIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    CashPayCell *cell = [self.tableView cellForRowAtIndexPath:cashIndex];
    
    if (self.editBtn.tag == 1) {
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",self.house.billInfo.payBillID,@"payBillID",[NSString stringWithFormat:@"+%@",editCell.editMoney.text],@"payBillAmount",cell.cashPay.text,@"payBillCharges", nil];
    }else{
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",self.house.billInfo.payBillID,@"payBillID",[NSString stringWithFormat:@"-%@",editCell.editMoney.text],@"payBillAmount",cell.cashPay.text,@"payBillCharges", nil];
    }
    [WebAPI editHousePayBill:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            
            [Alert showFail:@"调整成功！" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getRoomData" object:nil];
                [PopHome popToController:@"ApartmentBillController" andVC:self];
            }];
            
            
//            NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[[self.roomDic objectForKey:@"billInfo"] objectForKey:@"payBillID"],@"payBillID", nil];
//            [WebAPI getHousePayBillLog:dic1 callback:^(NSError *err, id response) {
//                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]]) {
//                    recordList = [response objectForKey:@"data"];
//                }else{
//                    RequestBad
//                }
//            }];
        }else{
            RequestBad
        }
    }];
}


@end

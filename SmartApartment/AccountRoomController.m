//
//  AccountRoomController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccountRoomController.h"
#import "RoomOtherCell.h"
//#import "RenterBillHistoryController.h"
#import "RoomDianDetailController.h"
#import "MyDelegateDic.h"
#define textGray cell.cellContent.textColor = TDRGB(139, 139, 139);
#define textDark cell.cellContent.textColor = TDRGB(51, 51, 51);
@interface AccountRoomController ()<UITableViewDelegate,UITableViewDataSource,MyDelegateDic>
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@end

@implementation AccountRoomController
{
    NSDictionary *roomDic;
    UITapGestureRecognizer *tap;
    
    NSDictionary * billDic;
    BOOL currentBill;
    NSString *currentDate;
    
    NSString *houseID1;
    NSString *rentRecordID;
    
    NSDictionary *rentDic;
    NSDictionary *roomMoneyDic;//goodsInfo中的数据
    NSDictionary *electrictDic;
    NSDictionary *waterDic;
    NSDictionary *otherDic;
    NSDictionary *masterEditDic;
    NSDictionary *preNotPayDic;
    
    NSString *renterName;
    
    //所有账单列表o
    NSArray *billArr;
    
    NSString *storeKey;
    NSString *payBillID;
    
     UIView *bgView;
    
}

/*

 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToMonth)];
    [self.tapView addGestureRecognizer:tap];
    
    
    currentBill = true;
    self.title = self.houseNum;
    [self getBillList];
    currentBill = YES;
}


//没有账单的情况下，创建没有数据的界面
-(void)initNodataView{
    bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 150*ratio, 186*ratio)];
    iconView.centerX = bgView.centerX;
    [iconView setImage:[UIImage imageNamed:@"nodata"]];
    [bgView addSubview:iconView];
    [self.navigationController.navigationBar addSubview:bgView];
}

//根据时间排序
-(void)arrayByDate {
    
    NSSortDescriptor *moneyWithSort;
    
    moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"payBillTime" ascending:NO];
    NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
    billArr=[NSMutableArray arrayWithArray:[billArr sortedArrayUsingDescriptors:elementarr]];
}


//获取账单记录
-(void)getBillList{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.houseID,@"houseID", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getHouseAllAvailabelBillList:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            billArr = [response objectForKey:@"data"];
            if (billArr.count <= 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"当前没有账单！"];
                [self initNodataView];
                return ;
            }
            [self arrayByDate];
            billDic =billArr[0];
            NSDictionary *rentInfo = [billDic objectForKey:@"rentInfo"];
            NSArray *renters = [rentInfo objectForKey:@"renterInfo"];
            NSDictionary *renterDic ;
            for (int i = 0; i < renters.count; i++) {
                NSDictionary *dic = renters[i];
                NSString *roleID = [dic objectForKey:@"renterRoleID"];
                if (roleID.integerValue == 1) {
                    renterDic = dic;
                    break;
                }
            }
            renterName = [renterDic objectForKey:@"renterTrueName"];
            rentDic = rentInfo;
            payBillID = [NSString stringWithFormat:@"%@",[billDic objectForKey:@"payBillID"]];
            billDic = [[NSDictionary alloc] initWithObjectsAndKeys:billDic,@"billInfo", nil];
            NSString *time = [[billDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"];
            time = [TimeDate timeToTimeSp:time];
            NSString *year = [time substringToIndex:4];
            NSString *month = [time substringFromIndex:4];
            self.monthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];

            NSArray *goodsArr = [[billDic objectForKey:@"billInfo"] objectForKey:@"goodsInfo"];
            //水电，租金，上期未缴，屋主编辑金额
            [goodsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString  *goodID = [obj objectForKey:@"goodsID"];
                if (goodID.integerValue == 1) {
                    waterDic = obj;
                }
                if (goodID.integerValue == 2) {
                    electrictDic = obj;
                }
                if (goodID.integerValue == 3) {
                    roomMoneyDic = obj;
                }
                if (goodID.integerValue == 4) {
                    otherDic = obj;
                }
                if (goodID.integerValue == 5) {
                    preNotPayDic = obj;
                }
                if (goodID.integerValue == 6) {
                    masterEditDic = obj;
                }
            }];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}

-(void)clickToMonth{
    //TODO
    /*
    RenterBillHistoryController *vc = [[UIStoryboard storyboardWithName:@"RenterBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterBillHistory"];
    vc.billArr = billArr;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
     */
}
-(void)passValue:(NSDictionary *)value{
    billDic = value;
//    NSArray *rentInfoArr = [billDic objectForKey:@"rentInfo"];
    NSDictionary *rentInfo = [billDic objectForKey:@"rentInfo"];
//    for (int i = 0 ; i < rentInfoArr.count; i++) {
//        NSDictionary *dic = rentInfoArr[i];
//        NSString *rentIsDisable = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rentIsDisable"]];
//        if (rentIsDisable.integerValue == 0) {
//            rentInfo =dic;
//            break;
//        }
//    }
    NSArray *renters = [rentInfo objectForKey:@"renterInfo"];
    NSDictionary *renterDic ;
    for (int i = 0; i < renters.count; i++) {
        NSDictionary *dic = renters[i];
        NSString *roleID = [dic objectForKey:@"renterRoleID"];
        if (roleID.integerValue == 1) {
            renterDic = dic;
            break;
        }
    }

    renterName = [renterDic objectForKey:@"renterTrueName"];
    billDic = [[NSDictionary alloc] initWithObjectsAndKeys:billDic,@"billInfo", nil];
    NSString *time = [[billDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"];
    time = [TimeDate timeToTimeSp:time];
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringFromIndex:4];
    self.monthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
    if ([time isEqualToString:currentDate]) {
        currentBill = YES;
    }else{
        currentBill = false;
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [bgView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomOtherCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell.icon setImage:[UIImage imageNamed:@"sign_ok_icon2"]];
        cell.cellName.text = @"公寓名";
        cell.cellContent.text = self.communityName;
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"bill_month_icon"]];
        cell.cellName.text = @"租期";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.text = [NSString stringWithFormat:@"%@ 至 %@",[TimeDate timeWithTimeIntervalString:[self.rentInfo objectForKey:@"rentTime"]],[TimeDate timeWithTimeIntervalString:[self.rentInfo objectForKey:@"rentDueTime"]]];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon3"]];
        cell.cellName.text = @"主租客";
      cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.text = renterName;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon4"]];
        cell.cellName.text = @"押金";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.text =[NSString stringWithFormat:@"%@元",[rentDic objectForKey:@"rentDeposit"]];
        cell.cellContent.textColor = [UIColor blackColor];
    }else if(indexPath.section == 0 && indexPath.row == 4){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon5"]];
        cell.cellName.text = @"出账日";
        NSString *time = [[billDic objectForKey:@"billInfo"] objectForKey:@"payBillTime"];
        time = [TimeDate timeWithTimeIntervalString:time];
        time = [NSString stringWithFormat:@"%ld",(long)[time substringFromIndex:time.length -2].integerValue];
        NSLog(@"出账日====%@",time);
        cell.cellContent.text =[NSString stringWithFormat:@"%@日",time];
        cell.cellContent.textColor = [UIColor blackColor];
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
    }
    
    else if (indexPath.section == 1 && indexPath.row == 0){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
        cell.cellName.text = @"记账周期";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.text = [NSString stringWithFormat:@"%@ 至 %@",[[billDic objectForKey:@"billInfo"] objectForKey:@"billStartDate"],[[billDic objectForKey:@"billInfo"] objectForKey:@"billEndDate"]];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon8"]];
        cell.cellName.text = @"房租";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        NSString *rmb =[roomMoneyDic objectForKey:@"goodsPrice"];
        if ([rmb hasSuffix:@".00"]) {
            rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",rmb];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
        cell.cellName.text = @"其他费用";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (billDic.count >0) {
            NSString *rmb =[otherDic objectForKey:@"goodsPrice"];
            if ([rmb hasSuffix:@".00"]) {
                rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",rmb];
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 2 && indexPath.row == 0){
        [cell.icon setImage:[UIImage imageNamed:@"check_dian_icon"]];
        cell.cellName.text = @"电费";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (electrictDic.count >0) {
            [cell.anchorAspect setConstant:0];
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",[electrictDic objectForKey:@"goodsPrice"]];
        }else
        {
            
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"check_water_icon"]];
        cell.cellName.text = @"水费";
       cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (waterDic.count >0) {
             [cell.anchorAspect setConstant:0];
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",[waterDic objectForKey:@"goodsPrice"]];
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if(indexPath.section == 3 && indexPath.row == 0){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_nopay"]];
        cell.cellName.text = @"上期未缴";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (preNotPayDic.count >0) {
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",[preNotPayDic objectForKey:@"goodsPrice"]];
            textDark
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 3 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon9"]];
        cell.cellName.text = @"固定费用合计";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (billDic.count >0) {
            cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
            NSString *rmb =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[roomMoneyDic objectForKey:@"goodsPrice"]].floatValue + [NSString stringWithFormat:@"%@",[otherDic objectForKey:@"goodsPrice"]].floatValue];
            if ([rmb hasSuffix:@".00"]) {
                rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",rmb];
            textDark
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if(indexPath.section == 3 && indexPath.row == 2){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon10"]];
        cell.cellName.text = @"非固定费用合计";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (billDic.count >0) {
          
            NSString *allNotFreeze = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@元",[electrictDic objectForKey:@"goodsPrice"]].floatValue + [NSString stringWithFormat:@"%@",[waterDic objectForKey:@"goodsPrice"]].floatValue ];
            if ([allNotFreeze hasSuffix:@".00"]) {
                allNotFreeze = [allNotFreeze stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",allNotFreeze];
            textDark
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 3 && indexPath.row == 3){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon11"]];
        cell.cellName.text = @"费用总计";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        NSString *rmb = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[electrictDic objectForKey:@"goodsPrice"]].floatValue + [NSString stringWithFormat:@"%@",[waterDic objectForKey:@"goodsPrice"]].floatValue+[NSString stringWithFormat:@"%@",[roomMoneyDic objectForKey:@"goodsPrice"]].floatValue + [NSString stringWithFormat:@"%@",[otherDic objectForKey:@"goodsPrice"]].floatValue +[NSString stringWithFormat:@"%@",[preNotPayDic objectForKey:@"goodsPrice"]].floatValue] ;
        if ([rmb hasSuffix:@".00"]) {
              rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        
        cell.cellContent.text =[NSString stringWithFormat:@"%@元",rmb ] ;
    }else{
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_wait"]];
        cell.cellName.text = @"待缴费用";
//        cell.cellName.textColor = TDRGB(229, 89, 89);
        if (billDic.count >0) {
            NSString *notPay = [NSString stringWithFormat:@"%@",[[billDic objectForKey:@"billInfo"] objectForKey:@"payBillStatus"]];
            
            if (notPay.integerValue == 0) {
                NSString *rmb = [NSString stringWithFormat:@"%.2f", [NSString stringWithFormat:@"%@元",[[billDic objectForKey:@"billInfo"] objectForKey:@"payBillNotPay"]].floatValue+ [NSString stringWithFormat:@"%@元",[[billDic objectForKey:@"billInfo"] objectForKey:@"payBillFreezingPay"]].floatValue];
                if ([rmb hasSuffix:@".00"]) {
                    rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
                }
                cell.cellContent.text =[NSString stringWithFormat:@"%@元", rmb];
                cell.cellContent.font = [UIFont systemFontOfSize:20 *ratio];
                if (indexPath.section == 4 &&indexPath.row ==0) {
                cell.cellContent.textColor = TDRGB(229, 89, 89);
                }
            }else{
                cell.cellContent.text = @"已缴清";
                
                if (indexPath.section == 4 &&indexPath.row ==0) {
                    cell.cellContent.textColor =MainGreen;
                }
              
            }
        }
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0&&electrictDic.count>0) {
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 1;
        vc.houseID = [NSString stringWithFormat:@"%@",self.houseID];
        NSString *monthDate  =[billDic objectForKey:@"billEndDate"];
        monthDate = [monthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        monthDate = [monthDate substringToIndex:monthDate.length -2];
        vc.monthDate = monthDate;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1&&waterDic.count > 0){
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 2;
        vc.houseID = [NSString stringWithFormat:@"%@",self.houseID];
        NSString *monthDate  =[billDic objectForKey:@"billEndDate"];
        monthDate = [monthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        monthDate = [monthDate substringToIndex:monthDate.length -2];
        vc.monthDate = monthDate;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }else if(section == 1){
        return 3;
    }else if (section == 2){
        return 2;
    }else if(section == 3){
        return 4;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        return cellHeight;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
//定义sectionHeader的样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17 , 0, 7 *ratio, 17*ratio)];
    if (section % 3 == 0) {
        smallView.backgroundColor = MainBlue;
    }else if(section %3 == 1){
        smallView.backgroundColor = MainRed;
    }else{
        smallView.backgroundColor = MainGreen;
    }
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    
    label.font = [UIFont systemFontOfSize:14 *ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    if (section == 0) {
        label.text = @"房间信息";
    }else if (section == 1){
        label.text = @"固定费用明细";
    }else if(section == 2){
        label.text = @"非固定费用明细";
    }else if (section == 3){
        label.text = @"费用合计";
    }else if (section == 4){
        label.text = @"状态";
    }
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    
    
    //添加控件
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}
@end

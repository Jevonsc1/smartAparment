//
//  AccountRoomController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/9.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccountRoomController.h"
#import "RoomOtherCell.h"
#import "RenterBillHistoryController.h"
#import "RoomDianDetailController.h"
#import "MyDelegateDic.h"
#import "Bill.h"
#define textGray cell.cellContent.textColor = TDRGB(139, 139, 139);
#define textDark cell.cellContent.textColor = TDRGB(51, 51, 51);
@interface AccountRoomController ()<UITableViewDelegate,UITableViewDataSource,MyDelegateDic>
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *tapView;

@property(nonatomic,strong)NSMutableArray* billArray;
@property(nonatomic,strong)Good* waterGood;
@property(nonatomic,strong)Good* roomMoneyGood;
@property(nonatomic,strong)Good* otherGood;
@property(nonatomic,strong)Good* preNotPayGood;
@property(nonatomic,strong)Good* masterEditGood;
@property(nonatomic,strong)Good* electrictGood;

@property(nonatomic,strong)Renter* renter;
@property(nonatomic,strong)Bill* curBill;
@end

@implementation AccountRoomController
{

    BOOL currentBill;
    NSString *currentDate;
    
    NSString *houseID1;
    NSString *rentRecordID;
    
    
    NSString *storeKey;
     UIView *bgView;
    
}

-(NSMutableArray *)billArray{
    if (!_billArray) {
        _billArray = [NSMutableArray array];
    }
    return _billArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToMonth)];
    [self.tapView addGestureRecognizer:tap];
    
    
    currentBill = true;
    self.title = self.house.houseNum.stringValue;
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
    [self.billArray sortUsingComparator:^NSComparisonResult(Bill*  _Nonnull obj1, Bill*  _Nonnull obj2) {
        return [obj2.payBillTime compare:obj1.payBillTime];
    }];
}


//获取账单记录
-(void)getBillList{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.house.houseID,@"houseID", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getHouseAllAvailabelBillList:dic callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            NSArray* array = [response objectForKey:@"data"];
            [self.billArray removeAllObjects];
            for (NSDictionary* dic  in array) {
                Bill* bill = [Bill yy_modelWithDictionary:dic];
                [self.billArray addObject:bill];
            }

            if (self.billArray.count <= 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"当前没有账单！"];
                [self initNodataView];
                return ;
            }
            
            [self arrayByDate];
            self.curBill = self.billArray[0];
            
            [self setupByBill];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}

-(void)clickToMonth{

    RenterBillHistoryController *vc = [[UIStoryboard storyboardWithName:@"RenterBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterBillHistory"];
    vc.billArr = self.billArray;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)passValueForBill:(Bill *)value{
    self.curBill = value;

    [self setupByBill];
    [self.tableView reloadData];
}

-(void)setupByBill{
    Rent *rent = self.curBill.rentInfo;
    NSArray *renters = rent.renterInfo;
    for (Renter* renter in renters) {
        if ([renter.renterRoleID isEqual:@1]) {
            self.renter = renter;
            break;
        }
    }
    
    NSString* time = [TimeDate timeToTimeSp: self.curBill.payBillTime];
    NSString *year = [time substringToIndex:4];
    NSString *month = [time substringFromIndex:4];
    self.monthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
    
    NSArray *goodsArr = self.curBill.goodsInfo;
    for (Good* obj in goodsArr) {
        NSString  *goodID = obj.goodsID;
        if (goodID.integerValue == 1) {
            self.waterGood = obj;
        }
        if (goodID.integerValue == 2) {
            self.electrictGood = obj;
        }
        if (goodID.integerValue == 3) {
            self.roomMoneyGood = obj;
        }
        if (goodID.integerValue == 4) {
            self.otherGood = obj;
        }
        if (goodID.integerValue == 5) {
            self.preNotPayGood = obj;
        }
        if (goodID.integerValue == 6) {
            self.masterEditGood = obj;
        }
    }
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
        cell.cellContent.text = self.house.communityName;
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"bill_month_icon"]];
        cell.cellName.text = @"租期";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        for (Rent* rent in self.house.rentInfo) {
            if ([rent.rentIsDisable isEqual:@0]) {
                cell.cellContent.text = [NSString stringWithFormat:@"%@ 至 %@",[TimeDate timeWithTimeIntervalString:rent.rentTime.stringValue],[TimeDate timeWithTimeIntervalString:rent.rentDepositTime.stringValue]];
                break;
            }
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon3"]];
        cell.cellName.text = @"主租客";
      cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.text = self.renter.memberName;
    }else if (indexPath.section == 0 && indexPath.row == 3){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon4"]];
        cell.cellName.text = @"押金";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        
        cell.cellContent.text =[NSString stringWithFormat:@"%@元",self.curBill.rentInfo.rentDeposit];
        cell.cellContent.textColor = [UIColor blackColor];
    }else if(indexPath.section == 0 && indexPath.row == 4){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon5"]];
        cell.cellName.text = @"出账日";
        NSString *time = self.curBill.payBillTime;
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
        cell.cellContent.text = [NSString stringWithFormat:@"%@ 至 %@",self.curBill.billStartDate,self.curBill.billEndDate];
    }else if (indexPath.section == 1 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon8"]];
        cell.cellName.text = @"房租";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        NSString *rmb = self.roomMoneyGood.goodsPrice;
        if ([rmb hasSuffix:@".00"]) {
            rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        cell.cellContent.text = [NSString stringWithFormat:@"%@元",rmb];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
        cell.cellName.text = @"其他费用";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (self.curBill) {
            NSString *rmb = self.otherGood.goodsPrice;
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
        if (self.electrictGood) {
            [cell.anchorAspect setConstant:0];
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.electrictGood.goodsPrice];
        }else
        {
            
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"check_water_icon"]];
        cell.cellName.text = @"水费";
       cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (self.waterGood) {
             [cell.anchorAspect setConstant:0];
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.waterGood.goodsPrice];
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if(indexPath.section == 3 && indexPath.row == 0){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_nopay"]];
        cell.cellName.text = @"上期未缴";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (self.preNotPayGood) {
            cell.cellContent.text = [NSString stringWithFormat:@"%@元",self.preNotPayGood.goodsPrice];
            textDark
        }else
        {
            cell.cellContent.text = @"0元";
        }
    }else if (indexPath.section == 3 && indexPath.row == 1){
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon9"]];
        cell.cellName.text = @"固定费用合计";
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (self.curBill) {
            cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
            NSString *rmb =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",self.roomMoneyGood.goodsPrice].floatValue + [NSString stringWithFormat:@"%@",self.otherGood.goodsPrice].floatValue];
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
        if (self.curBill) {
         
            NSString *allNotFreeze = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@元", self.electrictGood.goodsPrice].floatValue + [NSString stringWithFormat:@"%@",self.waterGood.goodsPrice].floatValue ];
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
        NSString *rmb = [NSString stringWithFormat:@"%.2f",self.electrictGood.goodsPrice.floatValue + self.waterGood.goodsPrice.floatValue+self.roomMoneyGood.goodsPrice.floatValue + self.otherGood.goodsPrice.floatValue +self.preNotPayGood.goodsPrice.floatValue] ;
        if ([rmb hasSuffix:@".00"]) {
              rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        
        cell.cellContent.text =[NSString stringWithFormat:@"%@元",rmb ] ;
    }else{
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_wait"]];
        cell.cellName.text = @"待缴费用";
//        cell.cellName.textColor = TDRGB(229, 89, 89);
        if (self.curBill) {
            NSString *notPay = self.curBill.payBillStatus;
            
            if (notPay.integerValue == 0) {
                NSString *rmb =  [NSString stringWithFormat:@"%.2f元",self.curBill.payBillNotPay.floatValue+ self.curBill.payBillFreezingPay.floatValue];
                if ([rmb hasSuffix:@".00"]) {
                    rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
                }
                cell.cellContent.text = rmb;
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
    if (indexPath.section == 2 && indexPath.row == 0 && self.electrictGood) {
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 1;
        vc.houseID = self.house.houseID.stringValue;
        NSString *monthDate  =self.curBill.billEndDate;
        monthDate = [monthDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
        monthDate = [monthDate substringToIndex:monthDate.length -2];
        vc.monthDate = monthDate;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 1&& self.waterGood){
        RoomDianDetailController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomDianDetail"];
        vc.wayIn = 2;
        vc.houseID = self.house.houseID.stringValue;
        NSString *monthDate  = self.curBill.billEndDate;
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

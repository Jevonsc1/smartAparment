//
//  AllAccountController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AllAccountController.h"
#import "ApartmentBillCell.h"
#import "RenterACBillCell.h"
#import "SelectApartmentView.h"
#import "GBTagListView.h"
#import "BillSelectView.h"
#import "MJRefresh.h"
#import "TipsCell.h"
#import "RoomBillController.h"
#import "UIImageView+WebCache.h"

@interface AllAccountController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *onesj;
@property (weak, nonatomic) IBOutlet UIButton *one_btn;
@property (weak, nonatomic) IBOutlet UIImageView *twosj;
@property (weak, nonatomic) IBOutlet UIButton *two_btn;
@property (weak, nonatomic) IBOutlet UIImageView *threesj;
@property (weak, nonatomic) IBOutlet UIButton *three_btn;
@property (weak, nonatomic) IBOutlet UIButton *four_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *one_label;
@property (weak, nonatomic) IBOutlet UILabel *two_label;
@property (weak, nonatomic) IBOutlet UILabel *three_label;
@property (weak, nonatomic) IBOutlet UILabel *four_label;

@end

@implementation AllAccountController
{
    SelectApartmentView *selectView;
    BillSelectView *selectBillView;
    //微信，支付宝，现金
    UIButton *wechatBtn;
    UIButton *alipayBtn;
    UIButton *cashBtn;
    NSArray *selectBillBtnArr;
    NSMutableArray *getAllBillArr;
    int selectIndex;
    NSDictionary *selectBillDic;
    NSString *apartmentIDs;
    //保存原始的所有id
    NSString *tempAllComID;
    NSString *payWayIDs;
    NSString *sortType;
    //正序倒叙
    NSString *forward;
    //payWay数组
    NSMutableArray *payWayArr;
    NSArray *hadPayBillApartmentArr;
    //是否显示菊花
    BOOL shouldShowLoad;
    
    UIView *bgView;
    UIView *nodataBgView;
    NSMutableArray *apartmentTagArr;
    
    NSArray *tagArr;
    NSMutableArray *apartmentBillArr;
    NSMutableDictionary *apartmentIdDic;
    
    //保存标签数据的数组
    NSArray*strArray;
    //三个按钮的数组
    NSArray *selectBtnArr;
    //三个按钮的状态
    BOOL isSelectOverTime;
    BOOL isSelectHadPay;
    BOOL isSelectWaitPay;
    
    
    //所有房间的数组
    NSMutableArray *allRoomArr;
    //所有房间对应的公寓名
    NSMutableArray *apartmentNameArr;
    //公寓金额字典
    NSMutableDictionary *apartmentBillMoneyDic;
    //公寓金额数组
    NSMutableArray *apartmentBillMoneyArr;
    //公寓账单日字典
    NSMutableDictionary *apartmentBillDayDic;
    //公寓账单日数组
    NSMutableArray *apartmentBillDayArr;
    
    //三个数组--保存 默认排序，金额，收租日
    NSArray *defaultArr;
    NSArray *moneyArr;
    NSArray *getPayArr;
    //点击搜索钱的数组
    NSArray *searchTempArr;
    //点击筛选前的数组
    NSArray *beforeSelectArr;
    //判断是否弹出筛选框
    BOOL isSelect;
    //判断是否搜索中
    BOOL isSearch;
    //选择框
    GBTagListView *tagList;
    NSString *Tagname;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    payWayArr =[NSMutableArray arrayWithCapacity:0];
    getAllBillArr = [NSMutableArray arrayWithCapacity:0];
    sortType = @"0";
    forward = @"0";
    selectIndex = 1;
    
    if ([self.wayIn isEqualToString:@"hadPay"]) {
        self.title = @"本月已收";
         self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getAccountDataRefresh)];
    }else if ([self.wayIn isEqualToString:@"waitPay"]){
        self.title = @"待缴账单";
        self.one_label.text = @"默认排序";
        self.two_label.text =@"应缴金额";
        self.three_label.text = @"出账日";
    }else{
         self.three_label.text = @"出账日";
        self.title = @"逾期金额";
        self.one_label.text = @"默认排序";
    }
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //添加通知
    
    isSelectHadPay = false;
    isSelectOverTime = false;
    isSelectWaitPay = false;
    
    shouldShowLoad = false;
    
    if (![self.title isEqualToString:@"本月已收"]) {
           [self initSearchView];
        [self getRoomData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoomData) name:@"getRoomData" object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getApartmentIDS) name:@"getApartmentIDS" object:nil];
        [self getApartmentIDS];
        [self initSelectView];

        
    }
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//获取所有公寓的id
-(void)getApartmentIDS{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"9999",@"pageSize", nil];
    apartmentTagArr = [NSMutableArray arrayWithCapacity:0];
    
    apartmentIDs = @"";
    apartmentIdDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [MBProgressHUD showProgress];
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *apartmentArr = [response objectForKey:@"data"];
            if (apartmentArr.count >=1) {
                hadPayBillApartmentArr = apartmentArr;
                for (int i = 0; i <apartmentArr.count; i++) {
                    NSDictionary *objDic = apartmentArr[i];
                   apartmentIDs = [apartmentIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",[objDic objectForKey:@"communityID"]]];
                    [apartmentTagArr addObject:[objDic objectForKey:@"communityName"]];
                 
                }
                apartmentIDs = [apartmentIDs substringToIndex:apartmentIDs.length -1];
                tempAllComID = apartmentIDs;
                payWayIDs = @"[1,2,3]";
                sortType = @"0";
                [self addMonthTagView];
                [self getAccountData];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showMessage:@"请先创建公寓!"];
            }
        }else{
            [MBProgressHUD hideHUD];
            RequestBad
        }
       
    }];
}
//获取已出账单
-(void)getAccountData
{
    selectIndex = 1;
    if ([forward isEqualToString:@"0"]) {
        selectBillDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"[%@]",apartmentIDs],@"communityIDs",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[NSString stringWithFormat:@"%d",selectIndex],@"pageNum",@"6",@"pageSize",payWayIDs,@"payWayIDs",sortType, @"sortType",nil];
    }else{
        selectBillDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"[%@]",apartmentIDs],@"communityIDs",forward,@"forward",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[NSString stringWithFormat:@"%d",selectIndex],@"pageNum",@"6",@"pageSize",payWayIDs,@"payWayIDs",sortType, @"sortType",nil];
    }
    if (shouldShowLoad) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [WebAPI getIncomeTotal:selectBillDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *arr = [response objectForKey:@"data"];
            if (arr.count >0) {
                [getAllBillArr addObjectsFromArray:[[response objectForKey:@"data"] objectForKey:@"payBillOrderList"]];
                if (getAllBillArr.count >0) {
                    if (nodataBgView) {
                        [nodataBgView removeFromSuperview];
                        nodataBgView = nil;
                    }
                    self.tableView.scrollEnabled = YES;
                    
                    [self.tableView reloadData];
                }else{
                    [self initNodataView];
                }
            }else{
                  [self initNodataView];
            }
        }else{
            RequestBad
        }
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)getAccountDataRefresh
{
    selectIndex ++;
    if ([forward isEqualToString:@"0"]) {
        selectBillDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"[%@]",apartmentIDs],@"communityIDs",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[NSString stringWithFormat:@"%d",selectIndex],@"pageNum",@"6",@"pageSize",payWayIDs,@"payWayIDs",sortType, @"sortType",nil];
    }else{
        selectBillDic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"[%@]",apartmentIDs],@"communityIDs",forward,@"forward",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",[NSString stringWithFormat:@"%d",selectIndex],@"pageNum",@"6",@"pageSize",payWayIDs,@"payWayIDs",sortType, @"sortType",nil];
    }
    if (shouldShowLoad) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [WebAPI getIncomeTotal:selectBillDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
            if (dic.count>0) {
                [getAllBillArr addObjectsFromArray:[[response objectForKey:@"data"] objectForKey:@"payBillOrderList"]];
                
                if (getAllBillArr.count >0) {
                
                    self.tableView.scrollEnabled = YES;
                    
                    [self.tableView reloadData];
                   
                }else{
                    selectIndex -- ;
                    //                [self initNodataView];
                }
            }
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_footer endRefreshing];
    }];
}
-(void)getRoomData{
    allRoomArr = [NSMutableArray arrayWithCapacity:0];
    apartmentTagArr = [NSMutableArray arrayWithCapacity:0];
    apartmentIdDic = [NSMutableDictionary dictionaryWithCapacity:0];
    apartmentNameArr = [NSMutableArray arrayWithCapacity:0];
    apartmentBillMoneyDic = [NSMutableDictionary dictionaryWithCapacity:0];
    apartmentBillMoneyArr = [NSMutableArray arrayWithCapacity:0];
    apartmentBillDayDic = [NSMutableDictionary dictionaryWithCapacity:0];
    apartmentBillDayArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    @try {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebAPI getCommunityAvailableBill:dic callback:^(NSError *err, id response) {
            if ([NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000 && !err) {
                apartmentBillArr = [response objectForKey:@"data"];
                for (int i = 0; i<apartmentBillArr.count; i++) {
                    [apartmentTagArr addObject:[apartmentBillArr[i] objectForKey:@"communityName"]];
                    
                    NSArray *arr = [apartmentBillArr[i] objectForKey:@"houseInfo"];
                    for (int j = 0; j <arr.count; j++) {
                        NSMutableDictionary *roomDic = [NSMutableDictionary dictionaryWithDictionary:arr[j]];
                    
                        [roomDic setObject:[apartmentBillArr[i] objectForKey:@"communityName"] forKey:@"communityName"];
                        [roomDic setObject:[NSString stringWithFormat:@"%f",[NSString stringWithFormat:@"%@",[[arr[j] objectForKey:@"billInfo"] objectForKey:@"payBillNotPay"]].floatValue] forKey:@"totalPay"];
                        [roomDic setObject:[NSString stringWithFormat:@"%@",[[arr[j] objectForKey:@"billInfo"] objectForKey:@"payBillTime"]] forKey:@"payBillTime"];
                        [allRoomArr addObject:roomDic];
                         NSMutableArray *selectArr = [NSMutableArray arrayWithCapacity:0];
                        if ([self.title isEqualToString:@"待缴账单"]) {
                            for (int i = 0; i < allRoomArr.count; i++) {
                                NSDictionary *dic = allRoomArr[i];
                                
                                NSInteger compareDate = [self dateOut:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"billInfo"] objectForKey:@"payBillEndTime"]]];
                                if ([NSString stringWithFormat:@"%@",[[dic objectForKey:@"billInfo"] objectForKey:@"payBillNotPay"]].floatValue != 0.00 && compareDate>=0) {
                                    NSLog(@"未交费%@---%@",[dic objectForKey:@"houseNum"],[[dic objectForKey:@"billInfo"] objectForKey:@"payBillNotPay"]);
                                    [selectArr addObject:dic];
                                }else{
                                    NSString *payBillStatus = [[dic objectForKey:@"billInfo"] objectForKey:@"payBillStatus"];
                                    if (compareDate<0 && payBillStatus.integerValue != 1) {
                                        [selectArr addObject:dic];
                                    }
                                }
                            }
                            
                          
                              allRoomArr = [NSMutableArray arrayWithArray:selectArr];
                                [self arrayByName:self.one_btn];
                        }else if ([self.title isEqualToString:@"逾期金额"]){
                            
                            for (int i = 0; i < allRoomArr.count; i++) {
                                NSDictionary *dic = allRoomArr[i];
                                
                                NSInteger compareDate = [self dateOut:[NSString stringWithFormat:@"%@",[[dic objectForKey:@"billInfo"] objectForKey:@"payBillEndTime"]]];
                                NSString *payBillStatus = [[dic objectForKey:@"billInfo"] objectForKey:@"payBillStatus"];
                                if (compareDate<0 && payBillStatus.integerValue != 1) {
                                    [selectArr addObject:dic];
                                }
                            }
                              allRoomArr = [NSMutableArray arrayWithArray:selectArr];
                        }
                       
                    }
                    
                    
                    
                }
                searchTempArr = allRoomArr;
                [self addTagView];
                defaultArr = allRoomArr;
                
                if (allRoomArr.count == 0) {
                    [self initNodataView];
                }
                
                
            }else{
                RequestBad
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }];
    } @catch (NSException *exception) {
        NSLog(@"获取公寓已出账单出错--%@",exception);
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.wayIn isEqualToString:@"hadPay"]) {
        RenterACBillCell *cell = [self renterCell:indexPath];
        return cell;
    }else{
        if (indexPath.section >= allRoomArr.count) {
            TipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsCell"];
            return cell;
        }
        ApartmentBillCell *cell = [self roomCell:indexPath];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RoomBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomBill"];
    if ([self.wayIn isEqualToString:@"hadPay"]) {
 //TODO
 //        vc.house = getAllBillArr[indexPath.section];
        vc.mainName = [getAllBillArr[indexPath.section] objectForKey:@"renterName"];
        vc.wayIn = @"hadPay";
    }else{
        if (indexPath.section >= allRoomArr.count) {
            return;
        }
        ApartmentBillCell *cell = [tableView cellForRowAtIndexPath:indexPath];
 //TODO
 //       vc.roomDic = allRoomArr[indexPath.section];
        NSDictionary *roomDic = allRoomArr[indexPath.section];
 //       vc.aparmentName = [roomDic objectForKey:@"communityName"];
        vc.billType = cell.payStatus.text;
        //获取租赁信息中的租客信息
        NSArray *renterInfo = [roomDic objectForKey:@"rentInfo"];
        if (renterInfo.count > 0) {
            NSDictionary *dic = renterInfo[0];
            NSArray *renterArr = [dic objectForKey:@"renterInfo"];
            if (renterArr.count > 0) {
                for (int j = 0 ; j<renterArr.count; j++) {
                    NSDictionary *renterDic = renterArr[j];
                    if ([NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterRoleID"]].integerValue == 1) {
                        vc.mainName = [renterDic objectForKey:@"renterTrueName"];
                        break;
                    }
                }
            }
            
        }
    }
    
    vc.wayIn =self.wayIn;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 返回房间cell

 @param indexpath 行数和section数
 
 */
-(ApartmentBillCell *)roomCell:(NSIndexPath *)indexpath{
    ApartmentBillCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ApartmentBillCell"];
    @try {
        NSDictionary *roomDic = allRoomArr[indexpath.section];
        NSArray *rentInfo = [roomDic objectForKey:@"rentInfo"];
        NSDictionary *billInfo = [roomDic objectForKey:@"billInfo"];
        NSDictionary *comDic = [roomDic objectForKey:@"communityRelationInfo"][0];
        cell.roomNum.text = [NSString stringWithFormat:@"%@",[roomDic objectForKey:@"houseNum"]];
        //获取租赁信息中的租客信息
        NSString *acEnable = [NSString stringWithFormat:@"%@",[roomDic objectForKey:@"acEnable"]];
        NSString *hasAc = [NSString stringWithFormat:@"%@",[roomDic objectForKey:@"hasAC"]];
        if (hasAc.integerValue == 1) {
            if (acEnable.integerValue == 1) {
                cell.cellIcon.hidden = YES;
            }else{
                cell.cellIcon.hidden = NO;
                [cell.cellIcon setImage:[UIImage imageNamed:@"disable_door"]];
            }
        }else{
            cell.cellIcon.hidden = YES;
        }
        if (rentInfo.count > 0) {
            NSArray *renterInfo = [rentInfo[0] objectForKey:@"renterInfo"];
            if (renterInfo.count == 1) {
                cell.renters.text = [NSString stringWithFormat:@"独自居住"];
            }else{
                cell.renters.text = [NSString stringWithFormat:@"等%ld人居住",(unsigned long)renterInfo.count];
            }
            
            if (renterInfo.count > 0) {
                for (int j = 0 ; j<renterInfo.count; j++) {
                    NSDictionary *renterDic = renterInfo[j];
                    if ([NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterRoleID"]].integerValue == 1) {
                        cell.roomRenterNAME.text = [renterDic objectForKey:@"renterTrueName"];
                        break;
                    }
                    
                }
            }else{
                cell.roomRenterNAME.text = @"";
            }
            
        }
        for (int i = 0; i <apartmentBillArr.count;i++) {
            NSString *apartmentID = [NSString stringWithFormat:@"%@",[apartmentBillArr[i] objectForKey:@"communityID"]];
            if ([apartmentID isEqualToString:[NSString stringWithFormat:@"%@",[comDic objectForKey:@"houseCommunityID"]]]) {
                cell.apartmentName.text= [apartmentBillArr[i] objectForKey:@"communityName"];
                break;
            }
        }
        
        
        
        float notPay =[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillNotPay"]].floatValue+[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillFreezingPay"]].floatValue;
        NSInteger payBillStatus = [NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillStatus"]].integerValue;
        NSString *rmb = [NSString stringWithFormat:@"%.2f",notPay];
        if ([rmb hasSuffix:@".00"]) {
            rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        //未付款--或未完全付款
        
        
        if (payBillStatus == 0) {
            
            
            //判断是否过期
            NSInteger compareDate = [self dateOut:[NSString stringWithFormat:@"%@",[billInfo objectForKey:@"payBillEndTime"]]];
            if(compareDate >0){
                NSString *time = [NSString stringWithFormat:@"剩%ld天缴费",(long)compareDate];
                cell.payType.text = time;
                [cell.roomNumBgView setBackgroundColor:TDRGB(245.0, 166.0, 35.0)];
                cell.payType.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payStatus.text = @"待缴";
                cell.payStatus.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payMoney.text = [NSString stringWithFormat:@"%@元",rmb];
                cell.payMoney.textColor =TDRGB(245.0, 166.0, 35.0);
                [cell.payType.layer setBorderColor:TDRGB(245.0, 166.0, 35.0).CGColor];
            }else if(compareDate < 0){
                cell.payType.text = [NSString stringWithFormat:@"已逾期%d天",abs((int)compareDate)];
                cell.payType.textColor = TDRGB(229.0, 89.0, 89.0);
                [cell.roomNumBgView setBackgroundColor:TDRGB(229.0, 89.0, 89.0)];
                cell.payStatus.text = @"欠费";
                cell.payStatus.textColor = TDRGB(229.0, 89.0, 89.0);
                cell.payMoney.text = [NSString stringWithFormat:@"%@元",rmb];
                cell.payMoney.textColor =TDRGB(229.0, 89.0, 89.0);
                [cell.payType.layer setBorderColor:TDRGB(229.0, 89.0, 89.0).CGColor];
            }else{
                cell.payType.text = @"最后今天缴费";
                [cell.roomNumBgView setBackgroundColor:TDRGB(245.0, 166.0, 35.0)];
                cell.payType.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payStatus.text = @"待缴";
                cell.payStatus.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payMoney.text = [NSString stringWithFormat:@"%@元",rmb];
                cell.payMoney.textColor =TDRGB(245.0, 166.0, 35.0);
                [cell.payType.layer setBorderColor:TDRGB(245.0, 166.0, 35.0).CGColor];
            }
            cell.payMoney.font = [UIFont systemFontOfSize:18*ratio];
        }
        else if(payBillStatus != 0) {
            [cell.roomNumBgView setBackgroundColor:TDRGB(126.0, 195.0, 105.0)];
            cell.payType.text = @"费用已缴清";
            
            cell.payStatus.text = @"缴费日期";
            cell.payMoney.font = [UIFont systemFontOfSize:14*ratio];
            cell.payMoney.text = [TimeDate timeWithTimeIntervalString:[billInfo objectForKey:@"payBillIsCompleteTime"]];
            cell.payStatus.textColor = TDRGB(126.0, 195.0, 105.0);
            cell.payMoney.textColor =TDRGB(126.0, 195.0, 105.0);
            [cell.payType.layer setBorderColor:TDRGB(126.0, 195.0, 105.0).CGColor];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"出错了%@",exception);
    }
    
    
    cell.payType.layer.cornerRadius = 5;
    
    cell.payType.layer.borderWidth = 1;
    return cell;
}

/**
 返回有用户头像的cell
 */
-(RenterACBillCell *)renterCell :(NSIndexPath *)indexpath {
    NSDictionary *dic = getAllBillArr[indexpath.section];
    RenterACBillCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"RenterACBillCell"];
    [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"renterAvatar"]]] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    cell.renterIcon.layer.cornerRadius = cell.renterIcon.width/2;
    cell.renterIcon.layer.masksToBounds = YES;
    cell.renterName.text = [dic objectForKey:@"renterName"];
    cell.apartmentName.text = [NSString stringWithFormat:@"%@ %@房",[dic objectForKey:@"communityName"],[dic objectForKey:@"houseNum"]];
    cell.payType.text = [TimeDate timeDetailWithTimeIntervalString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"orderPayTime"]]];
    NSString *payway = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderPayWay"]];
    if (payway.integerValue == 1) {
        cell.payStatus.text = @"微信支付";
        cell.payStatus.textColor = TDRGB(111, 177, 35);
        cell.payMoney.textColor =TDRGB(111, 177, 35);
    }else if (payway.integerValue == 2){
        cell.payStatus.text = @"支付宝支付";
        cell.payStatus.textColor = TDRGB(111, 177, 35);
        cell.payMoney.textColor =TDRGB(111, 177, 35);
    }else{
        cell.payStatus.text = @"现金支付";
        cell.payStatus.textColor = TDRGB(248, 124, 41);
        cell.payMoney.textColor = TDRGB(248, 124, 41);
    }
    cell.payMoney.text = [NSString stringWithFormat:@"%@",[dic RMBForKey:@"orderPayAmount"] ];
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= allRoomArr.count && [self.title isEqualToString:@"逾期金额"]) {
        return cellHeight;
    }
    return 100 *ratio;
}



///默认排序
- (IBAction)defaultForLis:(id)sender {
    shouldShowLoad = YES;
    if (![self.wayIn isEqualToString:@"hadPay"]) {
        if (self.one_btn.tag == 1) {
            self.one_btn.tag =2;
            [self.onesj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
            self.one_label.textColor = MainRed;
            self.two_label.textColor = TDRGB(102, 102, 102);
            self.three_label.textColor = TDRGB(102, 102, 102);
            self.four_label.textColor = TDRGB(102, 102, 102);
        }else{
            self.one_btn.tag =1;
            self.one_label.textColor = MainRed;
            self.two_label.textColor = TDRGB(102, 102, 102);
            self.three_label.textColor = TDRGB(102, 102, 102);
            self.four_label.textColor = TDRGB(102, 102, 102);
            [self.onesj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
        [self arrayByName:self.one_btn];
        beforeSelectArr = allRoomArr;
        
        [self.tableView reloadData];
    }else{
        if (self.one_btn.tag == 1) {
            sortType = @"0";
            forward  = @"0";
            self.one_btn.tag =2;
            selectIndex = 0;
            [self.onesj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
            self.one_label.textColor = MainRed;
            self.two_label.textColor = TDRGB(102, 102, 102);
            self.three_label.textColor = TDRGB(102, 102, 102);
            self.four_label.textColor = TDRGB(102, 102, 102);
        }else{
            sortType = @"0";
            forward = @"1";
            selectIndex = 0;
            self.one_btn.tag =1;
            self.one_label.textColor = MainRed;
            self.two_label.textColor = TDRGB(102, 102, 102);
            self.three_label.textColor = TDRGB(102, 102, 102);
            self.four_label.textColor = TDRGB(102, 102, 102);
            [self.onesj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
        [getAllBillArr removeAllObjects];
        [self getAccountData];
    }
}
///应缴金额
- (IBAction)shouldPayForList:(id)sender {
    shouldShowLoad = YES;
    if (![self.wayIn isEqualToString:@"hadPay"]) {
        if (self.two_btn.tag == 1) {
            
            self.two_btn.tag =2;
            [self.twosj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
        }else{
            
            self.two_btn.tag = 1;
            [self.twosj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
        [self arrayByMoney:self.two_btn];
        self.one_label.textColor = TDRGB(102, 102, 102);
        self.two_label.textColor = MainRed;
        self.three_label.textColor = TDRGB(102, 102, 102);
        self.four_label.textColor = TDRGB(102, 102, 102);
        
        
        
        beforeSelectArr = allRoomArr;
        [self.tableView reloadData];
    }else{
        if (self.two_btn.tag == 1) {
            sortType = @"1";
            forward = @"0";
            self.two_btn.tag = 2;
             [self.twosj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
        }else{
            sortType = @"1";
            forward = @"1";
            self.two_btn.tag = 1;
             [self.twosj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
     
        self.one_label.textColor = TDRGB(102, 102, 102);
        self.two_label.textColor = MainRed;
        self.three_label.textColor = TDRGB(102, 102, 102);
        self.four_label.textColor = TDRGB(102, 102, 102);
  [getAllBillArr removeAllObjects];
        [self getAccountData];
    }
}
///账单日
- (IBAction)payDayForList:(id)sender {
    shouldShowLoad = YES;
    if (![self.wayIn isEqualToString:@"hadPay"]) {
        if (self.three_btn.tag == 1) {
            self.three_btn.tag = 2;
            
            [self.threesj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
        }else{
            self.three_btn.tag =1;
            [self.threesj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
        self.one_label.textColor = TDRGB(102, 102, 102);
        self.two_label.textColor = TDRGB(102, 102, 102);
        self.three_label.textColor = MainRed;
        self.four_label.textColor = TDRGB(102, 102, 102);
        [self arrayByDate:self.three_btn];
        beforeSelectArr = allRoomArr;
        [self.tableView reloadData];
    }else{
        if (self.three_btn.tag == 1) {
            sortType = @"2";
            forward = @"0";
            self.three_btn.tag = 2;
             [self.threesj setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
        }else{
            sortType = @"2";
            forward = @"1";
            self.three_btn.tag = 1;
            [self.threesj setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        }
        self.one_label.textColor = TDRGB(102, 102, 102);
        self.two_label.textColor = TDRGB(102, 102, 102);
        self.three_label.textColor = MainRed;
        self.four_label.textColor = TDRGB(102, 102, 102);
          [getAllBillArr removeAllObjects];
    
        [self getAccountData];
    }
}
///筛选
- (IBAction)selectForList:(id)sender {
    self.tableView.scrollEnabled = NO;
    
    self.one_label.textColor = TDRGB(102, 102, 102);
    self.two_label.textColor = TDRGB(102, 102, 102);
    self.three_label.textColor =  TDRGB(102, 102, 102);
    self.four_label.textColor = MainRed;
    isSelect = true;
    bgView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        selectView.x = self.view.width - 300 *ratio;
        bgView.x = 0;
        
    }];
    
}

//添加标签的本月已收view
-(void)addMonthTagView{
    if (tagList != nil) {
        [tagList removeFromSuperview];
        tagList = nil;
    }
    tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 0, 300*ratio - 30, selectView.searchHistoryView.height)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum=999;
    /**控制是否是单选模式 */
    tagList.isSingleSelect=NO;
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithTagArray:apartmentTagArr];
    
    __block AllAccountController *blockSelf = self;
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        [blockSelf->apartmentIdDic removeAllObjects];
        tagArr = arr;
        for (int i = 0; i<arr.count; i++) {
            blockSelf->Tagname= tagArr[i];
            for (int j = 0; j <hadPayBillApartmentArr.count; j++) {
                NSDictionary *dic = blockSelf->hadPayBillApartmentArr[j];
                
                if ([blockSelf->Tagname isEqualToString:[dic objectForKey:@"communityName"]]) {
                    
                    [blockSelf->apartmentIdDic setObject:[dic objectForKey:@"communityID"] forKey:blockSelf->Tagname];
                    
                }
            }
            
        }
        
        blockSelf->apartmentIDs = @"";
        [blockSelf->apartmentIdDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            blockSelf->apartmentIDs = [blockSelf->apartmentIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
        }];
        if (apartmentIdDic.count>=1) {
            blockSelf->apartmentIDs = [blockSelf->apartmentIDs substringToIndex:apartmentIDs.length-1];
        }
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:selectBillView.searchHistoryView.frame];
    scrollView.y =0;

    scrollView.contentSize = tagList.frame.size;
    [selectBillView.searchHistoryView addSubview:scrollView];
    [scrollView addSubview:tagList];
    
    
}
//添加标签的view
-(void)addTagView{
    
    
    if (tagList != nil) {
        [tagList removeFromSuperview];
        tagList = nil;
    }
    tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 0, selectView.searchHistoryView.width-20, selectView.searchHistoryView.height)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum=999;
    /**控制是否是单选模式 */
    tagList.isSingleSelect=NO;
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithTagArray:apartmentTagArr];
    
    __block AllAccountController *blockSelf = self;
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        [blockSelf->apartmentIdDic removeAllObjects];
        tagArr = arr;
        for (int i = 0; i<arr.count; i++) {
            blockSelf->Tagname= tagArr[i];
            for (int j = 0; j <apartmentBillArr.count; j++) {
                NSDictionary *dic = blockSelf->apartmentBillArr[j];
            
                if ([blockSelf->Tagname isEqualToString:[dic objectForKey:@"communityName"]]) {
                    
                    [blockSelf->apartmentIdDic setObject:[dic objectForKey:@"communityID"] forKey:blockSelf->Tagname];
                    
                }
            }
            
        }
    }];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:selectView.searchHistoryView.frame];
    scrollView.y = -10;
    scrollView.height = selectView.searchHistoryView.height - 90;
    scrollView.contentSize = tagList.frame.size;
    [selectView.searchHistoryView addSubview:scrollView];
    [scrollView addSubview:tagList];
    
    
}
-(void)initSelectView{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 60, self.view.width, self.view.height - 60 )];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    selectBillView = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil][2];
    
    selectBillView.frame = CGRectMake(bgView.width - 300*ratio, 0, 300*ratio, bgView.height);
    UIView* clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 300*ratio, bgView.height)];
    clickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [selectBillView.oneleading setConstant:17*ratio ];
    [selectBillView.twoleading setConstant:16*ratio];
    [bgView addSubview:clickView];
    [bgView addSubview:selectBillView];
    [selectBillView.sureSelect addTarget:self action:@selector(sureSelectBillTags) forControlEvents:UIControlEventTouchUpInside];
    [selectBillView.resetSelect addTarget:self action:@selector(resetSelectBill) forControlEvents:UIControlEventTouchUpInside];
    [self initThreeBtnAddTarget];
    wechatBtn = selectBillView.wechatBtn;
    cashBtn = selectBillView.cashBtn;
    alipayBtn = selectBillView.alipayBtn;
    selectBillBtnArr = @[wechatBtn,alipayBtn,cashBtn];
    //添加两种手势--点击以及滑动
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    [clickView addGestureRecognizer:tapG];
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    swipG.direction = UISwipeGestureRecognizerDirectionRight;
    [clickView addGestureRecognizer:swipG];
    [self.view addSubview:bgView];
}
//创建一个半透明的黑色蒙层
-(void)initSearchView {
    bgView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 60, self.view.width, self.view.height - 60 )];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    selectView = [[NSBundle mainBundle] loadNibNamed:@"AccountView" owner:self options:nil][0];

    selectView.frame = CGRectMake(bgView.width - 300*ratio, 0, 300*ratio, bgView.height);
    UIView* clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 300*ratio, bgView.height)];
    clickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [bgView addSubview:clickView];
    [bgView addSubview:selectView];
    [selectView.sureSelect addTarget:self action:@selector(sureSelectTags) forControlEvents:UIControlEventTouchUpInside];
    [selectView.resetSelect addTarget:self action:@selector(resetSelect) forControlEvents:UIControlEventTouchUpInside];
    //添加两种手势--点击以及滑动
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    [clickView addGestureRecognizer:tapG];
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    swipG.direction = UISwipeGestureRecognizerDirectionRight;
    [clickView addGestureRecognizer:swipG];
    [self.view addSubview:bgView];
}

-(void)sureSelectBillTags{
    shouldShowLoad = YES;
        if (payWayArr.count >0) {
            payWayIDs = @"";
            for (int i = 0; i <payWayArr.count; i++) {
                NSString *obj = payWayArr[i];
              payWayIDs = [payWayIDs stringByAppendingString:[NSString stringWithFormat:@"%@,",obj]];
            }            
              payWayIDs =  [payWayIDs substringToIndex:payWayIDs.length-1];
            payWayIDs = [NSString stringWithFormat:@"[%@]",payWayIDs];
            
        }else{
            payWayIDs = @"[1,2,3]";
        }
        selectIndex = 1;
    if (tagArr.count <= 0) {
        apartmentIDs  = tempAllComID;
    }
        forward = @"0";
        selectIndex  = 1;
        [getAllBillArr removeAllObjects];
        [self getAccountData];
    
    [self backForSelect];
}
/**
 确定筛选按钮
 */
-(void)sureSelectTags{
    if (tagArr.count >0) {
            allRoomArr = [NSMutableArray arrayWithArray:defaultArr];
        NSMutableArray *selectNameArr = [NSMutableArray arrayWithCapacity:0];
        NSLog(@"%@++++%@",apartmentIdDic,tagArr);
        for (int i = 0; i <tagArr.count;i++) {
            NSString *name = tagArr[i];
            NSString *apartmentID = [apartmentIdDic objectForKey:name];
            NSLog(@"确定后%@",apartmentIdDic);
            for (int j = 0; j <allRoomArr.count; j++) {
                NSDictionary *apartmentDic = [allRoomArr[j] objectForKey:@"communityRelationInfo"][0];
                if ([[NSString stringWithFormat:@"%@",apartmentID] isEqualToString:[NSString stringWithFormat:@"%@",[apartmentDic objectForKey:@"houseCommunityID"]]]) {
                    
                    [selectNameArr addObject:allRoomArr[j]];
                }
            }
        }
        
        allRoomArr = selectNameArr;
        
    }
    
    
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        selectView.x = self.view.width;
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //        [bgView removeFromSuperview];
        bgView.hidden = YES;
    });
    [self.tableView reloadData];
}
//点击黑色蒙层收起选择窗口
-(void)backForSelect{
    isSelect = false;
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        selectView.x = self.view.width;
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //        [bgView removeFromSuperview];
        bgView.hidden = YES;
        bgView.x = self.view.width;
    });
}

/**
 重置按钮的点击事件
 */
-(void)resetSelect{
    
    GBTagListView *tagView = tagList;
    NSArray *btnArr = tagView.subviews;
    
    for (int i = 0; i <btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        btn.selected = NO;
        
    }
    tagArr =nil;
    [apartmentIdDic removeAllObjects];
    [tagList removeFromSuperview];

    [self addTagView];
    
}
-(void)resetSelectBill{
    for (int i = 0; i<selectBillBtnArr.count; i++) {
        UIButton *btn = selectBillBtnArr[i];
        btn.tag = 2;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    isSelectOverTime = false;
    isSelectWaitPay = false;
    isSelectHadPay = false;

    
    GBTagListView *tagView = tagList;
    NSArray *btnArr = tagView.subviews;
    
    for (int i = 0; i <btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        btn.selected = NO;
        [btn removeFromSuperview];
        
    }
   
    [tagList setTagWithTagArray:apartmentTagArr];
}
//为三个按钮添加点击事件
-(void)initThreeBtnAddTarget{
    [selectBillView.wechatBtn addTarget:self action:@selector(selectOneBtn:) forControlEvents:UIControlEventTouchDown];
    [selectBillView.alipayBtn addTarget:self action:@selector(selectTwoBtn:) forControlEvents:UIControlEventTouchDown];
    [selectBillView.cashBtn addTarget:self action:@selector(selectThreeBtn:) forControlEvents:UIControlEventTouchDown];
    
    
}

///-----------------------------三个按钮-------------------------------//
-(void)selectOneBtn:(UIButton *)btn{
    if(!isSelectOverTime){
        btn.tag = 2;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        isSelectOverTime = true;
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
        [payWayArr addObject:@"1"];
    }else{
        isSelectOverTime = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
        [payWayArr removeObject:@"1"];
        
    }
}
-(void)selectTwoBtn:(UIButton *)btn{
    if(!isSelectWaitPay){
        btn.tag = 2;
        isSelectWaitPay = true;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
        [payWayArr addObject:@"2"];
    }else{
        isSelectWaitPay = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
        [payWayArr removeObject:@"2"];
    }
    
}
-(void)selectThreeBtn:(UIButton *)btn{
    if(!isSelectHadPay){
        btn.tag = 2;
        isSelectHadPay = true;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        [payWayArr addObject:@"3"];
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
    }else{
        isSelectHadPay = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
        [payWayArr removeObject:@"3"];
    }
    
}
/**
 cell的编辑按钮

 */
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString *phone ;
    NSDictionary *dic = allRoomArr[indexPath.section];
    NSDictionary *roomDic = allRoomArr[indexPath.section];
    
    //获取租赁信息中的租客信息
    NSArray *renterInfo = [roomDic objectForKey:@"rentInfo"];
    if (renterInfo.count > 0) {
        NSDictionary *dic = renterInfo[0];
        NSArray *renterArr = [dic objectForKey:@"renterInfo"];
        if (renterArr.count > 0) {
            for (int j = 0 ; j<renterArr.count; j++) {
                NSDictionary *renterDic = renterArr[j];
                if ([NSString stringWithFormat:@"%@",[renterDic objectForKey:@"renterRoleID"]].integerValue == 1) {
                    phone = [renterDic objectForKey:@"renterPhone"];
                    break;
                }
            }
        }
        
    }
    NSString *hasAC = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hasAC"]];
    NSString *acEnable = [NSString stringWithFormat:@"%@",[dic objectForKey:@"acEnable"]];
     NSString *doorType = @"禁用门禁";
    if (acEnable.integerValue == 1) {
        doorType = @"禁用\n门禁";
    }else{
        doorType = @"解除\n禁用";
    }

    UITableViewRowAction *doorBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:doorType handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *ac ;
        if (acEnable.integerValue == 1) {
         ac=   [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确定是否禁用该用户门禁" preferredStyle:UIAlertControllerStyleAlert];
        }else{
            ac =[UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确定是否解除该用户门禁" preferredStyle:UIAlertControllerStyleAlert];
        }
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *oneDic ;
            if (acEnable.integerValue == 1) {
                oneDic  = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"ban",[dic objectForKey:@"houseID"],@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key" ,nil];
            }else{
                oneDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"0",@"ban",[dic objectForKey:@"houseID"],@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key" ,nil];
            }
            [WebAPI operateHouseAC:oneDic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [MBProgressHUD showMessage:@"调整成功"];
                    [self getRoomData];
                }else{
                    
                   RequestBad
                }
            }];
          
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:cancel];
        [ac addAction:sure];
        [self presentViewController:ac animated:YES completion:nil];
     
    }];
    UITableViewRowAction *callPhoneBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拨打\n电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    
    }];

    if ([doorType isEqualToString:@"禁用门禁"]) {
        doorBtn.backgroundColor = MainRed;
    }else{
        doorBtn.backgroundColor = MainGreen;
    }
    callPhoneBtn.backgroundColor = MainBlue;

    if (hasAC.integerValue == 1) {
        return @[callPhoneBtn,doorBtn];
    }else{
        return @[callPhoneBtn];
    }
}
- (IBAction)clickToPop:(id)sender {
    [nodataBgView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.wayIn isEqualToString:@"hadPay"]) {
        return  getAllBillArr.count;
    }else
    {
        if ([self.title isEqualToString:@"逾期金额"]) {
            return allRoomArr.count+1;
        }else{
            return allRoomArr.count;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ratio;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>=allRoomArr.count&&[self.title isEqualToString:@"逾期金额"] ) {
        return  NO;
    }
    return YES;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10*ratio)];
    view.backgroundColor = TDRGB(245.0, 245.0, 245.0);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    topLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.height -1, self.view.width, 1)];
    bottomLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    [view addSubview: topLine];
    [view addSubview:bottomLine];
    return view;
}
-(void)arrayByName:(UIButton *)btn{
    if (allRoomArr.count == 0) {
        allRoomArr = [NSMutableArray arrayWithArray:defaultArr];
    }
    NSSortDescriptor *moneyWithSort;
    NSSortDescriptor *moneyWithSort1;
    if (btn.tag != 1) {
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:NO];
        moneyWithSort1  =[[NSSortDescriptor alloc]initWithKey:@"houseNum" ascending:NO];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort,moneyWithSort1, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }else{
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:YES];
        moneyWithSort1  =[[NSSortDescriptor alloc]initWithKey:@"houseNum" ascending:YES];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort,moneyWithSort1, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }
    
    if (allRoomArr.count == 0) {
        allRoomArr = [NSMutableArray arrayWithArray:defaultArr];
    }
    NSSortDescriptor *moneyWithSort2;
    
    if (btn.tag != 1) {
        moneyWithSort2  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:NO];
        
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort2, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }else{
        moneyWithSort2  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:YES];
        
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort2, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }
    
    moneyArr =allRoomArr;
}

///------------------------------按照日期排序------------------------------------------//
-(void)arrayByDate :(UIButton *)btn{
    if (allRoomArr.count == 0) {
        allRoomArr = [NSMutableArray arrayWithArray:defaultArr];
    }
    NSSortDescriptor *moneyWithSort;
    if (btn.tag != 1) {
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"payBillTime" ascending:NO];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }else{
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"payBillTime" ascending:YES];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
        allRoomArr=[NSMutableArray arrayWithArray:[allRoomArr sortedArrayUsingDescriptors:elementarr]];
    }
    
    
}
-(void)arrayByDateForArr :(UIButton *)btn{
    if (getAllBillArr.count == 0) {
        getAllBillArr = [NSMutableArray arrayWithArray:defaultArr];
    }
    NSSortDescriptor *moneyWithSort;
    if (btn.tag != 2) {
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"orderPayTime" ascending:NO];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
        getAllBillArr=[NSMutableArray arrayWithArray:[getAllBillArr sortedArrayUsingDescriptors:elementarr]];
    }else{
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"orderPayTime" ascending:YES];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
        getAllBillArr=[NSMutableArray arrayWithArray:[getAllBillArr sortedArrayUsingDescriptors:elementarr]];
    }
    
    
}
///-----------------------------按照金额排序------------------------------------------//
-(void)arrayByMoney :(UIButton *)btn{
    if (allRoomArr.count == 0) {
        allRoomArr = [NSMutableArray arrayWithArray:defaultArr];
    }
    
    NSArray *arr2 = [allRoomArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                     {
                         NSString  *c = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[[obj1 objectForKey:@"billInfo"] valueForKey:@"payBillNotPay"]].floatValue +[NSString stringWithFormat:@"%@",[[obj1 objectForKey:@"billInfo"] objectForKey:@"payBillFreezingPay"]].floatValue];
                         NSString  *d = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[[obj2 objectForKey:@"billInfo"] valueForKey:@"payBillNotPay"]].floatValue +[NSString stringWithFormat:@"%@",[[obj2 objectForKey:@"billInfo"] objectForKey:@"payBillFreezingPay"]].floatValue];
                         int a =[c intValue]; //转成整形int比较
                         int b =[d intValue];
                         //按照降序排列，如果升序就返回结果对换
                         if (btn.tag == 1) {
                             if (a > b)
                             {
                                 return NSOrderedAscending;
                             }else
                             {
                                 return NSOrderedDescending;
                             }
                         }else{
                             if (a < b)
                             {
                                 return NSOrderedAscending;
                             }else
                             {
                                 return NSOrderedDescending;
                             }
                         }
                         
                     }];
    allRoomArr = [NSMutableArray arrayWithArray:arr2];
    
}

//将数组倒转
-(NSMutableArray *)arrayByTurn:(NSMutableArray *)orgArr{
    
    NSArray* reversedArray = [[orgArr reverseObjectEnumerator] allObjects];
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:reversedArray];
    return resultArr;
    
}

//计算时间间隔
- (NSInteger)dateOut:(NSString*)dueTimeString{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *startTime = [dateFormatter stringFromDate:[NSDate date]];
    //当前时间
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate *bbEndDate = [NSDate dateWithTimeIntervalSince1970:[dueTimeString intValue]];
    NSString *endTime = [dateFormatter stringFromDate:bbEndDate];
    
    NSString *startTimeDate = [self timeSwitchTimestamp:startTime andFormatter:@"YYYYMMdd"];
    NSString *endTimeDate = [self timeSwitchTimestamp:endTime andFormatter:@"YYYYMMdd"];
    currentDate = [NSDate dateWithTimeIntervalSince1970:[startTimeDate intValue]];
    bbEndDate = [NSDate dateWithTimeIntervalSince1970:[endTimeDate intValue]];
    //相差几天
    NSInteger compareDate = [self bbCompareTwoDateWithBeginDate:currentDate end:bbEndDate];
    return compareDate;
}
- (NSInteger) bbCompareTwoDateWithBeginDate:(NSDate *)beginDate end:(NSDate *)endDate
{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

//没有账单的情况下，创建没有数据的界面
-(void)initNodataView{
    self.tableView.scrollEnabled = NO;
    nodataBgView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [nodataBgView setBackgroundColor:[UIColor whiteColor]];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 150*ratio, 186*ratio)];
    iconView.centerX = nodataBgView.centerX;
    [iconView setImage:[UIImage imageNamed:@"nodata"]];
    [nodataBgView addSubview:iconView];
    [self.tableView addSubview:nodataBgView];
}

-(NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",(long)timeSp];
    
    //时间戳的值
    
    
    
    return timeStr;
    
}


@end

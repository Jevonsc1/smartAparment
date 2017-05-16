//
//  ApartmentBillController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ApartmentBillController.h"
#import "ApartmentBillCell.h"
#import "BillSelectView.h"
#import "GBTagListView.h"
#import "RoomBillController.h"
#import "BillModel.h"
#import "searchBarView.h"
#import "TipsCell.h"
#import "SearchBillController.h"
#import "Community.h"
@interface ApartmentBillController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *onesj;
@property (weak, nonatomic) IBOutlet UIButton *one_btn;
@property (weak, nonatomic) IBOutlet UIImageView *twosj;
@property (weak, nonatomic) IBOutlet UIButton *two_btn;
@property (weak, nonatomic) IBOutlet UIImageView *threesj;
@property (weak, nonatomic) IBOutlet UIButton *three_btn;
@property (weak, nonatomic) IBOutlet UIButton *four_btn;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *one_label;
@property (weak, nonatomic) IBOutlet UILabel *two_label;
@property (weak, nonatomic) IBOutlet UILabel *three_label;
@property (weak, nonatomic) IBOutlet UILabel *four_label;

@property(nonatomic,strong)NSMutableArray* communityArray;
@property(nonatomic,strong)NSMutableArray* allHouseArray;
@property(nonatomic,strong)NSMutableArray* tagSelectedHouseArray;
@property(nonatomic,strong)NSMutableArray* selectedShowArray;
@end

@implementation ApartmentBillController
{
    UIView *bgView;
    BillSelectView *billView;
    //标签view
    GBTagListView*_tempTag;

    //保存标签数据的数组
    NSArray*strArray;
    //三个按钮的数组
    NSArray *selectBtnArr;
    //三个按钮的状态
    BOOL isSelectOverTime;
    BOOL isSelectHadPay;
    BOOL isSelectWaitPay;
    //三个label
    
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

-(NSMutableArray *)communityArray{
    if (!_communityArray) {
        _communityArray = [NSMutableArray array];
    }
    return _communityArray;
}

-(NSMutableArray *)allHouseArray{
    if (!_allHouseArray) {
        _allHouseArray = [NSMutableArray array];
    }
    return _allHouseArray;
}

-(NSMutableArray *)selectedShowArray{
    if (!_selectedShowArray) {
        _selectedShowArray = [NSMutableArray array];
    }
    return _selectedShowArray;
}

-(NSMutableArray *)tagSelectedHouseArray{
    if (!_tagSelectedHouseArray) {
        _tagSelectedHouseArray = [NSMutableArray array];
    }
    return  _tagSelectedHouseArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchBar:) name:@"SearchBill" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoomData) name:@"getRoomData" object:nil];
    isSelectHadPay = false;
    isSelectOverTime = false;
    isSelectWaitPay = false;
    
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self initSelectView];
    [self initThreeBtnAddTarget];
    [self getRoomData];
}


-(void)getRoomData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key", @"2.0",@"version",nil];
    @try {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebAPI getCommunityAvailableBill:dic callback:^(NSError *err, id response) {
            if ([response intForKey:@"rcode"] == 10000 && !err) {
                NSArray* array = [response objectForKey:@"data"];
                [self.communityArray removeAllObjects];
                [self.allHouseArray removeAllObjects];
                for (NSDictionary* dic in array) {
                    Community* community = [Community yy_modelWithDictionary:dic];
                    [self.communityArray addObject:community];
                    
                    for(House* house in community.houseInfoList){
                        house.communityName = community.communityName;
                        [self.allHouseArray addObject:house];
                    }
                }

                searchTempArr = self.allHouseArray;
                [self addTagView];
                self.selectedShowArray = [self.allHouseArray mutableCopy];
                
                self.one_btn.tag = 1;
                [self clickByDefault:self.one_btn];
                [self.tableview reloadData];
                
            }else{
                RequestBad
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"获取公寓已出账单出错--%@",exception);
    }
    

}
- (IBAction)clickToPop:(id)sender {
 
    if (isSelect) {
//        self.tableview.scrollEnabled = YES;
        [UIView animateWithDuration:0.25 animations:^{
            billView.x = self.view.width;
            bgView.alpha = 0;
        }];
        isSelect = false;
    }else if (isSearch){
        [self resetNavigationItem];
        self.selectedShowArray =  [self.allHouseArray mutableCopy];
        isSearch = false;
        [self.tableview reloadData];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -m 获取公寓所有账单

//为三个按钮添加点击事件
-(void)initThreeBtnAddTarget{
    [billView.overTimeBtn addTarget:self action:@selector(selectOneBtn:) forControlEvents:UIControlEventTouchDown];
    [billView.waitPayBtn addTarget:self action:@selector(selectTwoBtn:) forControlEvents:UIControlEventTouchDown];
    [billView.hadPayBtn addTarget:self action:@selector(selectThreeBtn:) forControlEvents:UIControlEventTouchDown];
    selectBtnArr = [NSArray arrayWithObjects:billView.overTimeBtn,billView.waitPayBtn,billView.hadPayBtn, nil];
    
    [billView.allSelectBtn addTarget:self action:@selector(allSelectTagBtn:) forControlEvents:UIControlEventTouchDown];
    
    
}
  //创建一个半透明的黑色蒙层
-(void)initSelectView {
    bgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 60, self.view.width, self.view.height - 60 )];
    bgView.alpha = 0;
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    billView = [[NSBundle mainBundle] loadNibNamed:@"BillSelectView" owner:self options:nil][0];
    
    billView.frame = CGRectMake(self.view.width, 0, 300*ratio, bgView.height);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [bgView addSubview:billView];
    [billView.sureSelect addTarget:self action:@selector(sureSelectTags) forControlEvents:UIControlEventTouchUpInside];
    [billView.resetSelect addTarget:self action:@selector(resetSelect) forControlEvents:UIControlEventTouchUpInside];
    //添加两种手势--点击以及滑动
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    [bgView addGestureRecognizer:tapG];
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    swipG.direction = UISwipeGestureRecognizerDirectionRight;
    [bgView addGestureRecognizer:swipG];
    [self.view addSubview:bgView];
}

//点击黑色蒙层收起选择窗口
-(void)backForSelect{
    isSelect = false;
//    self.tableview.scrollEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        billView.x = self.view.width;
        bgView.alpha =  0;
    }];
   

}

//点击默认排序
- (IBAction)clickByDefault:(id)sender {
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
    beforeSelectArr = self.allHouseArray;
    
    [self.tableview reloadData];
}
//点击应缴金额
- (IBAction)clickByShouldPay:(id)sender {
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
    

    
     beforeSelectArr = self.allHouseArray;
    [self.tableview reloadData];
    
}
//点击收租日
- (IBAction)clickByPayDay:(id)sender {
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
     beforeSelectArr = self.allHouseArray;
    [self.tableview reloadData];
}
//点击筛选---弹出筛选小窗口
- (IBAction)clickBySelet:(UIButton *)sender {
//    self.tableview.scrollEnabled = NO;
    
    self.one_label.textColor = TDRGB(102, 102, 102);
    self.two_label.textColor = TDRGB(102, 102, 102);
    self.three_label.textColor =  TDRGB(102, 102, 102);
    self.four_label.textColor = MainRed;
    isSelect = true;
//    [self.view addSubview:bgView];
    [UIView animateWithDuration:0.25 animations:^{
        billView.x = self.view.width - 300 *ratio;
        bgView.alpha = 1;
    }];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.selectedShowArray.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10*ratio)];
    view.backgroundColor = TDRGB(245.0, 245.0, 245.0);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    topLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 10*ratio, self.view.width, 1)];
    bottomLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    [view addSubview: topLine];
    [view addSubview:bottomLine];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.selectedShowArray.count) {
         return cellHeight;
    }
    return 110 * ratio;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >=self.selectedShowArray.count) {
        TipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TipsCell"];
        return cell;
    }
        ApartmentBillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApartmentBillCell" forIndexPath:indexPath];
    
        House* house = self.selectedShowArray[indexPath.section];
        NSArray *rentInfo = house.rentInfo;
    
        Bill* bill = house.billInfo;
        cell.roomNum.text = house.houseNum.stringValue;
        cell.apartmentName.text= house.communityName;
        //获取租赁信息中的租客信息
        if (rentInfo.count > 0) {
            Rent* rent = rentInfo[0];
            NSArray *renterInfo = rent.renterInfo;
            if (renterInfo.count == 1) {
                cell.renters.text = [NSString stringWithFormat:@"独自居住"];
            }else{
                cell.renters.text = [NSString stringWithFormat:@"等%ld人居住",(unsigned long)renterInfo.count];
            }
        
            if (renterInfo.count > 0) {
                for (Renter *renter in renterInfo) {
                    if ([renter.renterRoleID isEqual:@1]) {
                        cell.roomRenterNAME.text = renter.renterTrueName;
                        break;
                    }
                    
                }
            }else{
                cell.roomRenterNAME.text = @"";
            }
  
        }
        
       float notPay = bill.payBillNotPay.floatValue + bill.payBillFreezingPay.floatValue;
       
        if (bill.payBillStatus.integerValue == 0) {
            //判断是否过期
            NSInteger compareDate = [self dateOut:bill.payBillEndTime];
            if(compareDate >0){
                
                NSString *time = [NSString stringWithFormat:@"剩%ld天缴费",(long)compareDate];
                
                cell.payType.text = time;
                [cell.roomNumBgView setBackgroundColor:TDRGB(245.0, 166.0, 35.0)];
                cell.payType.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payStatus.text = @"待缴";
                cell.payStatus.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payMoney.text = [NSString stringWithFormat:@"¥%.2f",notPay];
                
                cell.payMoney.textColor =TDRGB(245.0, 166.0, 35.0);
                [cell.payType.layer setBorderColor:TDRGB(245.0, 166.0, 35.0).CGColor];
            }else if(compareDate < 0){
                cell.payType.text = [NSString stringWithFormat:@"已逾期%d天",abs((int)compareDate)];
                cell.payType.textColor = TDRGB(229.0, 89.0, 89.0);
                [cell.roomNumBgView setBackgroundColor:TDRGB(229.0, 89.0, 89.0)];
                cell.payStatus.text = @"欠费";
                cell.payStatus.textColor = TDRGB(229.0, 89.0, 89.0);
               cell.payMoney.text = [NSString stringWithFormat:@"¥%.2f",notPay];
                cell.payMoney.textColor =TDRGB(229.0, 89.0, 89.0);
                [cell.payType.layer setBorderColor:TDRGB(229.0, 89.0, 89.0).CGColor];
            }else{
                cell.payType.text = @"最后今天缴费";
                [cell.roomNumBgView setBackgroundColor:TDRGB(245.0, 166.0, 35.0)];
                cell.payType.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payStatus.text = @"待缴";
                cell.payStatus.textColor = TDRGB(245.0, 166.0, 35.0);
                cell.payMoney.text = [NSString stringWithFormat:@"¥%.2f",notPay];
                cell.payMoney.textColor =TDRGB(245.0, 166.0, 35.0);
                 [cell.payType.layer setBorderColor:TDRGB(245.0, 166.0, 35.0).CGColor];
            }
         cell.payMoney.font = [UIFont systemFontOfSize:18*ratio];
    }
        else if(bill.payBillStatus.integerValue != 0) {
            [cell.roomNumBgView setBackgroundColor:TDRGB(126.0, 195.0, 105.0)];
            cell.payType.text = @"费用已缴清";
            cell.payType.textColor = TDRGB(126.0, 195.0, 105.0);
            cell.payStatus.text = @"缴费日期";
            cell.payMoney.font = [UIFont systemFontOfSize:14*ratio];
            cell.payMoney.text = [TimeDate timeWithTimeIntervalString:bill.payBillIsCompleteTime];
            cell.payStatus.textColor = TDRGB(126.0, 195.0, 105.0);
            cell.payMoney.textColor =TDRGB(126.0, 195.0, 105.0);
            [cell.payType.layer setBorderColor:TDRGB(126.0, 195.0, 105.0).CGColor];
        }
        
        
   
    
    cell.payType.layer.cornerRadius = 5;
    
    cell.payType.layer.borderWidth = 1;
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>=self.selectedShowArray.count) {
        return NO;
    }
    return YES;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    House* house = self.selectedShowArray[indexPath.section];
    Bill *bill = house.billInfo;
    NSArray *renterInfo = house.rentInfo;

    
    UITableViewRowAction *rentMoneyType;
    UITableViewRowAction *callPhone = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拨打\n电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *phone;
        //获取租赁信息中的租客信息
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
            }else{
                
            }
            
        }
        
        if (phone.length <= 0) {
            [Alert showFail:@"该租客没有电话号码信息！" View:self.navigationController.navigationBar andTime:3 complete:nil];
            return ;
        }
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
            }];
    if (bill.payBillStatus.integerValue == 0) {
       
            rentMoneyType = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为\n已缴" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n是否设为已缴状态" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary   *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",bill.payBillID,@"payBillID",@"0",@"payBillAmount",[NSString stringWithFormat:@"%.2f",bill.payBillNotPay.floatValue],@"payBillCharges", nil];
                    [WebAPI editHousePayBill:dic callback:^(NSError *err, id response) {
                        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                            [Alert showFail:@"调整成功！" View:self.navigationController.navigationBar andTime:3 complete:nil];
                            [self getRoomData];
                            
                        }else{
                            RequestBad
                        }
                    }];
 
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [ac dismissViewControllerAnimated:YES completion:nil];
                }];
                [ac addAction:ok];
                [ac addAction:cancel];
                
                [self presentViewController:ac animated:YES completion:nil];
            }];
        rentMoneyType.backgroundColor = MainGreen;
        
        callPhone.backgroundColor = MainBlue;
        return @[callPhone,rentMoneyType];
     
    }else if(bill.payBillStatus.integerValue == 1){
       if (bill.payBillCanUnpaid.integerValue == 1) {
          rentMoneyType = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为\n未缴" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
              //点击后操作
              
              UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n是否设为未缴状态" preferredStyle:UIAlertControllerStyleAlert];
              UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  NSDictionary   *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",bill.payBillID,@"payBillID",nil];
                  [WebAPI setHousePayBillUnpaid:dic callback:^(NSError *err, id response) {
                      if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                          [Alert showFail:@"设置账单未缴状态成功！" View:self.navigationController.navigationBar andTime:3 complete:nil];
                          [self getRoomData];
                          
                      }else{
                          RequestBad
                      }
                  }];
                }];
              UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                  [ac dismissViewControllerAnimated:YES completion:nil];
              }];
              [ac addAction:ok];
              [ac addAction:cancel];
              
              [self presentViewController:ac animated:YES completion:nil];
              
              }];
          
             
          rentMoneyType.backgroundColor = MainRed;
          
          callPhone.backgroundColor = MainBlue;

          return @[callPhone,rentMoneyType];
       }else{
           callPhone.backgroundColor = MainBlue;
           
           return @[callPhone];
       }
    }else{
        return nil;
    }
    
}
//点击cell跳转到房间的账单信息
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >= self.selectedShowArray.count) {
        return;
    }
    ApartmentBillCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RoomBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomBill"];
    House* house = self.selectedShowArray[indexPath.section];
    vc.house = house;
    vc.billType = cell.payStatus.text;
    //获取租赁信息中的租客信息
   
    [self.navigationController pushViewController:vc animated:YES];
}
//重置所有的选择
-(void)resetSelect{
    for (int i = 0; i<selectBtnArr.count; i++) {
        UIButton *btn = selectBtnArr[i];
        btn.tag = 2;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    isSelectOverTime = false;
    isSelectWaitPay = false;
    isSelectHadPay = false;
    
    GBTagListView *tagView = billView.searchHistoryView.subviews[0];
    NSArray *btnArr = tagView.subviews;
    
    for (int i = 0; i <btnArr.count; i++) {
        UIButton *btn = btnArr[i];
        btn.selected = NO;
      
    }
    [tagList setTagWithCommunityArray:self.communityArray];
  
    self.selectedShowArray = [self.allHouseArray mutableCopy];
}
//添加标签的view
-(void)addTagView{
    if (tagList != nil) {
        [tagList removeFromSuperview];
        tagList = nil;
    }
    tagList=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 0, billView.searchHistoryView.width-30, billView.searchHistoryView.height)];
    /**允许点击 */
    tagList.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagList.canTouchNum=999;
    /**控制是否是单选模式 */
    tagList.isSingleSelect=NO;
    tagList.signalTagColor=[UIColor whiteColor];
    [tagList setTagWithCommunityArray:self.communityArray];
    
    __weak typeof(self) weakself = self;
    [tagList setDidselectItemBlock:^(NSArray *arr) {
        [weakself.tagSelectedHouseArray removeAllObjects];
        for (Community* community in arr) {
            [weakself.tagSelectedHouseArray addObjectsFromArray:community.houseInfoList];
        }
    }];
    
    [billView.searchHistoryView addSubview:tagList];
   

}
-(void)allSelectTagBtn:(UIButton *)sender{
    if (sender.tag == 1) {
        sender.tag = 2;
        GBTagListView *tagView = billView.searchHistoryView.subviews[0];
        NSArray *btnArr = tagView.subviews;
        for (int i = 0; i <btnArr.count; i++) {
            UIButton *btn = btnArr[i];
            btn.selected = YES;
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.titleEdgeInsets =UIEdgeInsetsMake(0, 20, 0, 0);
            NSArray *subviews = btn.subviews;
            NSLog(@"%@",subviews);
            UIImageView *rightIcon = subviews[2];
            rightIcon.hidden = NO;
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor =TDRGB(46, 126, 224).CGColor;
            btn.layer.cornerRadius = 2;
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
            rightIcon.frame  = CGRectMake(8, 7, 12, 8);
        }
    }else{
        GBTagListView *tagView = billView.searchHistoryView.subviews[0];
        NSArray *btnArr = tagView.subviews;
        for (int i = 0; i <btnArr.count; i++) {
            UIButton *btn = btnArr[i];
            btn.selected = NO;
            btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
            NSArray *subviews = btn.subviews;
            UIImageView *rightIcon = subviews[2];
            rightIcon.hidden = YES;
            btn.layer.borderWidth = 0;
            btn.layer.cornerRadius = 0;
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            
        }
        sender.tag = 1;
    }
    
}
//确定筛选内容
-(void)sureSelectTags{
    isSelect = false;
    [self.selectedShowArray removeAllObjects];
    [self.selectedShowArray addObjectsFromArray:self.tagSelectedHouseArray.count > 0 ? self.tagSelectedHouseArray :self.allHouseArray];
      NSMutableArray *selectArr = [NSMutableArray arrayWithCapacity:0];
    //筛选已缴费
    if (isSelectHadPay) {
        
        for (House* house in self.selectedShowArray) {
            if (house.billInfo.payBillStatus.integerValue == 1 && house.billInfo.payBillNotPay.floatValue == 0.00) {
                [selectArr addObject:house];
            }
        }
      
        
    }
    //筛选未缴费
    if (isSelectWaitPay) {
        
        for (House* house in self.selectedShowArray) {
             NSInteger compareDate = [self dateOut:house.billInfo.payBillEndTime];
            if (compareDate >= 0 && house.billInfo.payBillNotPay.floatValue != 0.00) {
                [selectArr addObject:house];
            }
        }
        
    }
    //筛选已逾期
    if (isSelectOverTime) {
        for (House* house in self.selectedShowArray) {
            NSInteger compareDate = [self dateOut:house.billInfo.payBillEndTime];
            if (compareDate < 0 && house.billInfo.payBillStatus.integerValue != 1) {
                [selectArr addObject:house];
            }
        }
        
    }
    if (isSelectHadPay || isSelectWaitPay || isSelectOverTime) {
        
        self.selectedShowArray = [selectArr mutableCopy];
    }
    
//    self.tableview.scrollEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        billView.x = self.view.width;
        bgView.alpha = 0;
    }];
    
    [self.tableview reloadData];
    
    
}

#pragma mark -m 点击叉，恢复原始
-(void)resetNavigationItem{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 33)];
    label.text = @"公寓账单";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18*ratio];
    label.centerX = self.view.centerX;
    label.centerY = self.navigationItem.titleView.centerY;
    self.navigationItem.titleView = label;
}
#pragma mark -m 跳转到SearchBillController
-(void)clickToSearch{
    SearchBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBill"];
    vc.wayIn = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickToSearchBar:(id)sender {
//    self.tableview.scrollEnabled = YES;
    [UIView animateWithDuration:0.25 animations:^{
        billView.x = self.view.width;
        bgView.alpha = 0;
    }];
    SearchBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBill"];
    vc.wayIn = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -m 点击了搜索，添加搜索bar到navigation中
-(void)addSearchBar:(NSNotification *)info{
    isSearch =true;
    searchBarView *searchView = [[NSBundle mainBundle] loadNibNamed:@"BillSelectView" owner:self options:nil][1];
    [searchView.endSearch addTarget:self action:@selector(resetNavigationItem) forControlEvents:UIControlEventTouchUpInside];
    searchView.searchContent.text = info.object;
    searchView.searchContent.font = [UIFont systemFontOfSize:14*ratio];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSearch)];
    [searchView.searchContent addGestureRecognizer:tap];
    searchView.layer.cornerRadius = 10;
    self.navigationItem.titleView = searchView;
    //对数据进行筛选
    NSMutableArray *selectArr = [NSMutableArray array];
    
    for (House* house in self.allHouseArray) {
        NSString* mainName = @"";
        NSString *mainRenterPhone = @"";
        Rent* rent = house.rentInfo[0];
        if (rent.renterInfo.count > 0) {
            for (Renter *renter in rent.renterInfo) {
                if ([renter.renterRoleID isEqual:@1]) {
                    mainName = renter.renterTrueName;
                    mainRenterPhone = renter.renterPhone.stringValue;
                    break;
                }
                
            }
        }
        if ([house.houseNum.stringValue rangeOfString:info.object].location != NSNotFound) {
            [selectArr addObject:house];
        }else if([mainName rangeOfString:info.object].location != NSNotFound && mainName.length > 0){
            [selectArr addObject:house];
        }else if ([mainRenterPhone rangeOfString:info.object].location != NSNotFound && mainRenterPhone.length > 0 ){
            [selectArr addObject:house];
        }
    }
    
    
    self.selectedShowArray = selectArr;
    
    [self.tableview reloadData];
    
}

///-----------------------------三个按钮-------------------------------//
-(void)selectOneBtn:(UIButton *)btn{
    if(!isSelectOverTime){
        btn.tag = 2;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        isSelectOverTime = true;
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
    }else{
        isSelectOverTime = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
        
    }
}
-(void)selectTwoBtn:(UIButton *)btn{
    if(!isSelectWaitPay){
        btn.tag = 2;
        isSelectWaitPay = true;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
    }else{
        isSelectWaitPay = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
    }
  
}
-(void)selectThreeBtn:(UIButton *)btn{
    if(!isSelectHadPay){
        btn.tag = 2;
        isSelectHadPay = true;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 16, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
        [btn setTitleColor:MainBlue forState:UIControlStateNormal];
    }else{
        isSelectHadPay = false;
        btn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.tag = 1;
    }
    
}
///----------------按照公寓名——-------------------///
-(void)arrayByName:(UIButton *)btn{
    NSSortDescriptor *moneyWithSort;
    NSSortDescriptor *moneyWithSort1;
    if (btn.tag != 1) {
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:NO];
         moneyWithSort1  =[[NSSortDescriptor alloc]initWithKey:@"houseNum" ascending:YES];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort,moneyWithSort1, nil];
        self.selectedShowArray = [[self.selectedShowArray sortedArrayUsingDescriptors:elementarr] mutableCopy];
    }else{
        moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"communityName" ascending:YES];
         moneyWithSort1  =[[NSSortDescriptor alloc]initWithKey:@"houseNum" ascending:NO];
        NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort,moneyWithSort1, nil];
        self.selectedShowArray = [[self.selectedShowArray sortedArrayUsingDescriptors:elementarr] mutableCopy];
    }
    
}

///------------------------------按照日期排序------------------------------------------//
-(void)arrayByDate :(UIButton *)btn{
    if (btn.tag != 1) {
        self.selectedShowArray = [[self.selectedShowArray sortedArrayUsingSelector:@selector(compareHouseByTime:)] mutableCopy];
    }else{
       self.selectedShowArray = [[self.selectedShowArray sortedArrayUsingSelector:@selector(compareHouseByTime:)] mutableCopy];
        self.selectedShowArray = [self arrayByTurn:self.selectedShowArray];
    }
}


///-----------------------------按照金额排序------------------------------------------//
-(void)arrayByMoney :(UIButton *)btn{
    self.selectedShowArray = [[self.selectedShowArray sortedArrayUsingComparator:^NSComparisonResult(House* obj1, House* obj2)
                          {
                              float  value1 = obj1.billInfo.payBillNotPay.floatValue + obj1.billInfo.payBillFreezingPay.floatValue;
                              float  value2 = obj2.billInfo.payBillNotPay.floatValue + obj2.billInfo.payBillFreezingPay.floatValue;
                        
                              if (btn.tag == 1) {
                                  return value1 > value2 ? NSOrderedAscending : NSOrderedDescending;
                    
                              }else{
                            
                                 return value1 < value2 ? NSOrderedAscending : NSOrderedDescending;
                              }
                             
                          }] mutableCopy];
  
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

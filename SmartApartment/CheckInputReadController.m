//
//  CheckInputReadController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "CheckInputReadController.h"
#import "HouseInputCell.h"
@interface CheckInputReadController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *blueLine;
@property (weak, nonatomic) IBOutlet UIButton *roomBtn;
@property (weak, nonatomic) IBOutlet UIButton *roomDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *comNameLabel;

@end

@implementation CheckInputReadController
{
    //按名称排序还算是按日期排序
    BOOL byName;
    //房间数据数组
    NSMutableArray *roomArr;
    //房间层
    NSMutableDictionary *roomHighDic;
    
    //时间戳数组
    NSMutableArray *billTimeArr;
    //时间戳房间字典
    NSMutableDictionary *roomBillDic;
    //tableview的滚动高度
    CGFloat tableHeight;
    //所有cell的数组
    NSMutableArray *cellArr;
    //所有的租赁ID
    NSMutableArray *rentIDArr;
  
    //临时保存tableview的offset
    CGPoint tableContentOffset;
}
- (void)viewDidLoad {
    [super viewDidLoad];

  self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
-(void)viewDidDisappear:(BOOL)animated{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    roomHighDic = [NSMutableDictionary dictionaryWithCapacity:0];
    roomArr = [NSMutableArray arrayWithCapacity:0];
    roomBillDic = [NSMutableDictionary dictionaryWithCapacity:0];
    billTimeArr = [NSMutableArray arrayWithCapacity:0];
    cellArr = [NSMutableArray arrayWithCapacity:0];
    rentIDArr = [NSMutableArray arrayWithCapacity:0];

    //蓝色线条一开始修改位置
    self.blueLine.centerX = self.roomBtn.centerX;
    self.blueLine.width = 150*ratio;
    byName = true;
    if ([self.wayIn isEqualToString:@"电费"]) {
        self.title = [NSString stringWithFormat:@"电费抄表"];
        
    }else{
        self.title =[NSString stringWithFormat:@"水费抄表"];
    }
    self.comNameLabel.text  = self.community.communityName;
    [self getAllRoomRead];
}
- (IBAction)clickToPop:(id)sender {
    [PopHome popToController:@"CheckHomeController" andVC:self];
}

//点击了按房间名称排序
- (IBAction)clickByRoomName:(id)sender {
   //动画方式移动
    [self.roomDate setTitleColor:TDRGB(153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [self.roomBtn setTitleColor:MainBlue forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
         self.blueLine.centerX = self.roomBtn.centerX;
    }];
    byName = YES;
    [self.tableView reloadData];
}
//点击了按账单名称排序
- (IBAction)clickByDate:(id)sender {
    [self.roomBtn setTitleColor:TDRGB(153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [self.roomDate setTitleColor:MainBlue forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.blueLine.centerX = self.roomDate.centerX;
    }];
    byName = false;
    [self.tableView reloadData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HouseInputCell"];
    cell.curInput.delegate = self;
    //将数据添加到数组中--录入水电
  
    NSMutableDictionary *IDDic = [NSMutableDictionary dictionaryWithCapacity:0];

    
    NSDictionary *roomData;
    if (byName) {
        roomData = [roomHighDic objectForKey:roomArr[indexPath.section]][indexPath.row];
      
    }else{
        roomData = [roomBillDic objectForKey:billTimeArr[indexPath.section]][indexPath.row];
    }
    @try {
        
    
    
    NSString *houseStatus =[NSString stringWithFormat:@"%@", [roomData objectForKey:@"houseStatus"]];
    if ([houseStatus isEqualToString:@"1"]) {
        [cellArr addObject:cell];
            [IDDic setObject:[[roomData   objectForKey:@"rentInfo"][0] objectForKey:@"rentRecordID"] forKey:@"rentRecordID"]   ;
        
            [IDDic setObject:[roomData    objectForKey:@"houseID"] forKey:@"houseID"];
            [IDDic setObject:[roomData   objectForKey:@"houseNum"] forKey:@"houseNum"];
            [rentIDArr addObject:IDDic];
        }
    } @catch (NSException *exception) {
        NSLog(@"没有租赁信息--%@",exception);
    } @finally {
        
    }
    if ([self.wayIn isEqualToString:@"电费"]) {
        [self setDataByDian:cell andDic:roomData];
    }else{
        [self setDataByWater:cell andDic:roomData];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  32*ratio;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (byName) {
        NSArray *arr = [roomHighDic objectForKey:roomArr[section]];
        return arr.count;
    }else{
        NSArray *arr = [roomBillDic objectForKey:billTimeArr[section]];
        return arr.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (byName) {
        return roomHighDic.count;
    }else{
        return roomBillDic.count;
    }
}


- (void)textFieldDidBeginEditing:(nonnull UITextField *)textField{
    UITableViewCell * cell=(UITableViewCell *)[[textField  superview] superview];
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    if (indexPath.section==0) {
        
    }else {
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:0.30f];
        tableContentOffset = self.tableView.center;
        self.tableView.center = CGPointMake(self.view.width/2, 120);
        [UIView commitAnimations];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell * cell=(UITableViewCell *)[[textField  superview] superview];
    NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
    if (indexPath.section==0) {
        
    }else {
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:0.30f];
        self.tableView.center = tableContentOffset;
        [UIView commitAnimations];
    }
}


//定义sectionHeader的样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7 *ratio, 17*ratio)];
    if (section%3==0) {
         smallView.backgroundColor = MainBlue;
    }else if (section%3 == 1){
        smallView.backgroundColor = MainRed;
    }else{
        smallView.backgroundColor = MainGreen;
    }
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    if (byName) {
        //根据点击的按钮进行排序
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSString *highStr = [NSString stringWithFormat:@"%@",roomArr[section]];
        formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
        NSString *highNum = [formatter stringFromNumber:[NSNumber numberWithInteger:highStr.integerValue]];
        label.text = [NSString stringWithFormat:@"%@层",highNum];
    }else{
        
        
        label.text = [NSString stringWithFormat:@"%@号",billTimeArr[section]];
        
        if ([[NSString stringWithFormat:@"%@",billTimeArr[section]] isEqualToString:@"0"]) {
            label.text = @"未入住租客";
        }
    }
    label.font = [UIFont systemFontOfSize:14 *ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    //中间的label
    UILabel *centerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 32*ratio)];
    centerLab.text = @"上期读数";
    centerLab.textColor = TDRGB(136.0, 136.0, 136.0);
    centerLab.centerX = view.centerX-10;
    centerLab.font = [UIFont systemFontOfSize:14*ratio];
    centerLab.textAlignment = NSTextAlignmentCenter;
    //右边的label
    UILabel *rightLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 32*ratio)];
    rightLab.text = @"本期读数";
    rightLab.textColor = TDRGB(136.0, 136.0, 136.0);
    rightLab.x = view.width - 21 -65;
    rightLab.font = [UIFont systemFontOfSize:14*ratio];
    rightLab.textAlignment = NSTextAlignmentCenter;
    //添加控件
    [view addSubview:centerLab];
    [view addSubview:rightLab];
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}
#pragma mark -m 获取电表读数
-(void)getAllRoomRead{
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",self.community.communityID,@"communityID", nil];
    [WebAPI getCommunityRecord:dic callback:^(NSError *err, id response) {
        @try {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
             NSArray   *roomarr = [response objectForKey:@"data"];
                for (int i = 0; i <roomarr.count; i++) {
                    NSDictionary *roomDic = roomarr[i];
                    NSArray *roomHigh = [roomHighDic objectForKey:[roomDic objectForKey:@"houseHightNum"]];
                    if (roomHigh.count <=0) {
                        NSArray *arr = [NSArray arrayWithObject:roomDic];
                        [roomHighDic setObject:arr forKey:[roomDic objectForKey:@"houseHightNum"]];
                        [roomArr addObject:[roomDic objectForKey:@"houseHightNum"]];
                    }else{
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                        NSMutableArray *oldRoomArr =  [roomHighDic objectForKey:[roomDic objectForKey:@"houseHightNum"]];
                        [arr addObject:roomDic];
                        for (int i = 0; i < oldRoomArr.count; i++) {
                            [arr addObject:oldRoomArr[i]];
                        }
                        [roomHighDic setObject:arr forKey:[roomDic objectForKey:@"houseHightNum"]];
                    }
                    NSArray *roomBill ;
                    NSString *houseStatus = [NSString stringWithFormat:@"%@",[roomDic objectForKey:@"houseStatus"]];
                    if (houseStatus.integerValue == 1) {
                          int Number = [[TimeDate timeWithTimeIntervalString:[roomDic objectForKey:@"billTime"]] substringFromIndex:8].intValue;
                        roomBill = [roomBillDic objectForKey:[NSString stringWithFormat:@"%d",Number]];
                    }else{
                        roomBill = [roomBillDic objectForKey:@"0"];
                    }

                    if (roomBill.count <=0) {
                        NSArray *arr = [NSArray arrayWithObject:roomDic];
                            NSDictionary *dic = arr[0];
                            NSString *houseState = [dic objectForKey:@"houseStatus"];
                            if (houseState.integerValue == 1) {
                                 int Number = [[TimeDate timeWithTimeIntervalString:[roomDic objectForKey:@"billTime"]] substringFromIndex:8].intValue;
                                [roomBillDic setObject:arr forKey:[NSString stringWithFormat:@"%d",Number]];
                                [billTimeArr addObject:[roomDic objectForKey:@"billTime"]];
                            }else{
                                [roomBillDic setObject:arr forKey:@"0"];
                                [billTimeArr addObject:@"0"];
                            }
                        
                        
                    }else{
                        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                        NSString *houseState = [roomDic objectForKey:@"houseStatus"];
                        if (houseState.integerValue == 1) {
                            int Number = [[TimeDate timeWithTimeIntervalString:[roomDic objectForKey:@"billTime"]] substringFromIndex:8].intValue;
                             NSMutableArray *oldRoomArr =  [roomBillDic objectForKey:[NSString stringWithFormat:@"%d",Number]];
                            [arr addObject:roomDic];
                            for (int i = 0; i < oldRoomArr.count; i++) {
                                [arr addObject:oldRoomArr[i]];
                            }
                            
                            [roomBillDic setObject:arr forKey:[NSString stringWithFormat:@"%d",Number]];
                        }else{
                            NSMutableArray *oldRoomArr = [roomBillDic objectForKey:@"0"];
                            [arr addObject:roomDic];
                            for (int i = 0; i < oldRoomArr.count; i++) {
                                [arr addObject:oldRoomArr[i]];
                            }
                            [roomBillDic setObject:arr forKey:@"0"];
                        }
                    }
                }
                [self roomDicByHighNum];
                [self roomDicByBillTime];
                
            }else{
                //网络请求错误情况
                RequestBad
            }
            
        } @catch (NSException *exception) {
            NSLog(@"抄表中数据错误---%@",exception);
        } @finally {
            NSLog(@"获取数据结束");
            [self.tableView reloadData];
            tableHeight = self.tableView.contentSize.height;
        }
        
        
    }];
}
//根据层排序
-(void)roomDicByHighNum{
    
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    NSArray *resultArray = [roomArr sortedArrayUsingComparator:finderSort];
    
    roomArr = [NSMutableArray arrayWithArray:resultArray];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i <roomArr.count; i++) {
        NSArray *newArr =  [[[roomHighDic objectForKey:roomArr[i]] reverseObjectEnumerator] allObjects];
        [newDic setObject:newArr forKey:roomArr[i]];
    }
    roomHighDic = newDic;
    
}
//根据账单时间排序
-(void)roomDicByBillTime{
    
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] < [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }else if ([string1 integerValue] > [string2 integerValue]){
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    //数组排序：
    NSMutableArray *billArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < billTimeArr.count; i++) {
        if (![[NSString stringWithFormat:@"%@",billTimeArr[i]] isEqualToString:@"0"]) {
            int Number = [[TimeDate timeWithTimeIntervalString:billTimeArr[i]] substringFromIndex:8].intValue;
            [billArr addObject:[NSString stringWithFormat:@"%d",Number]];
        }
        else{
            [billArr addObject:@"0"];
        }
        
        
    }
   
    NSArray *resultArray = [billArr sortedArrayUsingComparator:finderSort];
    
    billArr = [NSMutableArray arrayWithArray:resultArray];
    billTimeArr = [NSMutableArray arrayWithArray:billArr];
    [billTimeArr removeObject:@"0"];
    [billTimeArr addObject:@"0"];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i <billTimeArr.count; i++) {
        
        NSArray *newArr = [[[roomBillDic objectForKey:billTimeArr[i]]reverseObjectEnumerator] allObjects] ;
        [newDic setObject:newArr forKey:billTimeArr[i]];
    }
//    NSArray *arr = [newDic objectForKey:@"0"];
//    [newDic removeObjectForKey:@"0"];
//    [newDic setObject:arr forKey:@"0"];
    roomBillDic = newDic;
    
}




//设置水电数据----------------------------------------------//
-(void)setDataByDian:(HouseInputCell *)cell andDic:(NSDictionary *)roomData{
    cell.roomName.text = [NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseNum"]];

    cell.preRead.text  = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[roomData objectForKey:@"preElectricRecord"]].floatValue];
   
    if ([NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseStatus"]].integerValue == 1) {
        cell.curInput.enabled = YES;
        if ([NSString stringWithFormat:@"%@",[roomData objectForKey:@"curElectricRecord"]].integerValue == 0) {
            NSString *holderText = @"输入读数";
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
            [placeholder addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:16*ratio]
                                range:NSMakeRange(0, holderText.length)];
            cell.curInput.attributedPlaceholder = placeholder;
            cell.curInput.text = @"";

        }else{
            cell.curInput.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[roomData objectForKey:@"curElectricRecord"]].floatValue];
        }
    }else{
        NSString *holderText = @"未入住";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16*ratio]
                            range:NSMakeRange(0, holderText.length)];
        cell.curInput.attributedPlaceholder = placeholder;

        cell.curInput.enabled = NO;
        cell.curInput.text = @"";
    }
    
}
-(void)setDataByWater:(HouseInputCell *)cell andDic:(NSDictionary *)roomData{
    cell.roomName.text = [NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseNum"]];
        cell.preRead.text  = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[roomData objectForKey:@"preWaterRecord"]].floatValue];
    if ([NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseStatus"]].integerValue == 1) {
        cell.curInput.enabled = YES;
        if ([NSString stringWithFormat:@"%@",[roomData objectForKey:@"curWaterRecord"]].integerValue == 0) {
            NSString *holderText = @"输入读数";
            NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
            [placeholder addAttribute:NSFontAttributeName
                               value:[UIFont systemFontOfSize:16*ratio]
                               range:NSMakeRange(0, holderText.length)];
            cell.curInput.attributedPlaceholder = placeholder;
            cell.curInput.text = @"";
        }else{
            cell.curInput.text =[NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[roomData objectForKey:@"curWaterRecord"]].floatValue];
        }
    }else{
        NSString *holderText = @"未入住";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:holderText];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:16*ratio]
                            range:NSMakeRange(0, holderText.length)];
        cell.curInput.attributedPlaceholder = placeholder;
        cell.curInput.enabled = NO;
    }
}
#pragma mark -m 确认录入
- (IBAction)sureInput:(UIButton *)sender {
    
    NSMutableArray *jsonArr = [NSMutableArray arrayWithCapacity:0];
        for (int i= 0; i<rentIDArr.count; i++) {
            
            NSDictionary *rentArrDic =rentIDArr[i];
           
                
                NSString *rentID = [NSString stringWithFormat:@"%@",[rentArrDic objectForKey:@"rentRecordID"]];
                NSString *houseID = [NSString stringWithFormat:@"%@",[rentArrDic objectForKey:@"houseID"]];
                NSString *houseNum = [NSString stringWithFormat:@"%@",[rentArrDic objectForKey:@"houseNum"]];
                HouseInputCell *cellView1 = cellArr[i];
            if (cellView1.curInput.text.length >=1) {
                NSString *electricRecordValue = cellView1.curInput.text;
                NSDictionary *jsonDic;
                if ([self.wayIn isEqualToString:@"电费"]) {
                    jsonDic = [[NSDictionary alloc] initWithObjectsAndKeys:rentID,@"rentRecordID",houseID,@"houseID",electricRecordValue,@"electricRecordValue",houseNum,@"houseNum", nil];
                }else{
                    jsonDic = [[NSDictionary alloc] initWithObjectsAndKeys:rentID,@"rentRecordID",houseID,@"houseID",electricRecordValue,@"waterRecordValue",houseNum,@"houseNum", nil];
                }
                [jsonArr addObject:jsonDic];
            }
            
           
            
        }
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:jsonArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *recordData =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    recordData = [recordData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"comID"],@"communityID",recordData,@"houseRecordData",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",nil];
    
    if ([self.wayIn isEqualToString:@"电费"]) {
        sender.userInteractionEnabled = NO;
        [WebAPI recordHouseElectric:dic callback:^(NSError *err, id response) {
            if(!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000){
                [Alert showFail:@"录入成功!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                sender.userInteractionEnabled = YES;
            }
            else{
                [jsonArr removeAllObjects];
                if (err) {
                    [Alert showFail:@"网络异常" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                        
                    }];
                }
                else{
                   RequestBad
                }
                sender.userInteractionEnabled = YES;
            }
        }];
    }else{
        [WebAPI recordHouseWater:dic callback:^(NSError *err, id response) {
            if(!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000){
                [Alert showFail:@"录入成功!" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else{
                [jsonArr removeAllObjects];
                if (err) {
                    [Alert showFail:@"网络异常" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                        
                    }];
                }
                else{
                  RequestBad
                }
            }
            
        }];
    }

}


@end

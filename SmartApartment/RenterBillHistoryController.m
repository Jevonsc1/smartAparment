
//
//  RenterBillHistoryController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/2.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "RenterBillHistoryController.h"
#import "BillMonthCell.h"
#import "Bill.h"
@interface RenterBillHistoryController ()

@end

@implementation RenterBillHistoryController
{
    NSMutableDictionary *newBillDic;
    NSMutableArray *yearArr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    yearArr = [NSMutableArray arrayWithCapacity:0];
    newBillDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (Bill* bill in self.billArr) {
        NSString *year = bill.payBillTime;
        year = [[TimeDate timeToTimeSp:year] substringToIndex:4];
        NSArray *billdic = [newBillDic objectForKey:year];
        if (billdic.count <= 0) {
            [yearArr addObject:year];
            NSArray *arr = [NSArray arrayWithObject:bill];
            [newBillDic setObject:arr forKey:year];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithArray:billdic];
            [arr addObject:bill];
            [newBillDic setObject:arr forKey:year];
        }
    }
   
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [newBillDic objectForKey:[NSString stringWithFormat:@"%@",yearArr[indexPath.section]]];
    Bill *bill = arr[indexPath.row];
    [self.delegate passValueForBill:bill];
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = [newBillDic objectForKey:[NSString stringWithFormat:@"%@",yearArr[indexPath.section]]];
    Bill *bill = arr[indexPath.row];
    NSString *time = [NSString stringWithFormat:@"%@",[TimeDate timeToTimeSp:bill.payBillTime]];
    time = [[time substringFromIndex:4] substringToIndex:2];
    BillMonthCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BillMonthCell"];
    cell.month.text = [NSString stringWithFormat:@"%@月",time];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7.5f *ratio, 17*ratio)];
    smallView.backgroundColor = MainBlue;
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    NSString *highStr = [NSString stringWithFormat:@"%@",yearArr[section]];
  
    
    label.text = [NSString stringWithFormat:@"%@年",highStr];
    label.font = [UIFont systemFontOfSize:14*ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return newBillDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *year = yearArr[section];
    NSArray *arr = [newBillDic objectForKey:year];
    return arr.count;
}

@end

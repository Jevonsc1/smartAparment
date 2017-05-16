//
//  RoomDianDetailController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/12.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RoomDianDetailController.h"

@interface RoomDianDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *billTwoTime;
@property (weak, nonatomic) IBOutlet UILabel *orgReadNum;
@property (weak, nonatomic) IBOutlet UILabel *preReadNum;
@property (weak, nonatomic) IBOutlet UILabel *curReadNum;
@property (weak, nonatomic) IBOutlet UILabel *feeUnit;
@property (weak, nonatomic) IBOutlet UILabel *curCost;
@property (weak, nonatomic) IBOutlet UILabel *curMoney;


@end

@implementation RoomDianDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
   
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",self.houseID,@"houseID",self.monthDate,@"monthDate", nil];
    if (self.wayIn == 1) {
        self.title  = @"电费详情";
        [WebAPI getHouseElectricDetail:dic callback:^(NSError *err, id response) {
            NSLog(@"%@",response);
            if ([response intForKey:@"rcode"] == 10000&&!err) {
                NSDictionary *dic = [response objectForKey:@"data"];
                if (dic.count >0) {
                    self.billTwoTime.text = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[[dic objectForKey:@"billCycle"] objectForKey:@"startTime"]],[TimeDate timeWithTimeIntervalString:[[dic objectForKey:@"billCycle"] objectForKey:@"endTime"]]];
                    self.orgReadNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"houseInitElectric"]].floatValue];
                    self.preReadNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"preElectricRecord"]].floatValue];
                    self.curReadNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"curElectricRecord"]].floatValue];
                    self.feeUnit.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"houseElectricUnitPrice"]];
                    self.curCost.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"curElectricUse"]];
                    self.curMoney.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"curElectricCost"]];
                }else{
                    [Alert showFail:@"本月没有录入电表读数" View:self.navigationController.navigationBar andTime:3 complete:nil];
                }
                //
            }else{
                RequestBad
            }
        }];
        
    }else{
        self.title = @"水费详情";
        [WebAPI getHouseWaterDetail:dic callback:^(NSError *err, id response) {
            if ([NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000&&!err) {
                NSDictionary *dic = [response objectForKey:@"data"];
                if (dic.count >0) {
                    self.billTwoTime.text = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[[dic objectForKey:@"billCycle"] objectForKey:@"startTime"]],[TimeDate timeWithTimeIntervalString:[[dic objectForKey:@"billCycle"] objectForKey:@"endTime"]]];
                    self.orgReadNum.text =[NSString stringWithFormat:@"%.2f", [NSString stringWithFormat:@"%@",[dic objectForKey:@"houseInitWater"]].floatValue];
                    self.preReadNum.text = [NSString stringWithFormat:@"%.2f",[NSString stringWithFormat:@"%@",[dic objectForKey:@"preWaterRecord"]].floatValue];
                    self.curReadNum.text =  [NSString stringWithFormat:@"%.2f", [NSString stringWithFormat:@"%@",[dic objectForKey:@"curWaterRecord"]].floatValue];
                    self.feeUnit.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"houseWaterUnitPrice"]];
                    self.curCost.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"curWaterUse"]];
                    self.curMoney.text = [NSString stringWithFormat:@"¥%@",[dic objectForKey:@"curWaterCost"]];
                }else{
                    [Alert showFail:@"本月没有录入水表读数" View:self.navigationController.navigationBar andTime:3 complete:nil];
                }
            }else{
                RequestBad
            }
        }];
    }

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7 *ratio, 17*ratio)];
    
    
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
        label.text = @"记账周期";
        smallView.backgroundColor = MainBlue;
    }else if(section == 1){
        label.text = @"电表读数";
        smallView.backgroundColor = MainRed;
    }else if(section == 2){
        label.text = @"费用计算";
        smallView.backgroundColor = MainGreen;
    }
    
    
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

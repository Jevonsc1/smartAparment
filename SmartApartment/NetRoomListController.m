//
//  NetRoomListController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/1.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "NetRoomListController.h"
#import "TemRoomCell.h"
#import "RenterTemController.h"
@interface NetRoomListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NetRoomListController
{
    //每一层多少个房间
    NSMutableArray *houseMutableArr;
    //一共有多少层
    NSMutableArray *allHouseArr;
    NSInteger maxHighNum;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    houseMutableArr = [NSMutableArray arrayWithCapacity:0];
    allHouseArr = [NSMutableArray arrayWithCapacity:0];
    
    if (self.houseArr.count > 0) {
        NSMutableArray *highNum = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i <self.houseArr.count; i++) {
            NSDictionary *dic = self.houseArr[i];
            [highNum addObject:[dic objectForKey:@"houseHightNum"]];
        }
        //获取最大层数
        maxHighNum = [[highNum valueForKeyPath:@"@max.intValue"] integerValue];
        //获取每层房间以及共计多少层
        for (int i = 0; i<maxHighNum; i++) {
            houseMutableArr = [NSMutableArray arrayWithCapacity:0];
            for (int j = 0; j<self.houseArr.count; j++) {
                NSDictionary *houseDic = self.houseArr[j];
                NSInteger num = i +1;
                if([[NSString stringWithFormat:@"%@",[houseDic objectForKey:@"houseHightNum"]] isEqualToString:[NSString stringWithFormat:@"%ld",(long)num]] ){
                    [houseMutableArr addObject:houseDic];
                }
              
            }
            [allHouseArr addObject:houseMutableArr];
         
        }
        [self.tableView reloadData];
        
    }else{
        [Alert showFail:@"该公寓没有房间开通宽带!" View:self.navigationController.navigationBar andTime:3 complete:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return maxHighNum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *arr = allHouseArr[section];
    if (arr.count <= 0) {
        return 0.01f;
    }
    return 25;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = allHouseArr[section];
    return arr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30*ratio)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(17, 8.5*ratio, self.view.width - 20, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    label.text = [NSString stringWithFormat:@"%ld层",section+1];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TemRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TemRoom" forIndexPath:indexPath];
    NSDictionary *dic = allHouseArr[indexPath.section][indexPath.row];
    
    cell.roomNum.text = [NSString stringWithFormat:@"%@房间",[dic objectForKey:@"houseNum"]];
    //房间租赁---1--已出租
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"houseStatus"]].integerValue == 1) {
        NSArray *rentInfo = [dic objectForKey:@"rentInfo"];
        
        if (rentInfo.count > 0) {
            
            NSArray *renterArr = [rentInfo[0] objectForKey:@"renterInfo"];
            for (int i = 0; i<renterArr.count; i++) {
                NSDictionary *rentTemDic = renterArr[i];
                //获取每个租客的宽带信息
                NSArray *temArr = [rentTemDic objectForKey:@"telecomInfo"];
                if(temArr.count > 0 ){
                    NSDictionary *temDic = temArr[0];
                    //最高优先级--即将到期
                    NSString *temEndTime = [self dateOut:[temDic objectForKey:@"telecomEndTime"] rentTime:nil];
                    if ([NSString stringWithFormat:@"%@",[temDic objectForKey:@"telecomIsDisable"]].integerValue == 0) {
                        if (temEndTime ) {
//                            if (![temEndTime isEqualToString:@"未开通"]&&![temEndTime isEqualToString:@"已过期"]) {
                                cell.temStatus.text = temEndTime;
                                cell.temStatus.textColor =[UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                                [cell.icon setImage:[UIImage imageNamed:@"cycRed"]];
//                                
//                            }else{
//                                cell.temStatus.text = @"未开通";
//                                cell.temStatus.textColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
//                                [cell.icon setImage:[UIImage imageNamed:@"cycRed"]];
//                            }
                        }else{
                            cell.temStatus.text = @"开通中";
                            cell.temStatus.textColor = [UIColor colorWithRed:103.0/255.0 green:161.0/255.0 blue:35.0/255.0 alpha:1];
                            [cell.icon setImage:[UIImage imageNamed:@"cycGreed"]];
                        }
                    }else{
                        if([temEndTime isEqualToString:@"未开通"]){
                            cell.temStatus.text = @"未开通";
                            cell.temStatus.textColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                            [cell.icon setImage:[UIImage imageNamed:@"cycRed"]];
                        }else{
                            cell.temStatus.text = @"已过期";
                            cell.temStatus.textColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                            [cell.icon setImage:[UIImage imageNamed:@"cycRed"]];
                        }
                   
                    }
                }else{
                    cell.temStatus.text = @"未开通";
                    cell.temStatus.textColor = [UIColor colorWithRed:229.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1];
                    [cell.icon setImage:[UIImage imageNamed:@"cycRed"]];
                    
                }
                
            }

        }
    
    
    }else{
        cell.temStatus.text = @"空置";
        cell.temStatus.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        [cell.icon setImage:[UIImage imageNamed:@"cycGray"]];
    }
   
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TemRoomCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    RenterTemController *vc = [[UIStoryboard storyboardWithName:@"message" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterTem"];
    if ([cell.temStatus.text isEqualToString:@"空置"]) {
        [Alert showFail:@"房间空置，无法显示宽带信息!" View:self.navigationController.navigationBar andTime:3 complete:nil];
        return;
    }else if ([cell.temStatus.text isEqualToString:@"未开通"]){
        //显示主租客信息
        vc.netStates = @"1";
    }else{
        vc.netStates = @"2";
    }
    vc.netType = cell.temStatus.text;
    vc.renterArr = allHouseArr[indexPath.section][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
- (NSString *)dateOut:(NSString*)dueTimeString rentTime:(NSString*)rentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    
    //当前时间
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate *bbEndDate = [NSDate dateWithTimeIntervalSince1970:[dueTimeString intValue]];
    
    //到期时间
    NSString *dueTime = [TimeDate timeWithTimeIntervalString:dueTimeString];
    dueTime = [dueTime stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //相差几天
    NSInteger compareDate = [self bbCompareTwoDateWithBeginDate:currentDate
                                                            end:bbEndDate];
    if(compareDate <5){
        NSString *string;
        if (compareDate>=0) {
            string = dueTime;
            NSString *year = [string substringToIndex:4];
            NSString *month = [[string substringFromIndex:4] substringToIndex:2];
            NSString *day = [string substringFromIndex:6];
            string = [NSString stringWithFormat:@"%@年%@月%@日到期",year,month,day];
        }else if(compareDate < -5){
            string = @"未开通";
        }else if(compareDate >=-5 &&compareDate <0){
            string = @"已过期";
        }
        return string;
    }else{
        return nil;
    }
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

@end

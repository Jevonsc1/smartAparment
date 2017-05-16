//
//  RenterAccessMsgController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "RenterAccessMsgController.h"
#import "AccessManagerController.h"
#import "OutInRecordController.h"
#import "UIImageView+WebCache.h"
#import "RoomBillController.h"
@interface RenterAccessMsgController ()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userNAME;
@property (weak, nonatomic) IBOutlet UIImageView *sexIcon;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *authenStatus;
@property (weak, nonatomic) IBOutlet UIImageView *authenIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterType;
@property (weak, nonatomic) IBOutlet UILabel *roomName;
@property (weak, nonatomic) IBOutlet UILabel *billStatus;
@property (weak, nonatomic) IBOutlet UILabel *openDoorTime;
@property (weak, nonatomic) IBOutlet UIButton *deletRenterBtn;

@end

@implementation RenterAccessMsgController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, 20)];
    blackView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackView];
    self.deletRenterBtn.layer.borderWidth = 1;
    self.deletRenterBtn.layer.borderColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1].CGColor;
    self.deletRenterBtn.layer.cornerRadius = 8;
    self.tableView.scrollEnabled = NO;
    NSString *idNum = self.renter.renterIDCardNum;
    if (idNum==nil || idNum.length == 0) {
        self.authenIcon.hidden = NO;
        self.authenStatus.text = @"未认证";
    }else{
        self.authenIcon.hidden = YES;
        self.authenStatus.text = idNum;
    }
    //设置头像
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.renter.renterMemberAvatar] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    NSString *trueName = self.renter.renterTrueName;
    if (trueName.length == 0 || trueName == nil) {
        self.userNAME.text = self.renter.memberName;
    }else{
        self.userNAME.text = trueName;
    }
    if (self.renter.renterPhone.stringValue.length == 0 || self.renter.renterPhone == nil ) {
        self.userPhone.text = @"";
    }else{
        self.userPhone.text = self.renter.renterPhone.stringValue;
    }
    if ([self.renter.renterRoleID isEqual:@1]) {
        self.renterType.text = @"主租客";
        self.deletRenterBtn.hidden=YES;
    }else{
        self.renterType.text = @"一般租客";
        self.deletRenterBtn.hidden = NO;
    }
    self.roomName.text = self.renter.houseName;
     NSString *payBillEndTime =self.renter.payBillEndTime.stringValue;
    if (payBillEndTime.integerValue == 0) {
        self.billStatus.text = @"暂无账单";
    }else{
        if ([self.renter.payBillComplete isEqual:@1]) {
            self.billStatus.text = @"结清";
            self.billStatus.textColor = MainGreen;
        }else{
            if (self.payDayNum >=0) {
                self.billStatus.text = @"待缴";
                self.billStatus.textColor = TDRGB(245.0, 166.0, 35.0);
            }else{
                self.billStatus.text = @"欠费";
                self.billStatus.textColor = MainRed;
                
            }
        }
    }
    NSString *acList =self.renter.acLastestLogTime.stringValue;
    if (acList.integerValue != 0) {
        NSString *outinTime = acList;
        self.openDoorTime.text = [TimeDate timeDetailWithTimeIntervalString:outinTime];
    }else{
        self.openDoorTime.text = @"暂无出入记录";
    }
 
    self.userIcon.layer.cornerRadius = self.userIcon.width*ratio/2;
    self.userIcon.layer.masksToBounds = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    
   
}
-(void)viewWillAppear:(BOOL)animated{
   
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 193*ratio;
    }else{
        return cellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        AccessManagerController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"AccessManager"];
        vc.renter = self.renter;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 6){
        NSString *payBillEndTime = self.renter.payBillEndTime.stringValue;
        if (payBillEndTime.integerValue != 0) {
            RoomBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomBill"];
            vc.wayIn =@"hadPay";
            vc.renter = self.renter;
            vc.mainName = self.userNAME.text;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 7){
        OutInRecordController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"OutInRecord"];
        vc.renter = self.renter;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//删除一般租客
- (IBAction)deleteRenter:(id)sender {

    NSDictionary* dic = @{ @"houseID" : self.renter.houseID,
                               @"key" : [ModelTool find_UserData].key,
                           @"renterID": self.renter.renterID,
                            @"version": @"2.0"};
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n确定删除该租客吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
      [WebAPI deleteRenterInAcLog:dic callback:^(NSError *err, id response) {
          if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
              [Alert showFail:@"删除成功！" View:self.view andY:40 andTime:1.5 complete:^(BOOL isComplete) {
                    [self.navigationController popViewControllerAnimated:YES];
              }];

          }else{
              RequestBad
          }
      }];
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];

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

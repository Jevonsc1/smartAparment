//
//  SelectRentDateController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SelectRentDateController.h"
#import "HooDatePicker.h"
#import "SelectRentMonthController.h"
@interface SelectRentDateController ()<MyDelegate,HooDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rentStartTime;
@property (weak, nonatomic) IBOutlet UILabel *monthLength;
@property (weak, nonatomic) IBOutlet UILabel *rentEndTime;

@end

@implementation SelectRentDateController
{
    HooDatePicker *hooPicker;
    BOOL startTimeSelect;
    //开始时间的date
    NSDate *rentStartDate;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.rentTime isEqualToString:@"请选择"]||!self.rentTime||self.rentTime.length == 0) {
        
    }else{
        NSArray *strArr = [self.rentTime componentsSeparatedByString:@"至"];
        self.rentStartTime.text = strArr[0];
        self.rentEndTime.text = strArr[1];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
       
            startTimeSelect = true;
            hooPicker = [[HooDatePicker alloc] initWithSuperView:self.tableView andY:self.tableView.contentOffset.y-100];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:+5];
        NSDate *currentDate = [NSDate date];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        hooPicker.maximumDate = maxDate;
        hooPicker.delegate = self;
        [hooPicker show:self.tableView.contentOffset.y];
        
    }
    else if (indexPath.row == 2){
        
        startTimeSelect = false;
        hooPicker = [[HooDatePicker alloc] initWithSuperView:self.tableView andY:self.tableView.contentOffset.y];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setYear:+5];
        NSDate *currentDate = [NSDate date];
        NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        hooPicker.maximumDate = maxDate;
        hooPicker.delegate = self;
          [hooPicker show:self.tableView.contentOffset.y];
    }
    else{
        if ([self.rentStartTime.text isEqualToString:@"请选择"]) {
            [Alert showFail:@"请先选择合约起始时间！" View:self.navigationController.navigationBar andTime:3 complete:nil];
            
        }else{
        SelectRentMonthController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectRentMonth"];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(void)passValue:(NSString *)value{
    if (value.integerValue <=11) {
        self.monthLength.text = [NSString stringWithFormat:@"%@个月",value];
    }else{
        NSInteger yearNum = value.integerValue/12;
         self.monthLength.text = [NSString stringWithFormat:@"%ld年",(long)yearNum];
    }
    rentStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"rentStartDate"];
    NSLog(@"%@",[self dateStringAfterlocalDateForYear:0 Month:value.integerValue]);
    self.rentEndTime.text = [self dateStringAfterlocalDateForYear:0 Month:value.integerValue];
}
-(void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *timeStr = [format stringFromDate:date];
    if (startTimeSelect) {
        rentStartDate = date;
        [[NSUserDefaults standardUserDefaults] setObject:rentStartDate forKey:@"rentStartDate"];
        self.rentStartTime.text = timeStr;
    }else{
        NSLog(@"%@---%@",[NSString stringWithFormat:@"%@",rentStartDate],[NSString stringWithFormat:@"%@",date]);
        if ([self compareDate:[NSString stringWithFormat:@"%@",rentStartDate] withDate:[NSString stringWithFormat:@"%@",date]]>0) {
           self.rentEndTime.text = timeStr;
            self.monthLength.text = @"";
        }
        else{
            [Alert showFail:@"合约结束时间有误，请检查!" View:self.navigationController.navigationBar andTime:3 complete:nil];
        }
        
    }
}

- (NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month
{
    // 当前日期
    NSDate *localDate = rentStartDate; // 为伦敦时间
    // 在当前日期时间加上 时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponent = [[NSDateComponents alloc]init];
    
    [offsetComponent setYear:year ];  // 设置开始时间为当前时间的前x年
    [offsetComponent setMonth:month];
 
    // 当前时间后若干时间
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponent toDate:localDate options:0];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [format setDateFormat:@"yyyy-MM-dd"];

    NSString *dateString = [format stringFromDate:minDate];
    
    return dateString;
}
- (IBAction)clickToPop:(id)sender {
    if ([self.rentStartTime.text isEqualToString:@"请选择"]||[self.rentEndTime.text isEqualToString:@"请选择"]) {
        [Alert showFail:@"请完整选择合约时间！" View:self.navigationController.navigationBar andTime:3 complete:nil];
    }else{
        NSString *rentTime = [NSString stringWithFormat:@"%@至%@",self.rentStartTime.text,self.rentEndTime.text];
        [self.delegate passValue:rentTime];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (IBAction)clickToPopVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dt1 = [[NSDate alloc] init];
//    NSDate *dt2 = [[NSDate alloc] init];
//    dt1 = [df dateFromString:date01];
//    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [date01 compare:date02];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", date02, date01); break;
    }
    return ci;
}
@end

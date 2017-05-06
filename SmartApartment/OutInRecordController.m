    //
//  OutInRecordController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "OutInRecordController.h"
#import "RecordCell.h"
#import "OutInSelectTimeView.h"
#import "HooDatePicker.h"
#import "GBTagListView.h"
#import "MJRefresh.h"
@interface OutInRecordController ()<UITableViewDelegate,UITableViewDataSource,HooDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *timeSearchBtn;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation OutInRecordController
{
    NSArray *recordList;
    //筛选框中的选择时间view
    OutInSelectTimeView *timeView;
    //筛选框的黑色背景
    UIView *backgroundView;
    //单击手势
    UITapGestureRecognizer *hideRoomTap;
    //时间PickerView的背景
    UIView *pivkerBgView;
    //开始的时间戳
    NSString *startTimeTemp;
    //结束的时间戳
    NSString *endTimeTemp;
    //开门方式
    NSString *acCategory;
    //房间ID
    NSString *houseID;
    //页码
    NSString *pageNum;
    //条数
    NSString *pageSize;
    //租客ID
    NSString *renterID;
    //时间的tagView
    GBTagListView *dayTagView;
    //数据
    NSMutableArray *outinArr;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    endTimeTemp = @"0";
    startTimeTemp = @"0";
    houseID = self.renter.houseID.stringValue;
    renterID = self.renter.renterID.stringValue;
    acCategory = @"";
    pageSize  = @"20";
    pageNum = @"1";
    outinArr = [NSMutableArray arrayWithCapacity:0];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getRenterAcLogByRefresh)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshLog)];
    [self getRenterAcLogList];
    NSString * trueName = self.renter.renterTrueName;
    if (trueName.length == 0 || trueName == nil) {
         self.title = [NSString stringWithFormat:@"%@ 出入记录",self.renter.memberName];
    }else{
        self.title = [NSString stringWithFormat:@"%@ 出入记录",trueName];
    }
   
}

-(void)viewDidAppear:(BOOL)animated{
        [self initTimeView];
}

/**
 一开始获取数据
 */
-(void)getRenterAcLogList{
    pageNum =@"1";
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",endTimeTemp,@"endTime",houseID,@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"1",@"pageNum",@"10",@"pageSize",renterID,@"renterID",startTimeTemp,@"startTime",@"2.0",@"version", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getSomeRenterAcLogList:dic callback:^(NSError *err, id response) {
        if (!err &&[NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *arr = [[response objectForKey:@"data"] objectForKey:@"acLogList"];
            [outinArr removeAllObjects];
            if (arr.count > 0) {
              outinArr = [NSMutableArray arrayWithArray:arr];
            }
            [self.tableView reloadData];
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView: self.view animated:YES];
    }];
}

/**
 下拉刷新数据
 */
-(void)getRefreshLog{
    pageNum =@"1";
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",endTimeTemp,@"endTime",houseID,@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"1",@"pageNum",@"10",@"pageSize",renterID,@"renterID",startTimeTemp,@"startTime",@"2.0",@"version", nil];
    [WebAPI getSomeRenterAcLogList:dic callback:^(NSError *err, id response) {
        if (!err &&[NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *arr = [[response objectForKey:@"data"] objectForKey:@"acLogList"];
            [outinArr removeAllObjects];
            if (arr.count > 0) {
                
                [outinArr addObjectsFromArray:arr];
            }
            [self.tableView reloadData];
        }else{
            RequestBad
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

/**
 上拉加载数据
 */
-(void)getRenterAcLogByRefresh{
    pageNum = [NSString stringWithFormat:@"%ld",pageNum.integerValue +1];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",endTimeTemp,@"endTime",houseID,@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"1",@"pageNum",@"10",@"pageSize",renterID,@"renterID",startTimeTemp,@"startTime",@"2.0",@"version", nil];
    [WebAPI getSomeRenterAcLogList:dic callback:^(NSError *err, id response) {
        if (!err &&[NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *arr = [[response objectForKey:@"data"] objectForKey:@"acLogList"];
            [outinArr removeAllObjects];
            if (arr.count > 0) {
                [outinArr addObjectsFromArray:arr];
            }else{
                [Alert showFail:@"没有更多数据了!" View:self.navigationController.navigationBar andTime:1.5f complete:nil];
            }
            [self.tableView reloadData];
        }else{
            RequestBad
        }
        [self.tableView.mj_header endRefreshing];
    }];
}
/**
 初始化筛选按钮点击弹出的筛选框
 */
-(void)initTimeView{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.y+45, self.tableView.width, self.tableView.height)];
    [backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.view addSubview:backgroundView];
    hideRoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRoomEntryView)];
    [backgroundView addGestureRecognizer:hideRoomTap];
    backgroundView.hidden = YES;
    timeView = [[NSBundle mainBundle] loadNibNamed:@"AccessXib" owner:self options:nil][2];
    timeView.frame = CGRectMake(self.tableView.width, 0, 300 *ratio, self.tableView.height);
    [backgroundView addSubview:timeView];
    
    [timeView.startTimeBtn addTarget:self action:@selector(selectStartTime:) forControlEvents:UIControlEventTouchUpInside];
    [timeView.endTimeBtn addTarget:self action:@selector(selectEndTime) forControlEvents:UIControlEventTouchUpInside];
    [timeView.sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backgroundView];
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    dayTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 10, timeView.dayTagView.width-50, 0)];
    dayTagView.canTouch = YES;
    dayTagView.isSingleSelect = YES;
    dayTagView.signalTagColor = [UIColor whiteColor];
    [dayTagView setTagWithTagArray:dayArr];
    __block OutInRecordController *blockSelf = self;
    [dayTagView setDidselectItemBlock:^(NSArray *arr) {
        if (arr.count > 0) {
        NSString *dayType = arr[0];
        NSString *dayNumber;
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSString *timeDate = [[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:currentDate];
        [blockSelf->timeView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
        //结束时间的时间戳
        endTimeTemp = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
        if ([dayType isEqualToString:@"今天"]) {
            startTimeTemp = [blockSelf timeSwitchTimestamp:timeDate andFormatter:@"YYYY-MM-dd"];
            dayNumber = dateString;
            
        }
        else if ([dayType isEqualToString:@"最近三天"]){
            dayNumber =[blockSelf dateStringAfterlocalDateForYear:0 Month:0 Day:-3 Hour:0 Minute:0 Second:0 andDate:dateString];
        }else if ([dayType isEqualToString:@"最近一周"]){
            dayNumber =[blockSelf dateStringAfterlocalDateForYear:0 Month:0 Day:-7 Hour:0 Minute:0 Second:0 andDate:dateString];
            
        }
        else{
            dayNumber = [blockSelf dateStringAfterlocalDateForYear:0 Month:0 Day:-30 Hour:0 Minute:0 Second:0 andDate:dateString];
        }
        startTimeTemp = [blockSelf timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
        [blockSelf->timeView.startTimeBtn setTitle:dayNumber forState:UIControlStateNormal];
        }
    }];
    [timeView.dayTagView addSubview:dayTagView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 展示筛选框
 */
-(void)showEntrySelectView{
    backgroundView.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        timeView.x = self.tableView.width-timeView.width;
    }];
    
}

/**
 隐藏筛选框
 */
-(void)hideRoomEntryView{
      self.tableView.scrollEnabled = YES;
    self.timeSearchBtn.tag = 1;
    [UIView animateWithDuration:0.25f animations:^{
        timeView.x = self.tableView.width;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        backgroundView.hidden = YES;
    });
}
/**
 点击了选择开始时间按钮，弹出时间框
 
 @param sender 选择开始时间按钮
 */
-(void)selectStartTime:(UIButton *)sender{
    pivkerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:pivkerBgView];
    pivkerBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    HooDatePicker *startPicker = [[HooDatePicker alloc] initWithSuperView:pivkerBgView andY:pivkerBgView.height];
    startPicker.delegate = self;
    startPicker.tag = 1;
    [startPicker show];
}

/**
 点击了选择结束时间按钮
 */
-(void)selectEndTime{
    pivkerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:pivkerBgView];
    pivkerBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    HooDatePicker *startPicker = [[HooDatePicker alloc] initWithSuperView:pivkerBgView andY:pivkerBgView.height];
    startPicker.delegate = self;
    startPicker.tag = 2;
    [startPicker show];
}

/**
 显示筛选框
 */
- (IBAction)clickToShowSearch:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.tag = 2;
        [self showEntrySelectView];
    }else{
        sender.tag = 1;
        [self hideRoomEntryView];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
    NSDictionary *dic = outinArr[indexPath.row];
    cell.time.text = [TimeDate timeDetailWithTimeIntervalString:[dic objectForKey:@"unlockingTime"]];
    cell.way.text = [dic objectForKey:@"logCategoryName"];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return outinArr.count;
}
-(void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pivkerBgView removeFromSuperview];
    });
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (dataPicker.tag == 1) {
        startTimeTemp = [self timeSwitchTimestamp:dateString andFormatter:@"YYYY-MM-dd"];
        [timeView.startTimeBtn setTitle:dateString forState:UIControlStateNormal];
    }else{
        endTimeTemp = [self timeSwitchTimestamp:dateString andFormatter:@"YYYY-MM-dd"];
        [timeView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
    }
    
    
}

/**
 确定选择时间
 */
-(void)sureClick{
    [self hideRoomEntryView];
    [self getRenterAcLogList];
}
-(void)resetClick{
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    for (UIButton *btn in dayTagView.subviews) {
        [btn removeFromSuperview];
    }
    [dayTagView setTagWithTagArray:dayArr];
    [timeView.startTimeBtn setTitle:@"选择开始时间" forState:UIControlStateNormal];
    [timeView.endTimeBtn setTitle:@"选择结束时间" forState:UIControlStateNormal];
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

/**
 距离几天的时间

 @param year 年
 @param month 月
 @param day 日
 @param hour 时
 @param minute 分
 @param second 秒
 @param date 不需要传入
 @return 返回相应的时间
 */
- (NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second andDate:( NSString *)date
{
    // 当前日期
    NSDate *localDate =[NSDate date]; // 当前时间
    // 在当前日期时间加上 时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponent = [[NSDateComponents alloc]init];
    
    [offsetComponent setYear:year ];  // 设置开始时间为当前时间的前x年
    [offsetComponent setMonth:month];
    [offsetComponent setDay:day];
    [offsetComponent setHour:(hour+8)]; // 中国时区为正八区，未处理为本地，所以+8
    [offsetComponent setMinute:minute];
    [offsetComponent setSecond:second];
    
    // 当前时间后若干时间
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponent toDate:localDate options:0];
    
    NSString *dateString = [NSString stringWithFormat:@"%@",minDate];
    dateString = [dateString substringToIndex:10];
    
    return dateString;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)allWay:(id)sender {
    acCategory = @"";
    pageNum = @"1";
    [self getRenterAcLogList];
}
- (IBAction)phoneWay:(id)sender {
    acCategory = @"13";
    pageNum = @"1";
    [self getRenterAcLogList];
}
- (IBAction)ICCardWay:(id)sender {
    acCategory = @"1";
    pageNum = @"1";
    [self getRenterAcLogList];
}
- (IBAction)IDCardWay:(id)sender {
    acCategory = @"7";
    pageNum = @"1";
    [self getRenterAcLogList];
}
-(void)sureSelectTime{
    pageNum = @"1";
    [self getRenterAcLogList];
}
-(void)resetSelectTime{
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    for (UIButton *btn in dayTagView.subviews) {
        [btn removeFromSuperview];
    }
    [dayTagView setTagWithTagArray:dayArr];
    [timeView.startTimeBtn setTitle:@"选择开始时间" forState:UIControlStateNormal];
     [timeView.endTimeBtn setTitle:@"选择结束时间" forState:UIControlStateNormal];
    pageNum = @"1";
    startTimeTemp = @"";
    endTimeTemp = @"";
}

@end

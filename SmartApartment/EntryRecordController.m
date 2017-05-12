//
//  EntryRecordController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "EntryRecordController.h"
#import "EntryRecordCell.h"
#import "SelectXibView.h"
#import "EntrySelectView.h"
#import "EntrySelectRoomView.h"
#import "GBTagListView.h"
#import "HooDatePicker.h"
#import "EntrySearchViewController.h"
#import "RoomAndHighNumCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MyDelegateDic.h"
#define BlueText  [UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]
#define BlackText [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]
@interface EntryRecordController ()<UITableViewDelegate,UITableViewDataSource,HooDatePickerDelegate,MyDelegateDic>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchNavItem;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation EntryRecordController
{
    //无数据的背景图
    UIView *bgView;
    //时间选择框
    SelectXibView *selectView ;
    //出入时间选择框
    SelectXibView *selectViewTwo ;
    //开门方式选择框
    SelectXibView *selectViewThree ;
    //隐藏选择框的单击手势
    UITapGestureRecognizer *hideViewTap;
    UITapGestureRecognizer *hideViewTapTwo;
    UITapGestureRecognizer *hideViewTapThree;
    //筛选框
    EntrySelectView *entryView;
    //筛选框的选择房间的view
    EntrySelectRoomView *entryRoomView;
    //黑色背景
    UIView *backgroundView;
    //隐藏筛选框的单击手势
    UITapGestureRecognizer *hideRoomTap;
    //公寓列表
    NSArray *communityInfoList;
    //公寓标签的view
    GBTagListView *communityTagView;
    //筛选框中的开始以及结束时间戳
    NSString *startTimeTemp;
    NSString *endTimeTemp;
    //四个按钮的标签view
    GBTagListView *dayTagView;
    //时间pickerview的背景view
    UIView *pivkerBgView;
    //楼层以及房间的数据
    NSMutableDictionary *highNumDic;
    NSMutableArray *highNumArr;
    NSArray *houseFromHighArr;
    //全部房间
    NSArray *allHouseArr;
    //选中的房间数据
    NSDictionary *selectRoomDic;
    //选择的层
    NSDictionary *selectHighDic;
    //是否选择全部
    BOOL isAllRoom;
    //保存楼层的cell的indexpath
    NSInteger highIndex;
    
    
    
    //筛选条件的参数
    NSString *acCategory;//开门类型
    NSString *communityIDs;//公寓ID列表
    NSString *endTime;//结束时间
    NSString *forward;//倒序1 正序0
    NSString *houseIDs;//房间id列表
    NSString *pageNum;//分页页码
    NSString *searchContent;//搜索内容：名字，手机号，公寓名，房间号
    NSString *searchType;//搜索类型：租客，房间号
    NSString *sortType;//排序方式：0时间 1房号
    NSString *startTime;//查询开始时间
    //数据数组
    NSMutableArray *entryArray;
    //选择后的按钮保存颜色状态
    //综合排序
    NSString *selectButtonTitle;
    //出入时间
    NSString *selectButtonTitleTwo;
    //开门方式
    NSString *selectButtonTitleThree;
    //是否筛选了公寓---用于判断刷新
    BOOL isSelectCom;
    //是否进行了筛选
    BOOL isHadSelect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //初始化选择框
    [self initSelectRecordView];
    pageNum = @"0";
    forward = @"1";
    sortType = @"0";
    acCategory = @"";
    communityIDs=@"";
    endTime = @"";
    houseIDs = @"";
    searchContent = @"";
    searchType = @"";
    startTime = @"";
    isSelectCom = NO;
    isHadSelect = NO;
    //屋主的出入记录
    if ([self.userType isEqualToString:@"master"]) {
       
          [[self.navigationController.navigationBar.subviews objectAtIndex:self.navigationController.navigationBar.subviews.count-2] setHidden:NO];
    }
    else{
        
        [[self.navigationController.navigationBar.subviews objectAtIndex:self.navigationController.navigationBar.subviews.count-2] setHidden:YES];
        
    }
   
    selectButtonTitle = @"综合排序";
    selectButtonTitleTwo = @"全部";
    selectButtonTitleThree = @"全部";
    
    entryArray = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    entryRoomView.hightNumTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    entryRoomView.roomNumTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)viewDidAppear:(BOOL)animated{

    [self.view addSubview:selectView];
    [self.view addSubview:selectViewTwo];
    [self.view addSubview:selectViewThree];
    if (!backgroundView) {
         [self initEntrySelectView];
    }
    [self initDayButtonEvent];
    if (!entryRoomView) {
         [self initSelectRoomView];
    }
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getRenterAcLogByRefresh)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRefreshLog1)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 屋主获取数据
 */
-(void)getRefreshLog1{
    if (!isHadSelect) {
        //初始化所有参数
        pageNum = @"1";
        forward = @"1";
        sortType = @"0";
        acCategory = @"";
        endTime = @"";
        houseIDs = @"";
        searchContent = @"";
        searchType = @"";
        startTime = @"";
    }
    
    if (!isSelectCom) {
        communityIDs = @"";
        for (int i = 0; i <communityInfoList.count; i++) {
            NSDictionary *dic = communityInfoList[i];
            if (communityIDs.length == 0) {
                communityIDs = [NSString stringWithFormat:@"%@",[dic objectForKey:@"communityID"]];
            }else{
                communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"communityID"]]];
            }
        }
        communityIDs = [NSString stringWithFormat:@"[%@]",communityIDs];
    }
    [self getRenterAcLog];
}
-(void)getRenterAcLog{
    pageNum = @"1";
    
    NSDictionary *dic ;
    if ([self.userType isEqualToString:@"master"]) {
        NSLog(@"%@",communityIDs);
        dic= [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",communityIDs,@"communityIDs",endTime,@"endTime",forward,@"forward",houseIDs,@"houseIDs",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",pageNum,@"pageNum",@"20",@"pageSize",searchContent,@"searchContent",searchType,@"searchType",sortType,@"sortType",startTime,@"startTime",@"2.0",@"version", nil];
        [self getDataByDic:dic];
       
    }else{
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"2.0",@"version", nil];
        [WebAPI getRentRecordInfo:dic1 callback:^(NSError *err, id response) {
            NSString  *status =[response objectForKey:@"rcode"];
            if (!err && status.integerValue == 10000) {
                NSArray *dic2 = [response objectForKey:@"data"];
                if (dic2.count != 0){
                    NSDictionary *dataDic = dic2[0];
                    NSDictionary *houseInfo = [dataDic objectForKey:@"houseInfo"];
                    houseIDs = [NSString stringWithFormat:@"%@",[houseInfo objectForKey:@"houseID"]];
                    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",communityIDs,@"communityIDs",endTime,@"endTime",forward,@"forward",houseIDs,@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",pageNum,@"pageNum",@"20",@"pageSize",sortType,@"sortType",startTime,@"startTime",@"2.0",@"version", nil];
                    [self getDataByDic:dic];
                }
                else{
                   RequestBad
                }
                
            }
            else{
               RequestBad
            }
             [self.tableView.mj_header endRefreshing];
        }];

       
    }
   
}


-(void)getDataByDic:(NSDictionary *)dic{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getRenterAcLog:dic andType:self.userType callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *arr = [response objectForKey:@"data"];
            if (arr.count >0) {
                [entryArray removeAllObjects];
                [entryArray addObjectsFromArray:arr];
                [bgView removeFromSuperview];
            }
            else{
                [self initNodataView];
                [entryArray removeAllObjects];
            }
            [self.tableView reloadData];
        }else{
            if (!err) {
               [Alert showFail:[response objectForKey:@"rmsg"] View:self.navigationController.navigationBar andTime:1.5f complete:nil];
            }else{
               
                RequestBad
            }
        }
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 上拉加载数据
 */
-(void)getRenterAcLogByRefresh{
    pageNum = [NSString stringWithFormat:@"%d",pageNum.intValue+1];
    NSDictionary *dic ;
    if ([self.userType isEqualToString:@"master"]) {
        dic= [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",communityIDs,@"communityIDs",endTime,@"endTime",forward,@"forward",houseIDs,@"houseIDs",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",pageNum,@"pageNum",@"20",@"pageSize",searchContent,@"searchContent",searchType,@"searchType",sortType,@"sortType",startTime,@"startTime",@"2.0",@"version", nil];
    }else{
        dic = [[NSDictionary alloc] initWithObjectsAndKeys:acCategory,@"acCategory",communityIDs,@"communityIDs",endTime,@"endTime",forward,@"forward",houseIDs,@"houseID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",pageNum,@"pageNum",@"20",@"pageSize",sortType,@"sortType",startTime,@"startTime",@"2.0",@"version", nil];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getRenterAcLog:dic andType:self.userType callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *dataArr = [response objectForKey:@"data"];
            if (dataArr.count > 0) {
                [entryArray addObjectsFromArray:dataArr];
            }else{
                [Alert showFail:@"没有更多数据了！" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

/**
 初始化房间view
 */
-(void)initSelectRoomView{
    entryRoomView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][2];
    entryRoomView.frame = CGRectMake(backgroundView.width, 0, 300 *ratio, self.tableView.height);
    [backgroundView addSubview:entryRoomView];
    entryRoomView.hightNumTable.dataSource = self;
    entryRoomView.hightNumTable.delegate = self;
    entryRoomView.hightNumTable.tag = 1;
    entryRoomView.roomNumTable.dataSource = self;
    entryRoomView.roomNumTable.delegate = self;
    entryRoomView.roomNumTable.tag = 2;
    [entryRoomView.goBackBtn addTarget:self action:@selector(hideRoomViewByClick) forControlEvents:UIControlEventTouchUpInside];
    
}
/**
    初始化房间view的数据
 */
-(void)showSelectRoomView:(NSDictionary *)communityDic{
    entryRoomView.communityName.text = [communityDic objectForKey:@"communityName"];
    NSArray *houseArr = [communityDic objectForKey:@"houseInfoList"];
    houseFromHighArr = houseArr;
    allHouseArr = houseArr;
    highNumDic = [NSMutableDictionary dictionaryWithCapacity:0];
    highNumArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < houseArr.count; i++) {
        NSDictionary *houseDic = houseArr[i];
        NSString *highNum = [NSString stringWithFormat:@"%@",[houseDic objectForKey:@"houseHightNum"]];
        NSArray *highHouseArr = [highNumDic objectForKey:highNum];
        if (highHouseArr.count == 0) {
            NSArray *arr = [NSArray arrayWithObject:houseDic];
            [highNumDic setObject:arr forKey:highNum];
            [highNumArr addObject:highNum];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[highNumDic objectForKey:highNum]];
            [arr addObject:houseDic];
            [highNumDic setObject:arr forKey:highNum];
        }
    }
    
}

/**
    通过动画展示房间view
 */
-(void)showRoomViewByClick{
    [entryRoomView.hightNumTable reloadData];
    [entryRoomView.roomNumTable reloadData];
    [UIView animateWithDuration:0.25f animations:^{
        entryRoomView.x = self.view.width - 300 *ratio;
    }];
}

/**
    隐藏房间view
 */
-(void)hideRoomViewByClick{
    [UIView animateWithDuration:0.25f animations:^{
        entryRoomView.x = self.view.width;
    }];
}
/**
 初始化 四个时间按钮
 */
-(void)initDayButtonEvent{
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    dayTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 10, entryView.dayTagView.width-50, 0)];
    dayTagView.canTouch = YES;
    dayTagView.isSingleSelect = YES;
    dayTagView.signalTagColor = [UIColor whiteColor];
    [dayTagView setTagWithTagArray:dayArr];
    __block EntryRecordController *blockSelf = self;
    [dayTagView setDidselectItemBlock:^(NSArray *arr) {
        if (arr.count >0) {
            
            NSString *dayType = arr[0];
            NSString *dayNumber;
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSString *timeDate = [[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            [blockSelf->entryView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
            //结束时间的时间戳
            endTime = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
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
            startTime = [blockSelf timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
            [blockSelf->entryView.startTimeBtn setTitle:dayNumber forState:UIControlStateNormal];
        }
    }];
    [entryView.dayTagView addSubview:dayTagView];
    [entryView.dayTagViewAutoHeigh setConstant:dayTagView.height+10];
    [entryView.dayAllViewAutoHeight setConstant:208-98+dayTagView.height];
    
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

-(void)datePicker:(HooDatePicker *)dataPicker didSelectedDate:(NSDate *)date{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [pivkerBgView removeFromSuperview];
    });
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if (dataPicker.tag == 1) {
        startTimeTemp = [self timeSwitchTimestamp:dateString andFormatter:@"YYYY-MM-dd"];
        [entryView.startTimeBtn setTitle:dateString forState:UIControlStateNormal];
    }else{
          endTimeTemp = [self timeSwitchTimestamp:dateString andFormatter:@"YYYY-MM-dd"];
        [entryView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
    }
  
    
}


/**
 初始化选择框
 */
-(void)initSelectRecordView{
    selectView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][0];
    selectView.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    selectView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    selectView.labelOne.textColor = BlueText;
    selectView.hidden = YES;
    hideViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [selectView addGestureRecognizer:hideViewTap];
    
    selectViewTwo = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][0];
    selectViewTwo.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    selectViewTwo.labelOne.textColor = BlueText;
    selectViewTwo.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    selectViewTwo.hidden = YES;
    hideViewTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [selectViewTwo addGestureRecognizer:hideViewTapTwo];
    
    selectViewThree = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][0];
    selectViewThree.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    selectViewThree.labelOne.textColor = BlueText;
    selectViewThree.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    selectViewThree.hidden = YES;
    hideViewTapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [selectViewThree addGestureRecognizer:hideViewTapThree];
}
/**
 初始化筛选按钮点击弹出的筛选框
 */
-(void)initEntrySelectView{
    backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.tableView.width, self.tableView.height)];
    [backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.view addSubview:backgroundView];
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backgroundView.width - 300*ratio, backgroundView.height)];
    hideRoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRoomEntryView)];
    [tapView addGestureRecognizer:hideRoomTap];
    [tapView setBackgroundColor:[UIColor clearColor]];
    [backgroundView addSubview:tapView];
    backgroundView.hidden = YES;
    //加载view
    entryView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][1];
    entryView.frame = CGRectMake(self.tableView.width, 0, 300*ratio,self.view.height-45);
    [backgroundView addSubview:entryView];
    [entryView.startTimeBtn addTarget:self action:@selector(selectStartTime:) forControlEvents:UIControlEventTouchUpInside];
    [entryView.endTimeBtn addTarget:self action:@selector(selectEndTime) forControlEvents:UIControlEventTouchUpInside];
    //点击所有房间，展示数据
    [entryView.selectRoomBtn addTarget:self action:@selector(showRoomViewByClick) forControlEvents:UIControlEventTouchUpInside];
    [entryView.sureBtn addTarget:self action:@selector(searchBySome1) forControlEvents:UIControlEventTouchUpInside];
    //重置按钮的点击事件
    [entryView.resetBtn addTarget:self action:@selector(resetTag) forControlEvents:UIControlEventTouchUpInside];
    //网络请求获取公寓数据
    if ([self.userType isEqualToString:@"master"]) {
        [self MasterGetCommunity];
    }else{
        entryView.comLabel.hidden =YES;
        entryView.line.hidden = YES;
        entryView.selectRoomView.hidden = YES;
        entryView.tagView.hidden = YES;
        [self getRenterAcLog];
    }
  
}

/**
 屋主获取公寓id
 */
-(void)MasterGetCommunity{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults]objectForKey:@"userKey"],@"key",@"9999",@"pageSize", nil];
    communityTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, entryView.tagView.width-50, 300)];
    communityTagView.signalTagColor = [UIColor whiteColor];
    communityTagView.isSingleSelect = YES;
    communityTagView.canTouch = YES;
    entryView.selectRoomView.hidden = YES;
    __block EntryRecordController *blockSelf = self;
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue  == 10000) {
            communityInfoList = [response objectForKey:@"data"];
            if (communityInfoList.count != 0) {
                entryView.selectRoomView.hidden = NO;
            }
//TODO
//            [communityTagView setTagWithTagArray:communityInfoList];
//            for (int i = 0; i <communityInfoList.count; i++) {
//                NSDictionary *dic = communityInfoList[i];
//                if (communityIDs.length == 0) {
//                    communityIDs = [NSString stringWithFormat:@"%@",[dic objectForKey:@"communityID"]];
//                }else{
//                    communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"communityID"]]];
//                }
//            }
//            communityIDs = [NSString stringWithFormat:@"[%@]",communityIDs];
//            //获取所有公寓的出入记录
//            [self getRenterAcLog];
//            [communityTagView setDidselectItemBlock:^(NSArray *arr) {
//                if (arr.count > 0) {
//                    communityIDs = @"";
//                    NSDictionary *communityDic = arr[0];
//                    communityIDs = [NSString stringWithFormat:@"[%@]",[communityDic objectForKey:@"communityID"]];
//                    [blockSelf showSelectRoomView:communityDic];
//                    isSelectCom = YES;
//                }else{
//                    isSelectCom = NO;
//                }
//            }];
//            [entryView.tagViewAutoHeigh setConstant:communityTagView.height];
//            [entryView.scrollView setContentSize:CGSizeMake(0,272+40+communityTagView.height)];
//            
//            [entryView.tagView addSubview:communityTagView];
//            entryView.tagView.frame = communityTagView.frame;
//            
        }else{
            RequestBad
        }
}];
}

/**
 重置所有标签
 */
-(void)resetTag{
    for (UIButton *btn in communityTagView.subviews) {
        [btn removeFromSuperview];
    }
    
//TODO
//    [communityTagView setTagWithDictionary:communityInfoList andKey:@"communityName"];
    
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    for (UIButton *btn in dayTagView.subviews) {
        [btn removeFromSuperview];
    }
    [dayTagView setTagWithTagArray:dayArr];
    
    [entryView.startTimeBtn setTitle:@"选择开始时间" forState:UIControlStateNormal];
    [entryView.endTimeBtn setTitle:@"选择结束时间" forState:UIControlStateNormal];
    [entryView.roomLabel setText:@"所有房间"];
    //初始化所有参数
    pageNum = @"1";
    forward = @"0";
    sortType = @"0";
    acCategory = @"";
    endTime = @"";
    houseIDs = @"";
    searchContent = @"";
    searchType = @"";
    startTime = @"";
    communityIDs = @"";
    for (int i = 0; i <communityInfoList.count; i++) {
        NSDictionary *dic = communityInfoList[i];
        if (communityIDs.length == 0) {
            communityIDs = [NSString stringWithFormat:@"%@",[dic objectForKey:@"communityID"]];
        }else{
            communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"communityID"]]];
        }
    }
    communityIDs = [NSString stringWithFormat:@"[%@]",communityIDs];
}

/**
 展示筛选框
 */
-(void)showEntrySelectView{
    selectView.hidden = YES;
    selectViewTwo.hidden = YES;
    selectViewThree.hidden = YES;
    backgroundView.hidden = NO;
    NSLog(@"%f---%f",backgroundView.y,backgroundView.height);
    [UIView animateWithDuration:0.25f animations:^{
        entryView.x = self.tableView.width-entryView.width;
    }];
    
}

/**
 隐藏筛选框
 */
-(void)hideRoomEntryView{
    self.fourButton.tag = 1;
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.25f animations:^{
        entryView.x = self.tableView.width;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        backgroundView.hidden = YES;
    });
}
/**
 显示综合排序的选择View

 @param sender 综合排序按钮
 */
- (IBAction)showSelectOne:(UIButton *)sender {
   selectView.labelOne.text = @"综合排序";
//    selectView.labelOne.textColor = BlueText;
 
    selectView.labelTwo.text = @"时间由远到近";
    selectView.labelThree.text = @"房号由小到大";
    selectView.labelFour.text = @"房号由大到小";
    [self.oneLabel setTextColor:BlueText];
    [self.twoLabel setTextColor:BlackText];
    [self.threeLabel setTextColor:BlackText];
    [self.fourLabel setTextColor:BlackText];
    
    [selectView.buttonOne addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
     [selectView.buttonThree addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
     [selectView.buttonFour addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
     [selectView.buttonTwo addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
    //隐藏最后一行
    selectView.lastView.hidden = YES;
    if (sender.tag == 1) {
        selectView.hidden = NO;
        selectViewThree.hidden = YES;
        selectViewTwo.hidden = YES;
        self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.twoButton.tag = 1;
        self.threeButton.tag =1;
        self.fourButton.tag = 1;
        [self hideRoomEntryView];
    }else{
        selectView.hidden = YES;
        sender.tag = 1;
        self.tableView.scrollEnabled = YES;
        self.twoButton.tag = 1;
        self.threeButton.tag =1;
        self.fourButton.tag = 1;
    }
    [self setSelectButtonColor];
}

/**
 初始化所有按钮的颜色
 */
-(void)setSelectButtonColor{

    [selectView.labelOne setTextColor:BlackText];
    [selectView.labelTwo setTextColor:BlackText];
    [selectView.labelThree setTextColor:BlackText];
    [selectView.labelFour setTextColor:BlackText];
    [selectView.labelFive setTextColor:BlackText];
    
    [selectViewTwo.labelOne setTextColor:BlackText];
    [selectViewTwo.labelTwo setTextColor:BlackText];
    [selectViewTwo.labelThree setTextColor:BlackText];
    [selectViewTwo.labelFour setTextColor:BlackText];
    [selectViewTwo.labelFive setTextColor:BlackText];
    
    [selectViewThree.labelOne setTextColor:BlackText];
    [selectViewThree.labelTwo setTextColor:BlackText];
    [selectViewThree.labelThree setTextColor:BlackText];
    [selectViewThree.labelFour setTextColor:BlackText];
    [selectViewThree.labelFive setTextColor:BlackText];
    
    for (int i = 0; i <selectView.subviews.count; i++) {
        UIView *view = selectView.subviews[i];
        UILabel *label  = view.subviews.lastObject;
        if ([label.text isEqualToString:selectButtonTitle]) {
            label.textColor = BlueText;
        }else{
            label.textColor = BlackText;
        }
    }
    for (int i = 0; i <selectViewTwo.subviews.count; i++) {
        UIView *view = selectViewTwo.subviews[i];
        UILabel *label  = view.subviews.lastObject;
        if ([label.text isEqualToString:selectButtonTitleTwo]) {
            label.textColor = BlueText;
        }else{
            label.textColor = BlackText;
        }
    }
    for (int i = 0; i <selectViewThree.subviews.count; i++) {
        UIView *view = selectViewThree.subviews[i];
        UILabel *label  = view.subviews.lastObject;
        if ([label.text isEqualToString:selectButtonTitleThree]) {
            label.textColor = BlueText;
        }else{
            label.textColor = BlackText;
        }
    }
}

/**
 搜索时间和房号

 @param sender xib中的第1，2，3，4个按钮
 */
-(void)searchByTime:(UIButton *)sender{
  
    
    if (sender.tag == 1) {
        pageNum = @"0";
        forward = @"1";
        sortType = @"0";
        selectView.labelOne.textColor = BlueText;
        selectButtonTitle = selectView.labelOne.text;
    }else if (sender.tag == 2){
        pageNum = @"0";
        forward = @"0";
        sortType = @"0";
        selectView.labelTwo.textColor = BlueText;
        selectButtonTitle = selectView.labelTwo.text;
    }else if (sender.tag == 3){
        pageNum = @"0";
        forward = @"0";
        sortType = @"1";
        selectView.labelThree.textColor = BlueText;
        selectButtonTitle = selectView.labelThree.text;
    }else{
        pageNum = @"0";
        forward = @"1";
        sortType = @"1";
        selectView.labelFour.textColor = BlueText;
        selectButtonTitle = selectView.labelFour.text;
    }
    isHadSelect = YES;
    self.oneLabel.text = selectButtonTitle;
    self.oneLabel.textColor = BlueText;
    [self setSelectButtonColor];
    [self hideSelectView];
    [self getRenterAcLog];
}

/**
 显示出入时间的选择view

 @param sender 出入时间按钮
 */
- (IBAction)showSelectTwo:(UIButton *)sender {
    [self setSelectButtonColor];
    selectViewTwo.labelOne.text = @"全部";
//    selectViewTwo.labelOne.textColor = BlueText;
    selectViewTwo.labelTwo.text = @"今天";
    selectViewTwo.labelThree.text = @"最近三天";
    selectViewTwo.labelFour.text = @"最近一周";
    selectViewTwo.labelFive.text = @"一个月内";
    [self.twoLabel setTextColor:BlueText];
    [self.oneLabel setTextColor:BlackText];
    [self.threeLabel setTextColor:BlackText];
    [self.fourLabel setTextColor:BlackText];
 
    //添加监听
    [selectViewTwo.buttonOne addTarget:self action:@selector(selectByTime:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewTwo.buttonTwo addTarget:self action:@selector(selectByTime:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewTwo.buttonThree addTarget:self action:@selector(selectByTime:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewTwo.buttonFour addTarget:self action:@selector(selectByTime:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewTwo.buttonFive addTarget:self action:@selector(selectByTime:) forControlEvents:UIControlEventTouchUpInside];
    //显示最后一行
    selectViewTwo.lastView.hidden = NO;
    if (sender.tag == 1) {
        selectViewTwo.hidden = NO;
        selectViewThree.hidden = YES;
        selectView.hidden = YES;
        self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.oneButton.tag = 1;
        self.threeButton.tag = 1;
        self.fourButton.tag = 1;
        [self hideRoomEntryView];
    }else{
        selectViewTwo.hidden = YES;
        sender.tag = 1;
        self.tableView.scrollEnabled = YES;
        self.oneButton.tag = 1;
        self.threeButton.tag= 1;
        self.fourButton.tag = 1;
    }
    
}

/**
 根据选择框中的时间排序
 */
-(void)selectByTime:(UIButton *)sender{
 
    pageNum = @"0";
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSString *timeDate = [[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
    NSString *dayNumber;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //结束时间的时间戳
    endTime = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
    //今天
    if (sender.tag == 2) {
        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:0 Hour:0 Minute:0 Second:0 andDate:dateString];
        [selectViewTwo.labelTwo setTextColor:BlueText];
        selectButtonTitleTwo = selectViewTwo.labelTwo.text;
    }
    //最近三天
    else if (sender.tag ==3){
        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:-3 Hour:0 Minute:0 Second:0 andDate:dateString];
        [selectViewTwo.labelThree setTextColor:BlueText];
        selectButtonTitleTwo = selectViewTwo.labelThree.text;
    }
    //最近一周内
    else if (sender.tag == 4){
        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:-7 Hour:0 Minute:0 Second:0 andDate:dateString];
        [selectViewTwo.labelFour setTextColor:BlueText];
        selectButtonTitleTwo = selectViewTwo.labelFour.text;
    }
    //最近一个月内
    else if(sender.tag == 5){
        dayNumber = [self dateStringAfterlocalDateForYear:0 Month:0 Day:-30 Hour:0 Minute:0 Second:0 andDate:dateString];
        [selectViewTwo.labelFive setTextColor:BlueText];
        selectButtonTitle = selectViewTwo.labelFive.text;
    }else{
        startTime = @"";
        endTime = @"";
        [selectViewTwo.labelOne setTextColor:BlueText];
        selectButtonTitleTwo = selectViewTwo.labelOne.text;
    }
    [self setSelectButtonColor];
     [self hideSelectView];
    self.twoLabel.text= selectButtonTitleTwo;
    self.twoLabel.textColor = BlueText;
    startTime = [self timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
    [self getRenterAcLog];
    
}

/**
 显示开门方式的选择view

 @param sender 开门方式的按钮
 */
- (IBAction)showSelectThree:(UIButton *)sender {
    
    selectViewThree.labelOne.text = @"全部";
//    selectViewThree.labelOne.textColor = BlueText;
    selectViewThree.labelTwo.text = @"手机开门";
    selectViewThree.labelThree.text = @"IC卡开门";
    selectViewThree.labelFour.text = @"身份证开门";
    [self.threeLabel setTextColor:BlueText];
    [self.oneLabel setTextColor:BlackText];
    [self.twoLabel setTextColor:BlackText];
    [self.fourLabel setTextColor:BlackText];
    
    
    [selectViewThree.buttonOne addTarget:self action:@selector(selectByOpenDoor:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewThree.buttonTwo addTarget:self action:@selector(selectByOpenDoor:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewThree.buttonThree addTarget:self action:@selector(selectByOpenDoor:) forControlEvents:UIControlEventTouchUpInside];
    [selectViewThree.buttonFour addTarget:self action:@selector(selectByOpenDoor:) forControlEvents:UIControlEventTouchUpInside];
    
    //隐藏最后一行
    selectViewThree.lastView.hidden = YES;
    if (sender.tag == 1) {
        selectViewThree.hidden = NO;
        selectViewTwo.hidden = YES;
        selectView.hidden = YES;
         self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.oneButton.tag = 1;
        self.twoButton.tag = 1;
        self.fourButton.tag = 1;
        [self hideRoomEntryView];
    }else{
        selectViewThree.hidden = YES;
        self.tableView.scrollEnabled = YES;
        sender.tag = 1;
        self.oneButton.tag = 1;
        self.twoButton.tag= 1;
        self.fourButton.tag = 1;
    }
}
-(void)selectByOpenDoor:(UIButton *)sender{
    
    
    pageNum = @"0";
    if (sender.tag == 1) {
        acCategory = @"";
        selectButtonTitleThree = selectViewThree.labelOne.text;
        [selectViewThree.labelOne setTextColor:BlueText];
    }else if (sender.tag == 2){
        acCategory = @"13";//手机开门方式
        selectButtonTitleThree = selectViewThree.labelTwo.text;
        [selectViewThree.labelTwo setTextColor:BlueText];
    }else if (sender.tag == 3){
        acCategory = @"1";//IC卡开门
        selectButtonTitleThree = selectViewThree.labelThree.text;
        [selectViewThree.labelThree setTextColor:BlueText];
    }else{
        acCategory = @"7";
        selectButtonTitleThree = selectViewThree.labelFour.text;
        [selectViewThree.labelFour setTextColor:BlueText];
    }
    self.threeLabel.textColor = BlueText;
    self.threeLabel.text = selectButtonTitleThree;
    [self setSelectButtonColor];
     [self hideSelectView];
    [self getRenterAcLog];
}

/**
 显示筛选框

 @param sender 筛选按钮
 */
- (IBAction)showSelectFour:(UIButton *)sender {
    [self.fourLabel setTextColor:BlueText];
    [self.oneLabel setTextColor:BlackText];
    [self.twoLabel setTextColor:BlackText];
    [self.threeLabel setTextColor:BlackText];
   //展示房间筛选框
    if (sender.tag == 1) {
         [self showEntrySelectView];
         self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.oneButton.tag = 1;
        self.twoButton.tag = 1;
        self.threeButton.tag = 1;
    }else{
        [self hideRoomEntryView];
        self.tableView.scrollEnabled = YES;
        sender.tag = 1;
       
        
    }
}



/**
 加载3个tableview
    1.出入记录
    2.楼层
    3.房间

 @param tableView
 @param indexPath
 @return
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        RoomAndHighNumCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomAndHighNumCell"];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EntrySelectXib" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        if (indexPath.row == 0) {
            [cell.content setTitle:@"全部" forState:UIControlStateNormal];
        }else{
            if (highNumArr.count >=1) {
                  [cell.content setTitle:[NSString stringWithFormat:@"%@层",highNumArr[indexPath.row-1]] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else if (tableView.tag == 2){
        RoomAndHighNumCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomAndHighNumCell"];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"EntrySelectXib" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        if (indexPath.row == 0) {
            [cell.content setTitle:@"所有房间" forState:UIControlStateNormal];
        }else{
            if (houseFromHighArr.count >=1) {
                NSString *houseNum = [houseFromHighArr[indexPath.row-1] objectForKey:@"houseNum"];
                [cell.content setTitle:[NSString stringWithFormat:@"%@房",houseNum] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else{
        EntryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryRecordCell"];
        NSDictionary *dic = entryArray[indexPath.row];
        [cell.acLogMemberAvatar sd_setImageWithURL:[dic objectForKey:@"acLogMemberAvatar"] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
        
        cell.acLogMemberAvatar.layer.cornerRadius = cell.acLogMemberAvatar.width/2;
        cell.acLogMemberAvatar.layer.masksToBounds = YES;
        cell.acLogMemberName.text = [dic objectForKey:@"acLogMemberName"];
        cell.acLogTime.text = [TimeDate timeDetailWithTimeIntervalString:[dic objectForKey:@"acLogTime"]];
        cell.acLogHouseName.text = [dic objectForKey:@"acLogHouseName"];
        cell.acLogCategoryName.text = [dic objectForKey:@"acLogCategoryName"];
        if ([cell.acLogCategoryName.text isEqualToString:@"身份证开门"]) {
            [cell.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"bussiness-card"]];
        }else if ([cell.acLogCategoryName.text isEqualToString:@"IC卡开门"]){
            [cell.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"signboard"]];
        }else{
            [cell.acLogCategoryNameIcon setImage:[UIImage imageNamed:@"Mobile-phone"]];
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        if (indexPath.row != 0) {
            isAllRoom = NO;
            houseFromHighArr = [highNumDic objectForKey:highNumArr[indexPath.row-1]];
            highIndex = indexPath.row - 1;
        }else{
            isAllRoom = YES;
            houseFromHighArr = allHouseArr;
        }
        
         [entryRoomView.roomNumTable reloadData];
    }else if (tableView.tag == 2){
        if (indexPath.row == 0) {
          
            if (isAllRoom) {
                   entryView.roomLabel.text = [NSString stringWithFormat:@"%@ 所有房间",entryRoomView.communityName.text];
            }else{
                   entryView.roomLabel.text = [NSString stringWithFormat:@"%@ %@层",entryRoomView.communityName.text,highNumArr[highIndex]];
                NSArray *houseArr = [highNumDic objectForKey:[NSString stringWithFormat:@"%@",highNumArr[highIndex]]];
                
                for (int i = 0; i <houseArr.count; i++) {
                    NSDictionary *dic = houseArr[i];
                    if (i == 0) {
                        houseIDs = [NSString stringWithFormat:@"%@",[dic objectForKey:@"houseID"]];
                    }else{
                        houseIDs = [houseIDs stringByAppendingString:[NSString stringWithFormat:@",%@",[dic objectForKey:@"houseID"]]];
                    }
                }
                
                houseIDs = [NSString stringWithFormat:@"[%@]",houseIDs];
                NSLog(@"%@",houseIDs);
            }
        }else{
            selectRoomDic = houseFromHighArr[indexPath.row-1];
            
            entryView.roomLabel.text = [NSString stringWithFormat:@"%@ %@房",entryRoomView.communityName.text,[selectRoomDic objectForKey:@"houseNum"]];
            houseIDs = [NSString stringWithFormat:@"[%@]",[selectRoomDic objectForKey:@"houseNum"]];
        }
        [self hideRoomViewByClick];
        
    }
}


/**
 筛选框中的确定按钮
 */
-(void)searchBySome1{
    isHadSelect = YES;
    [self hideRoomEntryView];
    [self getRenterAcLog];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        return 44*ratio;
    }else if(tableView.tag == 2)
    {
        return 44*ratio;
    }else{
         return 60*ratio;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return highNumArr.count+1;
    }else if (tableView.tag == 2){
        return houseFromHighArr.count + 1;
    }else{
        
        return entryArray.count;
    }
}

/**
 隐藏选择框
 */
-(void)hideSelectView{
    self.oneButton.tag = 1;
    self.twoButton.tag = 1;
    self.threeButton.tag = 1;
    selectView.hidden = YES;
    selectViewThree.hidden =YES;
    selectViewTwo.hidden = YES;
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second andDate:( NSString *)date
{
    // 当前日期
    NSDate *localDate =[NSDate date]; // 为伦敦时间
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
- (IBAction)clickToSearch:(id)sender {
    [self hideSelectView];
    [self hideRoomEntryView];
    EntrySearchViewController *vc = [[UIStoryboard storyboardWithName:@"EntryRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"EntrySearch"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)passValue:(NSDictionary *)value{
    searchType = [value objectForKey:@"searchType"];
    searchContent = [value objectForKey:@"searchContent"];
    [self getRenterAcLog];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1||tableView.tag == 2) {
        return NO;
    }
    else{
        return YES;
    }
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *phoneCall = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拨打\n电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *dic = entryArray[indexPath.row];
        NSString *phone = [dic objectForKey:@"acLogMemberPhone"];
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    
    }];
    phoneCall.backgroundColor = [UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1];
    return @[phoneCall];
}

//没有账单的情况下，创建没有数据的界面
-(void)initNodataView{
    if (!bgView) {
        bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 150*ratio, 186*ratio)];
        iconView.centerX = bgView.centerX;
        [iconView setImage:[UIImage imageNamed:@"nodata"]];
        [bgView addSubview:iconView];
        [self.tableView addSubview:bgView];
    }
}
@end

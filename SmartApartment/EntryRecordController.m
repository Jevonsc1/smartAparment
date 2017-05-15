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

#import "MyDelegateDic.h"
#import "EntryRecord.h"
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

@property(nonatomic,strong)NSMutableArray<EntryRecord *>* entryRecordArray;
@property(nonatomic,strong)NSArray* selectCommuntyHouses;
@property(nonatomic,strong)Community* seletedCommunity;
@property(nonatomic,strong)UIView* fourSelectView;

@property(nonatomic,strong)EntrySelectView *entryView;

@property(nonatomic,strong)NSMutableDictionary* param;
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

    //筛选框的选择房间的view
    EntrySelectRoomView *entryRoomView;

    //四个按钮的标签view
    GBTagListView *dayTagView;
    //公寓标签的view
    GBTagListView *communityTagView;
    //筛选框中的开始以及结束时间戳
//    NSString *startTimeTemp;
//    NSString *endTimeTemp;
    
    //时间pickerview的背景view
    UIView *pivkerBgView;
    //楼层以及房间的数据
    NSMutableDictionary *highNumDic; //楼层与house数组的键值对
    NSMutableArray *highNumArr; //选中的公寓的楼层数据
    
    //选择的层
    NSDictionary *selectHighDic;
    //是否选择全部
    BOOL isAllRoom;
    //保存楼层的cell的indexpath
    NSInteger highIndex;

    //选择后的按钮保存颜色状态
    //综合排序
    NSString *selectButtonTitle;
    //出入时间
    NSString *selectButtonTitleTwo;
    //开门方式
    NSString *selectButtonTitleThree;


}

-(NSArray *)selectCommuntyHouses{
    if (!_selectCommuntyHouses) {
        _selectCommuntyHouses = [NSArray array];
    }
    return _selectCommuntyHouses;
}

-(NSMutableArray<EntryRecord *> *)entryRecordArray{
    if (!_entryRecordArray) {
        _entryRecordArray = [NSMutableArray array];
    }
    return _entryRecordArray;
}

-(NSMutableDictionary *)param{
    if (!_param) {
        _param = [NSMutableDictionary dictionary];
        
    }
    return _param;
}

-(void)resetParam{
    self.param[@"acCategory"] = @"";
    self.param[@"communityIDs"] = @"";
    self.param[@"endTime"] = @"";
    self.param[@"startTime"] = @"";
    self.param[@"forward"]= @"1";
    self.param[@"houseIDs"] = @"";
    self.param[@"key"] = [ModelTool find_UserData].key;
    self.param[@"pageNum"] = @"1";
    self.param[@"pageSize"] = @"20";
    self.param[@"searchContent"] = @"";
    self.param[@"searchType"] = @"";
    self.param[@"sortType"] = @"0";
    self.param[@"version"] = @"2.0";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetParam];
    [self initEntrySelectView];
    [self initSelectRecordView];
    [self initSelectRoomView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //屋主的出入记录
    if (![[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
   
    selectButtonTitle = @"综合排序";
    selectButtonTitleTwo = @"全部";
    selectButtonTitleThree = @"全部";
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    entryRoomView.hightNumTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    entryRoomView.roomNumTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getRenterAcLogByRefresh)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getRenterAcLog)];
}

-(void)initSelectRecordView{
    selectView = [self setupSelectXibView];
    selectViewTwo = [self setupSelectXibView];
    selectViewThree = [self setupSelectXibView];
}

-(SelectXibView*)setupSelectXibView{
    SelectXibView* selectxibView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][0];
    selectxibView.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    selectxibView.labelOne.textColor = BlueText;
    selectxibView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    selectxibView.hidden = YES;
    UITapGestureRecognizer* hideViewTapThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [selectxibView addGestureRecognizer:hideViewTapThree];
    [self.view addSubview:selectxibView];
    return selectxibView;
}

-(void)initEntrySelectView{
    self.fourSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
    [self.fourSelectView  setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.view addSubview:self.fourSelectView ];
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.fourSelectView .width - 300*ratio, self.fourSelectView .height)];
    UITapGestureRecognizer* hideRoomTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRoomEntryView)];
    [tapView addGestureRecognizer:hideRoomTap];
    [tapView setBackgroundColor:[UIColor clearColor]];
    [self.fourSelectView  addSubview:tapView];
    self.fourSelectView .hidden = YES;
    //加载view
    self.entryView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][1];
    self.entryView.frame = CGRectMake(self.tableView.width, 0, 300*ratio,self.view.height-45);
    [self.fourSelectView  addSubview:self.entryView];
    [self.entryView.startTimeBtn addTarget:self action:@selector(selectStartTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.entryView.endTimeBtn addTarget:self action:@selector(selectEndTime) forControlEvents:UIControlEventTouchUpInside];
    //点击所有房间，展示数据
    [self.entryView.selectRoomBtn addTarget:self action:@selector(showRoomViewByClick) forControlEvents:UIControlEventTouchUpInside];
    [self.entryView.sureBtn addTarget:self action:@selector(searchBySome1) forControlEvents:UIControlEventTouchUpInside];
    //重置按钮的点击事件
    [self.entryView.resetBtn addTarget:self action:@selector(resetTag) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupTimeTagView];
    
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        [self setupCommunityTagView];
    }else{
        self.entryView.comLabel.hidden =YES;
        self.entryView.line.hidden = YES;
        self.entryView.selectRoomView.hidden = YES;
        self.entryView.tagView.hidden = YES;
        [self getRenterAcLog];
    }
    
}


-(void)setupTimeTagView{
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    dayTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 10, self.entryView.dayTagView.width-50, 0)];
    dayTagView.canTouch = YES;
    dayTagView.isSingleSelect = YES;
    dayTagView.signalTagColor = [UIColor whiteColor];
    [dayTagView setTagWithTagArray:dayArr];
    __weak typeof(self) weakself = self;
    [dayTagView setDidselectItemBlock:^(NSArray *arr) {
        if (arr.count >0) {
            
            NSString *dayType = arr[0];
            NSString *dayNumber;
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            [weakself.entryView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
            //结束时间的时间戳
            weakself.param[@"endTime"] = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
            if ([dayType isEqualToString:@"今天"]) {
                //                startTimeTemp = [weakself timeSwitchTimestamp:timeDate andFormatter:@"YYYY-MM-dd"];
                dayNumber = dateString;
                
            }
            else if ([dayType isEqualToString:@"最近三天"]){
                dayNumber =[weakself dateStringAfterlocalDateForYear:0 Month:0 Day:-3 Hour:0 Minute:0 Second:0 andDate:dateString];
            }else if ([dayType isEqualToString:@"最近一周"]){
                dayNumber =[weakself dateStringAfterlocalDateForYear:0 Month:0 Day:-7 Hour:0 Minute:0 Second:0 andDate:dateString];
                
            }
            else{
                dayNumber = [weakself dateStringAfterlocalDateForYear:0 Month:0 Day:-30 Hour:0 Minute:0 Second:0 andDate:dateString];
            }
            weakself.param[@"startTime"] = [weakself timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
            [weakself.entryView.startTimeBtn setTitle:dayNumber forState:UIControlStateNormal];
        }
    }];
    [self.entryView.dayTagView addSubview:dayTagView];
    [self.entryView.dayTagViewAutoHeigh setConstant:dayTagView.height+10];
    [self.entryView.dayAllViewAutoHeight setConstant:208-98+dayTagView.height];
    
}

-(void)setupCommunityTagView{
    communityTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, self.entryView.tagView.width-50, 300)];
    communityTagView.signalTagColor = [UIColor whiteColor];
    communityTagView.isSingleSelect = YES;
    communityTagView.canTouch = YES;
    self.entryView.selectRoomView.hidden = YES;
    
    
    if (self.communityArray.count != 0) {
        self.entryView.selectRoomView.hidden = NO;
    }
    [communityTagView setTagWithCommunityArray:self.communityArray];
    NSString* communityIDs = self.param[@"communityIDs"];
    for (Community* community in self.communityArray) {
        if (communityIDs.length == 0) {
            communityIDs = community.communityID;
        }else{
            communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",community.communityID]];
        }
    }
    self.param[@"communityIDs"] = [NSString stringWithFormat:@"[%@]",communityIDs];
    __weak  typeof(self) weakself = self;
    
    [communityTagView setDidselectItemBlock:^(NSArray *arr) {
        if (arr.count > 0) {
            NSString* communityIDs = @"";
            Community* community = arr[0];
            communityIDs = [NSString stringWithFormat:@"[%@]",community.communityID];
            weakself.param[@"communityIDs"] = communityIDs;
            [weakself showSelectRoomView:community];
        }else{
        }
    }];
    
    //获取所有公寓的出入记录
    [self getRenterAcLog];
    
    [self.entryView.tagViewAutoHeigh setConstant:communityTagView.height];
    [self.entryView.scrollView setContentSize:CGSizeMake(0,272+40+communityTagView.height)];
    
    [self.entryView.tagView addSubview:communityTagView];
    self.entryView.tagView.frame = communityTagView.frame;
    
}

-(void)getRenterAcLog{
    NSString* communityIDs = self.param[@"communityIDs"];
    if (communityIDs.length == 0) {
        for (int i = 0; i <self.communityArray.count; i++) {
            Community *community = self.communityArray[i];
            if (communityIDs.length == 0) {
                communityIDs = community.communityID;
            }else{
                communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",community.communityID]];
            }
        }
        self.param[@"communityIDs"] = [NSString stringWithFormat:@"[%@]",communityIDs];
    }
    
    self.param[@"pageNum"] = @"1";
    
    if ([[ModelTool find_UserData].memberType isEqualToString:@"master"]) {
        [self getEntryRecordData];
       
    }else{
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",@"2.0",@"version", nil];
        [WebAPI getRentRecordInfo:dic1 callback:^(NSError *err, id response) {
            if (!err && [response intForKey:@"rcode"] == 10000) {
                NSLog(@"----%@",response);
                NSArray *dic2 = [response objectForKey:@"data"];
                if (dic2.count != 0){
                    NSDictionary *dataDic = dic2[0];
                    House *house = [House yy_modelWithDictionary:[dataDic objectForKey:@"houseInfo"]];
                    self.param[@"houseIDs"] = house.houseID.stringValue;
                    
                    [self getEntryRecordData];
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


-(void)getEntryRecordData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"--%@",self.param);
    [WebAPI getRenterAcLog:self.param andType:[ModelTool find_UserData].memberType callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            NSArray *arr = [response objectForKey:@"data"];
            if (arr.count >0) {
                [self.entryRecordArray removeAllObjects];
                for (NSDictionary* dic  in arr) {
                    EntryRecord* entryRecord = [EntryRecord yy_modelWithDictionary:dic];
                    [self.entryRecordArray addObject:entryRecord];
                }
                [bgView removeFromSuperview];
            }
            else{
                [self initNodataView];
                [self.entryRecordArray removeAllObjects];
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
    NSString* pagenum =  self.param[@"pageNum"];
    self.param[@"pageNum"] =[NSString stringWithFormat:@"%d",pagenum.intValue+1];
   
    [WebAPI getRenterAcLog:self.param andType:[ModelTool find_UserData].memberType callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            NSArray *dataArr = [response objectForKey:@"data"];
            if (dataArr.count > 0) {
                
                for (NSDictionary* dic  in dataArr) {
                    EntryRecord* entryRecord = [EntryRecord yy_modelWithDictionary:dic];
                    [self.entryRecordArray addObject:entryRecord];
                }
            
                [self.tableView reloadData];
            }else{
                [MBProgressHUD showMessage:@"没有更多数据了"];
            }
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            RequestBad
        }
    }];
}

/**
 初始化房间view
 */
-(void)initSelectRoomView{
    entryRoomView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][2];
    entryRoomView.frame = CGRectMake(self.fourSelectView.width, 0, 300 *ratio, SCREEN_HEIGHT-64-45);
    [self.fourSelectView  addSubview:entryRoomView];
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

-(void)showSelectRoomView:(Community *)community{
    self.seletedCommunity = community;
    entryRoomView.communityName.text = community.communityName;
    self.selectCommuntyHouses = community.houseInfoList;
    highNumDic = [NSMutableDictionary dictionary];
    highNumArr = [NSMutableArray array];
    for (int i = 0; i < self.selectCommuntyHouses.count; i++) {
        House *house = self.selectCommuntyHouses[i];
        NSString *highNum = house.houseHightNum.stringValue;
        NSArray *highHouseArr = [highNumDic objectForKey:highNum];
        if (highHouseArr.count == 0) {
            NSArray *arr = [NSArray arrayWithObject:house];
            [highNumDic setObject:arr forKey:highNum];
            [highNumArr addObject:highNum];
        }else{
            NSMutableArray *arr = [[highNumDic objectForKey:highNum] mutableCopy];
            [arr addObject:house ];
            [highNumDic setObject:arr forKey:highNum];
        }
    }
    
}

/**
    通过动画展示房间view
 */
-(void)showRoomViewByClick{
    if (self.seletedCommunity) {
        [entryRoomView.hightNumTable reloadData];
        [entryRoomView.roomNumTable reloadData];
        [UIView animateWithDuration:0.25f animations:^{
            entryRoomView.x = self.view.width - 300 *ratio;
        }];
    }
    
}

/**
    隐藏房间view
 */
-(void)hideRoomViewByClick{
    [UIView animateWithDuration:0.25f animations:^{
        entryRoomView.x = self.view.width;
    }];
}



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

        [self.entryView.startTimeBtn setTitle:dateString forState:UIControlStateNormal];
        self.param[@"startTime"] = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    }else{
        [self.entryView.endTimeBtn setTitle:dateString forState:UIControlStateNormal];
        self.param[@"endTime"] = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    }
  
    
}

-(void)searchBySome1{
    [self hideRoomEntryView];
    [self getRenterAcLog];
}

-(void)resetTag{
    [self resetParam];
    
    for (UIButton *btn in communityTagView.subviews) {
        [btn removeFromSuperview];
    }
    
    [communityTagView setTagWithCommunityArray:self.communityArray];
    
    NSArray *dayArr = @[@"今天",@"最近三天",@"最近一周",@"最近一个月"];
    for (UIButton *btn in dayTagView.subviews) {
        [btn removeFromSuperview];
    }
    [dayTagView setTagWithTagArray:dayArr];
    
    [self.entryView.startTimeBtn setTitle:@"选择开始时间" forState:UIControlStateNormal];
    [self.entryView.endTimeBtn setTitle:@"选择结束时间" forState:UIControlStateNormal];
    [self.entryView.roomLabel setText:@"所有房间"];

    NSString* communityIDs = self.param[@"communityIDs"];
    for (int i = 0; i <self.communityArray.count; i++) {
        Community *community = self.communityArray[i];
        if (communityIDs.length == 0) {
            communityIDs = community.communityID;
        }else{
            communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",community.communityID]];
        }
    }
    self.param[@"communityIDs"] = [NSString stringWithFormat:@"[%@]",communityIDs];
}

/**
 展示筛选框
 */
-(void)showEntrySelectView{
    selectView.hidden = YES;
    selectViewTwo.hidden = YES;
    selectViewThree.hidden = YES;
    self.fourSelectView .hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.entryView.x = self.tableView.width-self.entryView.width;
    }];
    
}

/**
 隐藏筛选框
 */
-(void)hideRoomEntryView{
    self.fourButton.tag = 1;
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.entryView.x = self.tableView.width;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fourSelectView .hidden = YES;
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

    [selectView setAllTextColor:BlackText];
    [selectViewTwo setAllTextColor:BlackText];
    [selectViewThree setAllTextColor:BlackText];

    [self setSelectView:selectView forText:selectButtonTitle];
    [self setSelectView:selectViewTwo forText:selectButtonTitleTwo];
    [self setSelectView:selectViewThree forText:selectButtonTitleThree];
}

-(void)setSelectView:(SelectXibView*)selectxibView forText:(NSString *)text{
    for (int i = 0; i < selectxibView.subviews.count; i++) {
        UIView *view = selectxibView.subviews[i];
        UILabel *label  = view.subviews.lastObject;
        if ([label.text isEqualToString:text]) {
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
        self.param[@"pageNum"] = @"0";
        self.param[@"forward"] = @"1";
        self.param[@"sortType"] = @"0";
        selectView.labelOne.textColor = BlueText;
        selectButtonTitle = selectView.labelOne.text;
    }else if (sender.tag == 2){
        self.param[@"pageNum"] = @"0";
        self.param[@"forward"] = @"0";
        self.param[@"sortType"] = @"0";
        selectView.labelTwo.textColor = BlueText;
        selectButtonTitle = selectView.labelTwo.text;
    }else if (sender.tag == 3){
        self.param[@"pageNum"] = @"0";
        self.param[@"forward"] = @"0";
        self.param[@"sortType"] = @"1";
        selectView.labelThree.textColor = BlueText;
        selectButtonTitle = selectView.labelThree.text;
    }else{
        self.param[@"pageNum"] = @"0";
        self.param[@"forward"] = @"1";
        self.param[@"sortType"] = @"1";
        selectView.labelFour.textColor = BlueText;
        selectButtonTitle = selectView.labelFour.text;
    }
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
 
    self.param[@"pageNum"] = @"0";
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSString *timeDate = [[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
    NSString *dayNumber;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //结束时间的时间戳
    self.param[@"endTime"] = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
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
        self.param[@"startTime"] = @"";
        self.param[@"endTime"] = @"";
        [selectViewTwo.labelOne setTextColor:BlueText];
        selectButtonTitleTwo = selectViewTwo.labelOne.text;
    }
    [self setSelectButtonColor];
     [self hideSelectView];
    self.twoLabel.text= selectButtonTitleTwo;
    self.twoLabel.textColor = BlueText;
    self.param[@"startTime"] = [self timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
    [self getRenterAcLog];
    
}

/**
 显示开门方式的选择view

 @param sender 开门方式的按钮
 */
- (IBAction)showSelectThree:(UIButton *)sender {
    
    selectViewThree.labelOne.text = @"全部";
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
    
    
    self.param[@"pageNum"] = @"0";
    if (sender.tag == 1) {
        self.param[@"acCategory"] = @"";
        selectButtonTitleThree = selectViewThree.labelOne.text;
        [selectViewThree.labelOne setTextColor:BlueText];
    }else if (sender.tag == 2){
        self.param[@"acCategory"] = @"13";//手机开门方式
        selectButtonTitleThree = selectViewThree.labelTwo.text;
        [selectViewThree.labelTwo setTextColor:BlueText];
    }else if (sender.tag == 3){
        self.param[@"acCategory"] = @"1";//IC卡开门
        selectButtonTitleThree = selectViewThree.labelThree.text;
        [selectViewThree.labelThree setTextColor:BlueText];
    }else{
        self.param[@"acCategory"] = @"7";
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
            if (self.selectCommuntyHouses.count >=1) {
                House* house = self.selectCommuntyHouses[indexPath.row-1];
                [cell.content setTitle:house.houseNum.stringValue forState:UIControlStateNormal];
            }
        }
        return cell;
    }else{
        EntryRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntryRecordCell"];
        cell.entryRecord = self.entryRecordArray[indexPath.row];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        if (indexPath.row != 0) {
            isAllRoom = NO;
            self.selectCommuntyHouses = [highNumDic objectForKey:highNumArr[indexPath.row-1]];
            highIndex = indexPath.row - 1;
        }else{
            isAllRoom = YES;
            self.selectCommuntyHouses = self.seletedCommunity.houseInfoList;
        }
        
         [entryRoomView.roomNumTable reloadData];
    }else if (tableView.tag == 2){
        if (indexPath.row == 0) {
          
            if (isAllRoom) {
                   self.entryView.roomLabel.text = [NSString stringWithFormat:@"%@ 所有房间",entryRoomView.communityName.text];
            }else{
                   self.entryView.roomLabel.text = [NSString stringWithFormat:@"%@ %@层",entryRoomView.communityName.text,highNumArr[highIndex]];
                NSArray *houseArr = [highNumDic objectForKey:[NSString stringWithFormat:@"%@",highNumArr[highIndex]]];
                NSString* houseIDs = self.param[@"houseIDs"];
                for (int i = 0; i <houseArr.count; i++) {
                    House *house = houseArr[i];
                    if (i == 0) {
                        houseIDs = house.houseID.stringValue;
                    }else{
                        houseIDs = [houseIDs stringByAppendingString:[NSString stringWithFormat:@",%@",house.houseID.stringValue]];
                    }
                }
                
                self.param[@"houseIDs"] = [NSString stringWithFormat:@"[%@]",houseIDs];
            }
        }else{
            House* house = self.selectCommuntyHouses[indexPath.row-1];
           
            self.entryView.roomLabel.text = [NSString stringWithFormat:@"%@ %@房",entryRoomView.communityName.text, house.houseNum];
            self.param[@"houseIDs"] = [NSString stringWithFormat:@"[%@]",house.houseNum];
        }
        [self hideRoomViewByClick];
        
    }
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
        return self.selectCommuntyHouses.count + 1;
    }else{
        
        return self.entryRecordArray.count;
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
    self.param[@"searchType"] = [value objectForKey:@"searchType"];
    self.param[@"searchContent"] = [value objectForKey:@"searchContent"];
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
        EntryRecord* entryRecord = self.entryRecordArray[indexPath.row];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",entryRecord.acLogMemberPhone]]];
    
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

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.entryView.contentHeight.constant = CGRectGetMaxY(self.entryView.bottomView.frame);
}
@end

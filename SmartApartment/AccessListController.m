//
//  AccessListController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccessListController.h"
#import "SelectXibView.h"
#import "GBTagListView.h"
#import "SearchAccessView.h"
#import "EntrySelectRoomView.h"
//#import "EntryRecordCell.h"
#import "RoomAndHighNumCell.h"

#import "AccessCell.h"
#import "MJRefresh.h"
#import "MyDelegateDic.h"
#import "UIImageView+WebCache.h"
//#import "EntrySearchViewController.h"
#import "RenterAccessMsgController.h"
#import "AccessManagerController.h"
#import "TipsCell.h"

#import "Renter.h"
#define BlueText  [UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]
#define BlackText [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1]
@interface AccessListController ()<UITableViewDelegate,UITableViewDataSource,MyDelegateDic>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (assign, nonatomic)NSInteger  pageNum;

@property (nonatomic,strong)NSMutableArray<Renter *> *accessArray;

@property(nonatomic,strong)SelectXibView *selectViewOne;
@property(nonatomic,strong)SelectXibView *selectViewTwo;

//筛选框的背景
@property(nonatomic,strong)UIView *fourBackgroundView;
//筛选框
@property(nonatomic,strong)SearchAccessView *searchAccessView;

@property(nonatomic,strong)NSArray* selectCommuntyHouses;
@property(nonatomic,strong)Community* seletedCommunity;
@end

@implementation AccessListController
{
    BOOL selectHeight;
    BOOL selectCom;
    //没有数据的背景图
    UIView *bgView;
   
    //筛选框的选择房间的view
    EntrySelectRoomView *entryRoomView;

    //楼层以及房间的数据
    NSMutableDictionary *highNumDic;
    NSMutableArray *highNumArr;

    //选中的房间数据
    NSDictionary *selectRoomDic;
    //选择的层
    NSDictionary *selectHighDic;
    //是否选择全部
    BOOL isAllRoom;
    //保存楼层的cell的indexpath
    NSInteger highIndex;
    //筛选框中的公寓标签view
    GBTagListView *communityTagView;
    //门禁状态的tagView
    GBTagListView *accessStatusTagView;
    //租客身份的tagView
    GBTagListView *renterTypeTagView;
    
    //选择后的按钮保存颜色状态
    NSString *oneButtonTitle;
    NSString *twoButtonTitle;

    //请求数据的参数
    NSString *accessStatusID;//门口机状态
    
    NSString *closedAC;//由我禁用的租客
    NSString *openICCard;//只开启ic卡的租客
    NSString *openIDCard;//只开启身份证的租客
    
    NSString *communityIDs;//公寓id
    NSString *noOpenACWeek;//超过一周没开过门  0:false 1 true
    NSString *openACThreeDay;//三天内开过门
    NSString *openACToday;//今天内开过门
    NSString *openACWeek;//一周内开过门

    NSString *renterRoleID;//租客的身份

    NSString *endTime;
    NSString *startTime;
    NSString *accessType;
    NSString *renterType;
    NSString *houseIDs;
    NSString *searchType;
    NSString *searchContent;
    //请求后得到的门禁数据
   
}

-(NSMutableArray *)accessArray{
    if (_accessArray == nil) {
        _accessArray = [NSMutableArray array];
    }
    return _accessArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //按钮开始默认选择
    oneButtonTitle = @"全部租客";
    twoButtonTitle = @"全部";
    
    accessStatusID = @"";
    
    closedAC = @"0";
    openIDCard = @"0";
    openICCard = @"0";
    
    noOpenACWeek = @"0";
    openACToday = @"0";
    openACThreeDay = @"0";
    openACWeek = @"0";
    
    renterRoleID = @"";
    communityIDs = @"";
    houseIDs = @"";
    
    searchType = @"";
    searchContent = @"";
    
    [self setupTableView];
    
    [self initSelectAllRecordView];
    
    [self initSelectInOutTimeRecordView];
    
     [self initEntrySelectView];
    
 
    [self initSelectRoomView];
    
}

-(void)setupTableView{
    self.pageNum = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
}

- (void)viewWillAppear:(BOOL)animated {
  
    [self getRenterAccessByRefresh];
    
    
    selectHeight = NO;
    selectCom = NO;
    
   
}

-(void)loadNew{
    self.pageNum = 1;
    [self getRenterAccessByRefresh];
}

-(void)loadMore{
    self.pageNum++;
    [self getRenterAccessByRefresh];
}

-(void)getRenterAccessByRefresh{
    
    NSDictionary* dic = @{@"accessStatusID":accessStatusID,
                           @"communityIDs":communityIDs,
                           @"key":[ModelTool find_UserData].key,
                           @"noOpenACWeek":noOpenACWeek,
                           @"openACThreeDay":openACThreeDay,
                           @"openACToday":openACToday,
                           @"openACWeek":openACWeek,
                           @"openICCard":openICCard,
                           @"openIDCard":openIDCard,
                          @"closedAC":closedAC,
                           @"pageNum":[NSNumber numberWithInteger:self.pageNum],
                           @"pageSize":@10,
                           @"renterRoleID":renterRoleID,
                           @"searchContent":searchContent,
                           @"version":@"2.0",
                           @"houseIDs":houseIDs
                          };
    
    [MBProgressHUD showProgress];
    [WebAPI getRenterAccess:dic  callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *dataArr = [response objectForKey:@"data"];
            if (self.pageNum == 1) {
                [self.accessArray removeAllObjects];
            }
            if (dataArr.count == 0) {
                [MBProgressHUD showMessage:@"没有更多数据了！"];
            }
            
            for (NSDictionary* dic in dataArr) {
                Renter* renter = [Renter yy_modelWithDictionary:dic];
                [self.accessArray addObject:renter];
            }
            
            [self.tableView reloadData];
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUD];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
/**
 显示综合排序的选择View
 
 @param sender 综合排序按钮
 */
- (IBAction)showSelectOne:(UIButton *)sender {
    self.selectViewOne.labelOne.text = @"全部租客";
    self.selectViewOne.labelOne.textColor = BlueText;
    
    self.selectViewOne.labelTwo.text = @"已开通身份证的租客";
    self.selectViewOne.labelThree.text = @"已开通IC卡的租客";
    self.selectViewOne.labelFour.text = @"我禁用的租客";
    [self.oneLabel setTextColor:BlueText];
    [self.twoLabel setTextColor:BlackText];
    [self.fourLabel setTextColor:BlackText];
    //添加按钮点击事件
    [self.selectViewOne.buttonOne addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewOne.buttonThree addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewOne.buttonFour addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewOne.buttonTwo addTarget:self action:@selector(searchByTime:) forControlEvents:UIControlEventTouchUpInside];
    //隐藏最后一行
    self.selectViewOne.lastView.hidden = YES;
    if (sender.tag == 1) {
        self.selectViewOne.hidden = NO;
        self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        [self hideRoomEntryView];
        self.selectViewTwo.hidden = YES;
    }else{
        self.selectViewOne.hidden = YES;
        sender.tag = 1;
        self.tableView.scrollEnabled = YES;
    }
    self.twoButton.tag = 1;
    self.fourButton.tag = 1;
    [self setOneSelectButtonColor:self.selectViewOne];
    
}
/**
 初始化筛选按钮点击弹出的筛选框
 */
-(void)initEntrySelectView{
    self.fourBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, self.tableView.width, self.tableView.height)];
    [self.fourBackgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.view addSubview:self.fourBackgroundView];
    UITapGestureRecognizer* hideSearchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRoomEntryView)];
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 300 *ratio, self.fourBackgroundView.height)];
    tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [self.fourBackgroundView addSubview:tapView];
    [tapView addGestureRecognizer:hideSearchTap];
    self.fourBackgroundView.hidden = YES;
    //加载view
    self.searchAccessView = [[NSBundle mainBundle] loadNibNamed:@"AccessXib" owner:nil options:nil][0];
    self.searchAccessView.frame = CGRectMake(self.tableView.width, 0, 300*ratio ,self.view.height-45);
    [self.fourBackgroundView addSubview:self.searchAccessView];
    accessStatusTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, 300*ratio-40, 0)];
    accessStatusTagView.x= 0;
    accessStatusTagView.y = 0;
    accessStatusTagView.signalTagColor = [UIColor whiteColor];
    accessStatusTagView.isSingleSelect = YES;
    accessStatusTagView.canTouch = YES;
    NSArray *accessArr = @[@"已全部禁用",@"已禁用手机",@"已禁用IC卡",@"已禁用身份证"];
    [accessStatusTagView setTagWithTagArray:accessArr];
    [accessStatusTagView setDidselectItemBlock:^(NSArray * arr) {
        if (arr.count >0) {
           NSString * accessType1 = arr[0];
            if ([accessType1 isEqualToString:@"已全部禁用"]) {
                accessStatusID =@"1";
            }else if ([accessType1 isEqualToString:@"已禁用手机"]){
                accessStatusID = @"2";
            }else if ([accessType1 isEqualToString:@"已禁用IC卡"]){
                accessStatusID = @"3";
            }else  if ([accessType1 isEqualToString:@"已禁用身份证"]) {
                accessStatusID = @"4";
            }
        }else{
            accessStatusID = @"";
        }
    }];
    [self.searchAccessView.accessStatusTagView addSubview:accessStatusTagView];
    renterTypeTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, 300*ratio-40, 0)];
    renterTypeTagView.x = 0;
    renterTypeTagView.y = 0;
    renterTypeTagView.signalTagColor = [UIColor whiteColor];
    renterTypeTagView.isSingleSelect = YES;
    renterTypeTagView.canTouch = YES;
    NSArray *renterArr = @[@"主租客",@"一般租客"];
    [renterTypeTagView setTagWithTagArray:renterArr];
    [renterTypeTagView setDidselectItemBlock:^(NSArray * arr) {
        if (arr.count >0) {
           NSString * renterType1 = arr[0];
            if ([renterType1 isEqualToString:@"主租客"]) {
                renterRoleID = @"1";
            }else{
                renterRoleID = @"2";
            }
        }else{
            renterRoleID = @"";
        }
    }];
    [self.searchAccessView.renterTypeTagView addSubview:renterTypeTagView];
    [self.searchAccessView.renterTypeTagView bringSubviewToFront:renterTypeTagView];

    //点击所有房间，展示数据
    [self.searchAccessView.selectRoomButton addTarget:self action:@selector(showRoomViewByClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.searchAccessView.sureBtn addTarget:self action:@selector(searchBySome) forControlEvents:UIControlEventTouchUpInside];
     [self.searchAccessView.resetBtn addTarget:self action:@selector(resetSearch) forControlEvents:UIControlEventTouchUpInside];
  
    communityTagView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, 300*ratio-40, 0)];
    communityTagView.signalTagColor = [UIColor whiteColor];
    communityTagView.isSingleSelect = YES;
    communityTagView.canTouch = YES;

    self.searchAccessView.selectRoomView.hidden = YES;
    
    
    
    [communityTagView setTagWithCommunityArray:self.communityArray];
    
    for (Community* community in self.communityArray) {
        if (communityIDs.length == 0) {
            communityIDs = community.communityID;
        }else{
            communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",community.communityID]];
        }
    }
    communityIDs = [NSString stringWithFormat:@"[%@]",communityIDs];
    
    if (self.communityArray.count != 0) {
        self.searchAccessView.selectRoomView.hidden = NO;
        entryRoomView.userInteractionEnabled = YES;
    }else{
        entryRoomView.userInteractionEnabled = NO;
    }
    __weak AccessListController *weakSelf = self;
    [communityTagView setDidselectItemBlock:^(NSArray *arr) {
        if (arr.count >0) {
            selectCom = YES;
            Community *comunity = arr[0];
            communityIDs = [NSString stringWithFormat:@"[%@]",comunity.communityID];
            [weakSelf showSelectRoomView:comunity];
        }
        else{
            selectCom = NO;
            communityIDs = @"";
        }
        
    }];
    [self.searchAccessView.communityAutoHeigh setConstant:communityTagView.height];
    self.searchAccessView.actayeAutoHeight.constant = accessStatusTagView.height;
    self.searchAccessView.renterAutoHeight.constant = renterTypeTagView.height;
    [self.searchAccessView.communityTagView addSubview:communityTagView];
    self.searchAccessView.communityTagView.frame = communityTagView.frame;


}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

    self.searchAccessView.contentHeight.constant = CGRectGetMaxY(self.searchAccessView.BtnView.frame)+45+30;
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    NSLog(@"11---%@",NSStringFromCGRect(self.searchAccessView.scrollView.frame));
    NSLog(@"-22--%@",NSStringFromCGRect(self.searchAccessView.BtnView.frame));
}

/**
 初始化房间view
 */
-(void)initSelectRoomView{
    entryRoomView = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][2];
    entryRoomView.frame = CGRectMake(self.fourBackgroundView.width, 0, 300 *ratio, self.tableView.height);
    [self.fourBackgroundView addSubview:entryRoomView];
    entryRoomView.hightNumTable.dataSource = self;
    entryRoomView.hightNumTable.delegate = self;
    entryRoomView.hightNumTable.tag = 1;
    entryRoomView.roomNumTable.dataSource = self;
    entryRoomView.roomNumTable.delegate = self;
    entryRoomView.roomNumTable.tag = 2;
    [entryRoomView.goBackBtn addTarget:self action:@selector(hideRoomViewByClick) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)searchBySome{
    [self hideRoomEntryView];
//    if (communityIDs.length==0) {
//        communityIDs = [NSString stringWithFormat:@"[%@]",tempCommnityIDs];
//    }
    [self loadNew];
}

/**
 重置筛选条件
 */
-(void)resetSearch{
    accessStatusID = @"";
    closedAC = @"0";
    communityIDs = @"";
    noOpenACWeek = @"0";
    openIDCard = @"0";
    openICCard = @"0";
    openACToday = @"0";
    openACThreeDay = @"0";
    openACWeek = @"0";
    renterRoleID = @"";
    self.pageNum = 1;
    searchType = @"";
    searchContent = @"";
    
    for (UIButton *btn in communityTagView.subviews) {
        [btn removeFromSuperview];
    }
    for (Community* community in self.communityArray) {
        if (communityIDs.length == 0) {
            communityIDs = [NSString stringWithFormat:@"%@",community.communityID];
        }else{
            communityIDs = [communityIDs stringByAppendingString:[NSString stringWithFormat:@",%@",community.communityID]];
        }
    }
//    tempCommnityIDs = communityIDs;
    communityIDs = [NSString stringWithFormat:@"[%@]",communityIDs];
    [communityTagView setTagWithCommunityArray:self.communityArray];
    for (UIButton *btn in accessStatusTagView.subviews) {
        [btn removeFromSuperview];
    }
    NSArray *accessArr = @[@"已全部禁用",@"已禁用手机",@"已禁用IC卡",@"已禁用身份证"];
    [accessStatusTagView setTagWithTagArray:accessArr];
    for (UIButton *btn in renterTypeTagView.subviews) {
        [btn removeFromSuperview];
    }
      self.searchAccessView.selectRoomLabel.text = @"所有房间";

    NSArray *renterArr = @[@"主租客",@"一般租客"];
    [renterTypeTagView setTagWithTagArray:renterArr];
    
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
/**
 显示出入时间的选择view
 
 @param sender 出入时间按钮
 */
- (IBAction)showSelectTwo:(UIButton *)sender {
    
    self.selectViewTwo.labelOne.text = @"全部";
    self.selectViewTwo.labelOne.textColor = BlueText;
    self.selectViewTwo.labelTwo.text = @"超过一周未开门";
    self.selectViewTwo.labelThree.text = @"一周内开过门";
    self.selectViewTwo.labelFour.text = @"三天内开过门";
    self.selectViewTwo.labelFive.text = @"今天开过门";
    [self.twoLabel setTextColor:BlueText];
    [self.oneLabel setTextColor:BlackText];
    [self.fourLabel setTextColor:BlackText];
    //移除监听
  
    //添加监听
    [self.selectViewTwo.buttonOne addTarget:self action:@selector(selectByTime1:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewTwo.buttonTwo addTarget:self action:@selector(selectByTime1:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewTwo.buttonThree addTarget:self action:@selector(selectByTime1:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewTwo.buttonFour addTarget:self action:@selector(selectByTime1:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectViewTwo.buttonFive addTarget:self action:@selector(selectByTime1:) forControlEvents:UIControlEventTouchUpInside];
    //显示最后一行
    self.selectViewTwo.lastView.hidden = NO;
    if (sender.tag == 1) {
        self.selectViewTwo.hidden = NO;
        self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.oneButton.tag = 1;
        self.fourButton.tag = 1;
        [self hideRoomEntryView];
        self.selectViewOne.hidden = YES;
    }else{
        self.selectViewTwo.hidden = YES;
        sender.tag = 1;
        self.tableView.scrollEnabled = YES;
        self.oneButton.tag = 1;
        self.fourButton.tag = 1;
    }
    [self setOneSelectButtonColor:self.selectViewTwo];
    
}

/**
 初始化综合排序所有按钮的颜色
 */
-(void)setOneSelectButtonColor:(SelectXibView *)selectView{
    
    [selectView.labelOne setTextColor:BlackText];
    [selectView.labelTwo setTextColor:BlackText];
    [selectView.labelThree setTextColor:BlackText];
    [selectView.labelFour setTextColor:BlackText];
    [selectView.labelFive setTextColor:BlackText];
    
    for (int i = 0; i <selectView.subviews.count; i++) {
        UIView *view = selectView.subviews[i];
        UILabel *label  = view.subviews.lastObject;
        if ([label.text isEqualToString:oneButtonTitle] ||[label.text isEqualToString:twoButtonTitle]) {
            label.textColor = BlueText;
        }else{
            label.textColor = BlackText;
        }
    }
    
}

/**
 搜索租客类型
 
 @param sender xib中的第1，2，3，4个按钮
 */
-(void)searchByTime:(UIButton *)sender{
    
    
    if (sender.tag == 1) {
       
        self.selectViewOne.labelOne.textColor = BlueText;
        oneButtonTitle = self.selectViewOne.labelOne.text;
        closedAC = @"0";
        openICCard = @"0";
        openIDCard = @"0";
    }else if (sender.tag == 2){
        openIDCard = @"1";
        openICCard = @"0";
        closedAC = @"0";
        self.selectViewOne.labelTwo.textColor = BlueText;
        oneButtonTitle = self.selectViewOne.labelTwo.text;
    }else if (sender.tag == 3){
        openICCard = @"1";
        openIDCard = @"0";
        closedAC = @"0";
        self.selectViewOne.labelThree.textColor = BlueText;
        oneButtonTitle = self.selectViewOne.labelThree.text;
    }else{
        openIDCard = @"0";
        openICCard = @"0";
        closedAC  = @"1";
        self.selectViewOne.labelFour.textColor = BlueText;
        oneButtonTitle = self.selectViewOne.labelFour.text;
    }
    
    [self hideSelectView];
    [self loadNew];
    [self.oneLabel setText:oneButtonTitle];
}

/**
 根据选择框中的时间排序
 */
-(void)selectByTime1:(UIButton *)sender{
    
    
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    //    NSString *timeDate = [[NSString stringWithFormat:@"%@",currentDate] substringToIndex:10];
    NSString *dayNumber;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    //结束时间的时间戳
    endTime = [NSString stringWithFormat:@"%ld",(long)[currentDate timeIntervalSince1970]];
    //超过一周
    if (sender.tag == 2) {
        
//        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:0 Hour:0 Minute:0 Second:0 andDate:dateString];
        [self.selectViewTwo.labelTwo setTextColor:BlueText];
        twoButtonTitle = self.selectViewTwo.labelTwo.text;
        openACWeek = @"0";
        openACThreeDay = @"0";
        openACToday = @"0";
        noOpenACWeek = @"1";
    }
    //一周内
    else if (sender.tag ==3){
//        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:-3 Hour:0 Minute:0 Second:0 andDate:dateString];
        [self.selectViewTwo.labelThree setTextColor:BlueText];
        twoButtonTitle = self.selectViewTwo.labelThree.text;
        openACWeek = @"1";
        openACThreeDay = @"0";
        openACToday = @"0";
        noOpenACWeek = @"0";
    }
    //三天内
    else if (sender.tag == 4){
//        dayNumber =[self dateStringAfterlocalDateForYear:0 Month:0 Day:-7 Hour:0 Minute:0 Second:0 andDate:dateString];
        [self.selectViewTwo.labelFour setTextColor:BlueText];
        twoButtonTitle = self.selectViewTwo.labelFour.text;
        openACWeek = @"0";
        openACThreeDay = @"1";
        openACToday = @"0";
        noOpenACWeek = @"0";
    }
    //今天开过门
    else if(sender.tag == 5){
//        dayNumber = [self dateStringAfterlocalDateForYear:0 Month:0 Day:-30 Hour:0 Minute:0 Second:0 andDate:dateString];
        [self.selectViewTwo.labelFive setTextColor:BlueText];
        twoButtonTitle = self.selectViewTwo.labelFive.text;
        openACWeek = @"0";
        openACThreeDay = @"0";
        openACToday = @"1";
        noOpenACWeek = @"0";
    }else{
        startTime = @"";
        endTime = @"";
        openACWeek = @"0";
        openACThreeDay = @"0";
        openACToday = @"0";
        noOpenACWeek = @"0";
        [self.selectViewTwo.labelOne setTextColor:BlueText];
        twoButtonTitle = self.selectViewTwo.labelOne.text;
    }
    [self setOneSelectButtonColor:self.selectViewTwo];
    [self hideSelectView];
    //计算筛选的开始时间
//    startTime = [self timeSwitchTimestamp:dayNumber andFormatter:@"YYYY-MM-dd"];
    [self.twoLabel setText:twoButtonTitle];
    [self loadNew];
    
    
}

/**
 综合排序的筛选View
 */
-(void)initSelectAllRecordView{
    self.selectViewOne = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:nil options:nil][0];
    self.selectViewOne.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    self.selectViewOne.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.selectViewOne.hidden = YES;
    UITapGestureRecognizer* hideViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [self.selectViewOne addGestureRecognizer:hideViewTap];
    [self.view addSubview:self.selectViewOne];
}

/**
 出入时间的筛选view
 */
-(void)initSelectInOutTimeRecordView{
    self.selectViewTwo = [[NSBundle mainBundle] loadNibNamed:@"EntrySelectXib" owner:self options:nil][0];
    self.selectViewTwo.frame = CGRectMake(0, 45, self.tableView.width,self.view.height-45);
    self.selectViewTwo.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.selectViewTwo.hidden = YES;
    UITapGestureRecognizer* hideViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSelectView)];
    [self.selectViewTwo addGestureRecognizer:hideViewTap];
    [self.view addSubview:self.selectViewTwo];
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
 显示筛选框
 
 @param sender 筛选按钮
 */
- (IBAction)showSelectFour:(UIButton *)sender {
    [self.fourLabel setTextColor:BlueText];
    [self.oneLabel setTextColor:BlackText];
    [self.twoLabel setTextColor:BlackText];
    
    //展示房间筛选框
    if (sender.tag == 1) {
        [self showEntrySelectView];
        self.tableView.scrollEnabled = NO;
        sender.tag = 2;
        self.oneButton.tag = 1;
        self.twoButton.tag = 1;
    }else{
        [self hideRoomEntryView];
        self.tableView.scrollEnabled = YES;
        sender.tag = 1;
        
        
    }
}

/**
 隐藏选择框
 */
-(void)hideSelectView{
    self.oneButton.tag = 1;
    self.twoButton.tag = 1;
    self.selectViewTwo.hidden = YES;
    self.selectViewOne.hidden = YES;
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
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 展示筛选框
 */
-(void)showEntrySelectView{
    self.selectViewTwo.hidden = YES;
    self.selectViewOne.hidden = YES;
    self.fourBackgroundView.hidden = NO;
    NSLog(@"%f---%f",self.fourBackgroundView.y,self.fourBackgroundView.height);
    [UIView animateWithDuration:0.25f animations:^{
        self.searchAccessView.x = self.tableView.width-self.searchAccessView.width;
    }];
    
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
//                NSString *houseNum = [self[indexPath.row-1] objectForKey:@"houseNum"];
                House* house = self.selectCommuntyHouses[indexPath.row-1];
                [cell.content setTitle:[NSString stringWithFormat:@"%@房",house.houseNum] forState:UIControlStateNormal];
            }
        }
        return cell;
    }else{
        if (indexPath.section != self.accessArray.count) {
            Renter *renter = self.accessArray[indexPath.section];
            
            AccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccessCell"];
            [cell.userAvater sd_setImageWithURL:[NSURL URLWithString:renter.renterMemberAvatar] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
            cell.userAvater.layer.cornerRadius = cell.userAvater.width/2;
            cell.userAvater.layer.masksToBounds = YES;
            NSString *trueName = renter.renterTrueName;
            if (trueName.length == 0 || trueName == nil) {
                cell.userName.text = renter.memberName;
            }else{
                cell.userName.text = trueName;
            }
            
            cell.roomName.text = renter.houseName;
            NSString *acLogDes = renter.acLogDes;
            
            cell.openStatus.text = acLogDes;
            
            NSString *renterType1 = renter.renterRoleID.stringValue;
            NSString *payBillStatus = renter.payBillComplete.stringValue;
            NSInteger compareDate = [self dateOut:renter.payBillEndTime.stringValue];
            NSString *payBillEndTime = renter.payBillEndTime.stringValue;
            if (renterType1.integerValue == 1) {
                cell.renterType.hidden = NO;
                if (payBillStatus.integerValue == 1) {
                    cell.billStatus.hidden = YES;
                }else{
                    if (compareDate>=0 ) {
                        cell.billStatus.hidden = YES;
                    }else{
                        if (payBillEndTime.integerValue == 0) {
                            cell.billStatus.hidden = YES;
                        }else{
                            cell.billStatus.hidden = NO;
                        }
                    }
                }
            }else{
                cell.renterType.hidden = YES;
                cell.billStatus.hidden = YES;
            }
            
            
            NSString *phoneOpen = renter.acMobileExist.stringValue;
            NSString *phoneStatus =renter.acMobileStatus.stringValue;
            NSString *ICcardOpen = renter.acICCardExist.stringValue;
            NSString *ICCardStatus = renter.acICCardStatus.stringValue;
            NSString *IDcardOpen = renter.acIDCardExist.stringValue;
            NSString *IDCardStatus =renter.acIDCardStatus.stringValue;
            if (phoneOpen.integerValue == 1) {
                if (phoneStatus.integerValue == 1) {
                    [cell.phoneIcon setImage:[UIImage imageNamed:@"Mobile-phone"]];
                }else{
                    [cell.phoneIcon setImage:[UIImage imageNamed:@"Mobile-phone_stop"]];
                }
            }else{
                [cell.phoneIcon setImage:[UIImage imageNamed:@"Mobile-phone_sel"]];
            }
            
            if (ICcardOpen.integerValue == 1) {
                if (ICCardStatus.integerValue == 1) {
                    [cell.ICCardIcon setImage:[UIImage imageNamed:@"signboard"]];
                }else{
                    [cell.ICCardIcon setImage:[UIImage imageNamed:@"signboard_stop"]];
                }
            }else{
                [cell.ICCardIcon setImage:[UIImage imageNamed:@"signboard_sel"]];
            }
            
            if (IDcardOpen.integerValue == 1) {
                if (IDCardStatus.integerValue == 1) {
                    [cell.IDCardIcon setImage:[UIImage imageNamed:@"bussiness-card"]];
                }else{
                    [cell.IDCardIcon setImage:[UIImage imageNamed:@"bussiness-card_stop"]];
                }
            }else{
                [cell.IDCardIcon setImage:[UIImage imageNamed:@"bussiness-card_sel"]];
            }
            return cell;
        }else{
            TipsCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"TipsCell"];
            return cell;
        }
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
        selectHeight = YES;
        [entryRoomView.roomNumTable reloadData];
    }else if (tableView.tag == 2){
        if (indexPath.row == 0) {
            
            if (isAllRoom) {
                self.searchAccessView.selectRoomLabel.text = [NSString stringWithFormat:@"%@ 所有房间",entryRoomView.communityName.text];
            }else{
                if (selectHeight) {
                    self.searchAccessView.selectRoomLabel.text = [NSString stringWithFormat:@"%@ %@层",entryRoomView.communityName.text,highNumArr[highIndex]];
                    NSArray *houseArr = [highNumDic objectForKey:[NSString stringWithFormat:@"%@",highNumArr[highIndex]]];
                    
                    for (int i = 0; i <houseArr.count; i++) {
                        House *house = houseArr[i];
                        if (i == 0) {
                            houseIDs = house.houseID.stringValue;
                        }else{
                            houseIDs = [houseIDs stringByAppendingString:[NSString stringWithFormat:@",%@",house.houseID]];
                        }
                    }

                }else{
                    self.searchAccessView.selectRoomLabel.text = [NSString stringWithFormat:@"%@ 所有房间",entryRoomView.communityName.text];
                }
                houseIDs = [NSString stringWithFormat:@"[%@]",houseIDs];
                NSLog(@"%@",houseIDs);
            }
        }else{
            House* house = self.selectCommuntyHouses[indexPath.row-1];
            
            self.searchAccessView.selectRoomLabel.text = [NSString stringWithFormat:@"%@ %@房",entryRoomView.communityName.text,house.houseNum];
            houseIDs = [NSString stringWithFormat:@"[%@]",house.houseNum];
        }
        [self hideRoomViewByClick];
        
    }else{
        if (indexPath.section != self.accessArray.count) {
            RenterAccessMsgController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterAccessMsg"];
            Renter *renter = self.accessArray[indexPath.section];
            vc.renter = renter;
            NSInteger compareDate = [self dateOut:renter.payBillEndTime.stringValue];
            vc.payDayNum = compareDate;
            
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        return 44*ratio;
    }else if(tableView.tag == 2)
    {
        return 44*ratio;
    }else{
        if (indexPath.section != self.accessArray.count) {
            return 100*ratio;
        }else{
            return cellHeight;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView.tag ==1 || tableView.tag == 2) {
        return 1;
    }else{
         return self.accessArray.count+1;
//        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag ==1 || tableView.tag == 2) {
        return 0.01;
    }else{
        return 10*ratio;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag==1 ||tableView.tag ==2) {
        return nil;
    }else{
        UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 1)];
        lineOne.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10*ratio)];
        sectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 10*ratio, self.tableView.width, 1)];
        lineTwo.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1];
        if (section != 0) {
            [sectionView addSubview:lineOne];
        }
        [sectionView addSubview:lineTwo];
        return sectionView;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return highNumArr.count+1;
    }else if (tableView.tag == 2){
        return self.selectCommuntyHouses.count + 1;
    }else{
        return 1;

    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    Renter *renter = self.accessArray[indexPath.section];
    UITableViewRowAction *callPhoneBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拨打\n电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",renter.renterPhone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];
    callPhoneBtn.backgroundColor = TDRGB(46, 126, 224);
    UITableViewRowAction *accessManager =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"管理\n门禁" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        AccessManagerController *vc = [[UIStoryboard storyboardWithName:@"AccessControl" bundle:nil] instantiateViewControllerWithIdentifier:@"AccessManager"];
        vc.renter = renter;
        [self.navigationController pushViewController:vc animated:YES];
       
    }];
    accessManager.backgroundColor = TDRGB(126, 195, 105);
    NSArray *arr = @[callPhoneBtn,accessManager];
    return arr;
}
- (IBAction)clickToSearch:(id)sender {
    [self hideSelectView];
    [self hideRoomEntryView];
    
//todo
//    EntrySearchViewController *vc = [[UIStoryboard storyboardWithName:@"EntryRecord" bundle:nil] instantiateViewControllerWithIdentifier:@"EntrySearch"];
//    vc.delegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)passValue:(NSDictionary *)value{
    searchType = [value objectForKey:@"searchType"];
    searchContent = [value objectForKey:@"searchContent"];
    [self loadNew];
}
/**
 隐藏筛选框
 */
-(void)hideRoomEntryView{
    self.fourButton.tag = 1;
    self.tableView.scrollEnabled = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.searchAccessView.x = self.tableView.width;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fourBackgroundView.hidden = YES;
    });
}


//计算时间间隔
- (NSInteger)dateOut:(NSString*)dueTimeString{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *startTime1 = [dateFormatter stringFromDate:[NSDate date]];
    //当前时间
    //NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate *bbEndDate = [NSDate dateWithTimeIntervalSince1970:[dueTimeString intValue]];
    NSString *endTime1 = [dateFormatter stringFromDate:bbEndDate];
    
    NSString *startTimeDate = [self timeSwitchTimestamp:startTime1 andFormatter:@"YYYYMMdd"];
    NSString *endTimeDate = [self timeSwitchTimestamp:endTime1 andFormatter:@"YYYYMMdd"];
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

//
//  NeedRentRoomController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/11.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "NeedRentRoomController.h"
#import "RentRoomCell.h"
#import "SearchView.h"
#import "GBTagListView.h"
#import "GBTagListView2.h"
//#import "UITableView+SDAutoTableViewCellHeight.h"
#import "RentRoomModel.h"
#import "MJRefresh.h"
#import "communityDetailController.h"

#import "TDString.h"
#import "RentRoom.h"
@interface NeedRentRoomController ()<UITableViewDelegate,UITableViewDataSource,TTRangeSliderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *onesj_icon;
@property (weak, nonatomic) IBOutlet UIImageView *twosj_icon;
@property (weak, nonatomic) IBOutlet UILabel *two_label;
@property (weak, nonatomic) IBOutlet UILabel *one_label;
@property (weak, nonatomic) IBOutlet UILabel *three_label;

@property(nonatomic,strong)RentRoom* rentRoom;
@property(nonatomic,strong)NSMutableArray* communityArray;

//参数部分
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,copy)NSString* tagString;
@property(nonatomic,copy)NSString* cityNodeString;
@property(nonatomic,assign)BOOL forward;
@end

@implementation NeedRentRoomController
{
    SearchView *searchView;
    UIView *bgView;
    GBTagListView *tagListArea;
    GBTagListView *tagListTag;
    CGFloat tagAreaY;
    CGFloat tagTagY;
    UIButton *resetBtn;
    UIButton *sureBtn;
    TTRangeSlider* rangSlider;
    
    //最大租金
    NSString *maxRent;
    //最小租金
    NSString *minRent;
    //距离
    NSString *rentRange;
    //标签
    NSString *tagsArr;

    //搜索类型
    int sortType;
    //节点字符串
    NSString *areaNodeIDs;
    
    //是否在筛选
    BOOL isSelect;
    UIScrollView *scrollView;
    
}

-(NSMutableArray *)communityArray{
    if (!_communityArray) {
        _communityArray = [NSMutableArray array];
    }
    return _communityArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.forward = true;
    sortType = 0;
    areaNodeIDs = @"";
    rentRange = @"[0,1000000]";
    tagsArr = @"";
    isSelect = false;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
     self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    [self loadNew];
}
-(void)loadNew{
    self.pageNum = 1;
    [self getCommunityRentInfoList];
}
-(void)loadMore{
    self.pageNum++;
    [self getCommunityRentInfoList];
}
-(void)getCommunityRentInfoList{
    NSString* page = [NSString stringWithFormat:@"%ld",(long)self.pageNum];
    NSDictionary *dic =[[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",page,@"pageNum",@"10",@"pageSize",rentRange,@"rentRange",self.cityNodeString?self.cityNodeString:@"",@"areaNodeIDs",self.tagString?self.tagString:@"",@"tags", @"中山市",@"cityName",self.forward?@"true":@"",@"forward",[NSString stringWithFormat:@"%d",sortType],@"sortType",nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [WebAPI getCommunityRentInfoList:dic callback:^(NSError *err, id response) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!err && [response intForKey:@"rcode"] == 10000 ) {
            RentRoom *rentRoom = [RentRoom yy_modelWithDictionary:[response objectForKey:@"data"]] ;
            self.rentRoom = rentRoom;
            if (!bgView) {
                [self initSelectView];
            }
            
            if (self.pageNum == 1) {
                [self.communityArray removeAllObjects];
            }
            [self.communityArray addObjectsFromArray:rentRoom.communityInfoList];
                
            [self.tableView reloadData];
        }else{
                RequestBad
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)clickToPop:(id)sender {
    if (isSelect) {
        [self backForSelect];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    RentRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RentRoomCell"];
        cell.modelData = self.communityArray[indexPath.section];
   
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Community *model = self.communityArray[indexPath.section];
    communityDetailController *comDetailVC = [[UIStoryboard storyboardWithName:@"SearchRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"communityDetail"];
    comDetailVC.model = model;
    
    RentRoomCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    comDetailVC.tagHeight = cell.roomcellHeight ;

    [self.navigationController pushViewController:comDetailVC animated:YES];
}

//获取空房数列表
- (IBAction)getEmptyRoom:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.tag = 2;
        self.forward = false;
         [self.onesj_icon setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
    
    }else{
        sender.tag = 1;
        self.forward = true;
         [self.onesj_icon setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
        
    }
    self.one_label.textColor = MainRed;
    self.two_label.textColor = TDRGB(102, 102, 102);
    self.three_label.textColor = TDRGB(102, 102, 102);
    sortType = 0;
    [self loadNew];
}

//获取租金排序的列表
- (IBAction)getRentMoney:(UIButton *)sender {
    if (sender.tag == 1) {
        sender.tag = 2;
        self.forward = false;
        [self.twosj_icon setImage:[UIImage imageNamed:@"bill_upsj_icon"]];
   
    }else{
        sender.tag = 1;
        self.forward = true;
        [self.twosj_icon setImage:[UIImage imageNamed:@"bill_downsj_icon"]];
    }
    self.two_label.textColor = MainRed;
    self.one_label.textColor = TDRGB(102, 102, 102);
    self.three_label.textColor = TDRGB(102, 102, 102);
    sortType = 1;
    [self loadNew];
}











/**
 展示筛选内容的view

 */
- (IBAction)showTagListView:(id)sender {
    self.tableView.scrollEnabled = NO;
      bgView.hidden = NO;
    isSelect = true;
    bgView.alpha = 1;
    
    [self.view addSubview:bgView];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        searchView.x = self.view.width - 300 *ratio;
    }];
    
}


/**
 创建一个半透明的黑色蒙层
 创建整个筛选窗口

 */
-(void)initSelectView {
    if (bgView) {
        [bgView removeFromSuperview];
        bgView = nil;
    }
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.width, self.view.height - 60 )];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    searchView = [[SearchView alloc]init];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.frame = CGRectMake(bgView.width - 300*ratio, 0, 300*ratio, bgView.height);
    
    UILabel *labelOne = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 42, 21)];
    labelOne.text = @"区域";
    labelOne.font = [UIFont systemFontOfSize:16 *ratio];
    labelOne.textColor = TDRGB(136, 136, 136);
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 300 *ratio, 1)];
    lineOne.backgroundColor = TDRGB(223, 223, 223);
    
    tagListArea=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 50, searchView.width-30,0)];
    tagAreaY = 45;
    /**允许点击 */
    tagListArea.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagListArea.canTouchNum=999;
    /**控制是否是单选模式 */
    tagListArea.isSingleSelect=NO;
    tagListArea.signalTagColor=[UIColor whiteColor];
    [tagListArea setTagWithCityArray:self.rentRoom.cityNodeInfoList];
    __weak typeof(self) weakself = self;
    [tagListArea setDidselectItemBlock:^(NSArray * arr) {
        NSMutableArray* array = [NSMutableArray array];
        for (CityNode* node in arr) {
            [array addObject:node.nodeID];
        }
        weakself.cityNodeString = [array yy_modelToJSONString];
    }];
    
    UILabel *labelTwo = [[UILabel alloc] initWithFrame:CGRectMake(12, tagListArea.y+tagListArea.height+12, 42, 21)];
    labelTwo.text = @"租金";
    labelTwo.font = [UIFont systemFontOfSize:16 *ratio];
    labelTwo.textColor = TDRGB(136, 136, 136);
    UILabel *labelThree = [[UILabel alloc] initWithFrame:CGRectMake(300*ratio - 12 - 57, tagListArea.y+tagListArea.height+12, 57, 21)];

    UIView *lineTwo = [[UIView alloc] initWithFrame:CGRectMake(0, labelTwo.y+labelTwo.height + 11, 300 *ratio, 1)];
    lineTwo.backgroundColor = TDRGB(223, 223, 223);
    rangSlider =[[NSBundle mainBundle] loadNibNamed:@"CellXib" owner:self options:nil][1];
    rangSlider.frame = CGRectMake(8, lineTwo.y + 10, 300*ratio - 20, 54);

    rangSlider.delegate = self;
    rangSlider.minValue = 0;
    rangSlider.maxValue = 1000;
    rangSlider.selectedMinimum = 0;
    rangSlider.selectedMaximum = 1000;
    rangSlider.enableStep = YES;
    rangSlider.step = 50;
    rangSlider.handleColor =TDRGB(229,89,89);
    rangSlider.handleDiameter = 20;
    rangSlider.selectedHandleDiameterMultiplier = 1.1;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.positiveFormat = @"¥0";
    rangSlider.numberFormatterOverride = formatter;
    
    UIView* clickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 300*ratio, bgView.height)];
    clickView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [bgView addSubview:clickView];
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    [clickView addGestureRecognizer:tapG];
    UISwipeGestureRecognizer *swipG = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backForSelect)];
    swipG.direction = UISwipeGestureRecognizerDirectionRight;
    [clickView addGestureRecognizer:swipG];
    
    
    UILabel *labelFour = [[UILabel alloc] initWithFrame:CGRectMake(12, rangSlider.y+12+54, 42, 21)];
    labelFour.text = @"标签";
    labelFour.font = [UIFont systemFontOfSize:16 *ratio];
    labelFour.textColor = TDRGB(136, 136, 136);
    UIView *lineThree= [[UIView alloc] initWithFrame:CGRectMake(0, labelFour.y + 12 +21, 300 *ratio, 1)];
    lineThree.backgroundColor = TDRGB(223, 223, 223);
    
    tagListTag=[[GBTagListView alloc]initWithFrame:CGRectMake(0, lineThree.y + 5, searchView.width-30,0)];
    tagTagY = lineThree.y + 5;
    /**允许点击 */
    tagListTag.canTouch=YES;
    /**可以控制允许点击的标签数 */
    tagListTag.canTouchNum=999;
    /**控制是否是单选模式 */
    tagListTag.isSingleSelect=NO;
    tagListTag.signalTagColor=[UIColor whiteColor];
    [tagListTag setTagWithCommunityTagArray:self.rentRoom.communityTagsList];
    [tagListTag setDidselectItemBlock:^(NSArray * arr) {
        NSMutableArray* array = [NSMutableArray array];
        for (CommunityTag* tag in arr) {
            [array addObject:tag.communityTagsID];
        }
        weakself.tagString = [array yy_modelToJSONString];
    }];
    
    resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, tagListTag.height+tagListTag.y + 10, 125*ratio, 45*ratio)];
    [resetBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_reset"] forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetSelect) forControlEvents:UIControlEventTouchUpInside];
    
    sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(resetBtn.x + 125 *ratio + 10, tagListTag.height + tagListTag.y + 10, 125 *ratio, 45*ratio)];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_sure"] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureSelect) forControlEvents:UIControlEventTouchUpInside];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 300*ratio, self.view.height)];
    scrollView.contentSize = CGSizeMake(0, sureBtn.y + 45 *ratio + 80);
    [searchView addSubview:scrollView];
    
    //添加控件
    [scrollView addSubview:labelOne];
    [scrollView addSubview:lineOne];
    [scrollView addSubview:tagListArea];
    [scrollView addSubview:labelTwo];
    [scrollView addSubview:labelThree];
    [scrollView addSubview:lineTwo];
    [scrollView addSubview:rangSlider];
    [scrollView addSubview:labelFour];
    [scrollView addSubview:lineThree];
    [scrollView addSubview:tagListTag];
    [scrollView addSubview:resetBtn];
    [scrollView addSubview:sureBtn];
    [bgView addSubview:searchView];
    
}


/**
 筛选框的确定按钮
 */
-(void)sureSelect{
    [self backForSelect];
    [self loadNew];
}

/**
 重置按钮的点击事件
 */
-(void)resetSelect{
    
    
    NSArray *btnArr = tagListArea.subviews;
    
    for (int i = 0; i <btnArr.count; i++) {
        UIButton *tempBtn = btnArr[i];
        tempBtn.selected = NO;
        tempBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        NSArray *subviews = tempBtn.subviews;
        UIImageView *rightIcon = subviews[2];
        rightIcon.hidden = YES;
        tempBtn.layer.borderWidth = 0;
        tempBtn.layer.cornerRadius = 0;
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    areaNodeIDs =@"";
//    [tagListArea removeFromSuperview];
//    tagListArea=[[GBTagListView alloc]initWithFrame:CGRectMake(0, 45, searchView.width-30,searchView.height)];
//    
//    /**允许点击 */
//    tagListArea.canTouch=YES;
//    /**可以控制允许点击的标签数 */
//    tagListArea.canTouchNum=999;
//    
//    /**控制是否是单选模式 */
//    tagListArea.isSingleSelect=NO;
//    tagListArea.signalTagColor=[UIColor whiteColor];
//    [tagListArea setTagWithDictionary:cityNodeInfoList andKey:@"nodeName"];
//    [scrollView addSubview:tagListArea];
    
    
    NSArray *btnArr1 = tagListTag.subviews;
    
    for (int i = 0; i <btnArr1.count; i++) {
        UIButton *tempBtn = btnArr1[i];
        tempBtn.selected = NO;
        tempBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        NSArray *subviews = tempBtn.subviews;
        UIImageView *rightIcon = subviews[2];
        rightIcon.hidden = YES;
        tempBtn.layer.borderWidth = 0;
        tempBtn.layer.cornerRadius = 0;
        [tempBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    tagsArr =@"";
   
    rentRange = @"[0,1000000]";
    rangSlider.selectedMinimum = 0;
    rangSlider.selectedMaximum = 1000;
}
/**
 滑动条

 @param sender 控件
 @param selectedMinimum 最小值
 @param selectedMaximum 最大值
 */
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    maxRent = [NSString stringWithFormat:@"%.0f",selectedMaximum];
    minRent = [NSString stringWithFormat:@"%.0f",selectedMinimum];
    rentRange = [NSString stringWithFormat:@"[%@,%@]",minRent,maxRent];
}

//点击黑色蒙层收起选择窗口
-(void)backForSelect{
    self.tableView.scrollEnabled = YES;
    isSelect = false;
    [UIView animateWithDuration:0.25 animations:^{
        
        searchView.x = self.view.width ;
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [bgView removeFromSuperview];
        bgView.hidden = YES;
    });
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10*ratio)];
    view.backgroundColor = TDRGB(245.0, 245.0, 245.0);
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    topLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    bottomLine.backgroundColor = TDRGB(223.0, 223.0, 223.0);
    [view addSubview: topLine];
    [view addSubview:bottomLine];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  self.communityArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Community* community  = self.communityArray[indexPath.row];
    GBTagListView2 *view = [[GBTagListView2 alloc]initWithFrame:CGRectMake(0, 0, 128, 0)];
    [view setTagWithCommunityTagArray:community.tagInfoList andType:@"cell"];
    return  view.height + 64;
}

@end

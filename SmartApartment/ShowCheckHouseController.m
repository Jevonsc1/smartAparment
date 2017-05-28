//
//  ShowCheckHouseController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ShowCheckHouseController.h"
#import "CheckHouseCell.h"
#import "HouseHistoryController.h"
#import "searchBarView.h"
#import "SearchBillController.h"
@interface ShowCheckHouseController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;
@property (weak, nonatomic) IBOutlet UIButton *roomBtn;
@property (weak, nonatomic) IBOutlet UIButton *roomDate;
@property (weak, nonatomic) IBOutlet UIView *blueLine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ShowCheckHouseController
{
    NSMutableArray *roomArr;
    //房间楼层字典---key:楼层，value:房间数组信息
    NSMutableDictionary *roomHighDic;
    NSMutableArray *tempRoomArr;
    
    //公寓房间
    NSArray *allRoomArr;
    
    BOOL byName;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSearchBar:) name:@"SearchRoom" object:nil];
    roomArr = [NSMutableArray arrayWithCapacity:0];
    roomHighDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.title = self.community.communityName;
    //获取公寓下的房间
    NSArray *arr = self.community.houseInfoList;
    allRoomArr = arr;
    for (int i = 0; i < arr.count ; i ++) {
        House* house = arr[i];
        NSArray *roomHigh = [roomHighDic objectForKey:house.houseHightNum];
        if (roomHigh.count <=0) {
            NSArray *arr = [NSArray arrayWithObject:house];
            [roomHighDic setObject:arr forKey:house.houseHightNum];
            [roomArr addObject:house.houseHightNum];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *oldRoomArr =  [roomHighDic objectForKey:house.houseHightNum];
            [arr addObject:house];
            for (int i = 0; i < oldRoomArr.count; i++) {
                [arr addObject:oldRoomArr[i]];
            }
            [roomHighDic setObject:arr forKey:house.houseHightNum];
        }
        
    }
    tempRoomArr = [NSMutableArray arrayWithArray:allRoomArr];
    self.apartmentName.text = self.community.communityName;
    [self roomDicByHighNum];
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    //蓝色线条一开始修改位置
    self.blueLine.centerX = self.roomBtn.centerX;
    self.blueLine.width = 150*ratio;
}

//根据层排序
-(void)roomDicByHighNum{
    
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id string1,id string2){
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    NSArray *resultArray = [roomArr sortedArrayUsingComparator:finderSort];
    
    roomArr = [NSMutableArray arrayWithArray:resultArray];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithCapacity:0];
   
    for (int i = 0; i <roomArr.count; i++) {
        
        NSArray *newArr =  [[[roomHighDic objectForKey:roomArr[i]] reverseObjectEnumerator] allObjects];
          [newDic setObject:newArr forKey:roomArr[i]];

    }
//
    roomHighDic = newDic;
}
//点击了按房间名称排序
- (IBAction)clickByRoomName:(id)sender {
    //动画方式移动
    [self.roomDate setTitleColor:TDRGB(153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [self.roomBtn setTitleColor:MainBlue forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.blueLine.centerX = self.roomBtn.centerX;
    }];
    byName = YES;
    [self.tableView reloadData];
}
//点击了按账单名称排序
- (IBAction)clickByDate:(id)sender {
    [self.roomBtn setTitleColor:TDRGB(153.0, 153.0, 153.0) forState:UIControlStateNormal];
    [self.roomDate setTitleColor:MainBlue forState:UIControlStateNormal];
    [UIView animateWithDuration:0.2 animations:^{
        self.blueLine.centerX = self.roomDate.centerX;
    }];
    byName = false;
    [self.tableView reloadData];
}
- (IBAction)clickToPop:(id)sender {
    [PopHome popToController:@"CheckHomeController" andVC:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)clickToSearchBaar:(id)sender {
    SearchBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBill"];
    vc.wayIn =2;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
      return roomHighDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [roomHighDic objectForKey:roomArr[section]];
    return arr.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HouseHistoryController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"HouseHistory"];
    vc.house = [roomHighDic objectForKey:roomArr[indexPath.section]][indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckHouseCell" forIndexPath:indexPath];
    House *house  = [roomHighDic objectForKey:roomArr[indexPath.section]][indexPath.row];
    cell.roomName.text = house.houseNum.stringValue;
    
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    NSString *highStr = [NSString stringWithFormat:@"%@",roomArr[section]];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *highNum = [formatter stringFromNumber:[NSNumber numberWithInteger:highStr.integerValue]];

    label.text = [NSString stringWithFormat:@"%@层",highNum];
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
#pragma mark -m 点击叉，恢复原始
-(void)resetNavigationItem{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 33)];
    label.text =  self.community.communityName;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18*ratio];
    label.centerX = self.view.centerX;
    label.centerY = self.navigationItem.titleView.centerY;
    self.navigationItem.titleView = label;
    NSArray *arr = self.community.houseInfoList;
    allRoomArr = arr;
    [roomHighDic removeAllObjects];
    [roomArr removeAllObjects];
    for (int i = 0; i < arr.count ; i ++) {
        House *house = arr[i];
        NSArray *roomHigh = [roomHighDic objectForKey:house.houseHightNum];
        if (roomHigh.count <=0) {
            NSArray *arr = [NSArray arrayWithObject:house];
            [roomHighDic setObject:arr forKey:house.houseHightNum];
            [roomArr addObject:house.houseHightNum];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *oldRoomArr =  [roomHighDic objectForKey:house.houseHightNum];
            [arr addObject:house];
            for (int i = 0; i < oldRoomArr.count; i++) {
                [arr addObject:oldRoomArr[i]];
            }
            [roomHighDic setObject:arr forKey:house.houseHightNum];
        }
        
    }
     [self roomDicByHighNum];
    [self.tableView reloadData];
}
#pragma mark -m 跳转到SearchBillController
-(void)clickToSearch{
    SearchBillController *vc = [[UIStoryboard storyboardWithName:@"ApartmentBill" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchBill"];
    vc.wayIn = 2;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -m 点击了搜索，添加搜索bar到navigation中
-(void)addSearchBar:(NSNotification *)info{
    
    searchBarView *searchView = [[NSBundle mainBundle] loadNibNamed:@"BillSelectView" owner:self options:nil][1];
    [searchView.endSearch addTarget:self action:@selector(resetNavigationItem) forControlEvents:UIControlEventTouchUpInside];
    searchView.searchContent.text = info.object;
    searchView.searchContent.font = [UIFont systemFontOfSize:14*ratio];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToSearch)];
    [searchView.searchContent addGestureRecognizer:tap];
    searchView.layer.cornerRadius = 10;
    self.navigationItem.titleView = searchView;
    //对数据进行筛选
    NSMutableArray *selectArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i<allRoomArr.count; i++) {
        House *house = allRoomArr[i];
        NSString *houseNum = [NSString stringWithFormat:@"%@",house.houseNum];
        NSString *mainRenter;
        NSString *mainRenterPhone;
        NSArray *renterInfo = house.rentInfo;
        if (renterInfo.count > 0) {
            Rent *rent = renterInfo[0];
            NSArray *renterArr = rent.renterInfo;
            if (renterArr.count > 0) {
                for (int j = 0 ; j<renterArr.count; j++) {
                    Renter *renter = renterArr[j];
                    if ([renter.renterRoleID isEqual:@1]) {
                        mainRenter =renter.renterTrueName;
                        mainRenter = renter.renterPhone.stringValue;
                        break;
                    }
                    
                }
            }
            if ([houseNum rangeOfString:info.object].location != NSNotFound) {
                [selectArr addObject:house];
            }else{
                if ([mainRenter rangeOfString:info.object].location != NSNotFound &&mainRenter != nil) {
                    [selectArr addObject:house];
                }else{
                    if ([mainRenterPhone rangeOfString:info.object].location != NSNotFound && mainRenterPhone !=nil) {
                        [selectArr addObject:house];
                    }
                }
            }
            
        }
    }
    allRoomArr = selectArr;
    [roomArr removeAllObjects];
    [roomHighDic removeAllObjects];
    for (int i = 0; i < allRoomArr.count ; i ++) {
        House *house = allRoomArr[i];
        NSArray *roomHigh = [roomHighDic objectForKey:house.houseHightNum];
        if (roomHigh.count <=0) {
            NSArray *arr = [NSArray arrayWithObject:house];
            [roomHighDic setObject:arr forKey:house.houseHightNum];
            [roomArr addObject:house.houseHightNum];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *oldRoomArr =  [roomHighDic objectForKey:house.houseHightNum];
            [arr addObject:house];
            for (int i = 0; i < oldRoomArr.count; i++) {
                [arr addObject:oldRoomArr[i]];
            }
            [roomHighDic setObject:arr forKey:house.houseHightNum];
        }
        
    }
     [self roomDicByHighNum];
    
    [self.tableView reloadData];
    
}
@end

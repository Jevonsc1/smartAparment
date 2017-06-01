//
//  GetRoomListController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#import "MyDelegate.h"
#import "GetRoomListController.h"
#import "ShowCommunityController.h"
#import "AccountRoomController.h"
#import "RoomStatusCell.h"
#import "NewSignRoomController.h"
#import "CheckSignRoomController.h"

#import "Community.h"
@interface GetRoomListController ()<MyDelegate>
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;
@property (weak, nonatomic) IBOutlet UILabel *changLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comTitleAutoWidth;//现在没有用到
@property (weak, nonatomic) IBOutlet UIView *comTitleView;


@property(nonatomic,strong)Community *currentAparment;

//由于houseinfo结构的问题，house的一个字段houseHightNum存放房间所在楼层的，所以需要新开两个变量来辅助建表
@property(strong,nonatomic)NSMutableArray<NSNumber *> *roomArr;
//层数字典--key是层数，value是房间
@property(strong,nonatomic)NSMutableDictionary *roomHighDic;
@end

@implementation GetRoomListController
-(NSMutableArray *)roomArr{
    if (_roomArr == nil) {
        _roomArr = [NSMutableArray array];
    }
    return _roomArr;
}

-(NSMutableDictionary *)roomHighDic{
    if (_roomHighDic == nil) {
        _roomHighDic = [NSMutableDictionary dictionary];
    }
    return _roomHighDic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getaparmentList:) name:@"getApartmentList" object:nil];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    [self addTapForView];
}

-(void)setApartmentArr:(NSArray<Community *> *)apartmentArr{
    _apartmentArr = apartmentArr;
    self.currentAparment = apartmentArr[0];
    [self getRoomList];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.roomArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray* array  = [self.roomHighDic objectForKey:self.roomArr[section]];
    return array.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    House* house  = [self.roomHighDic objectForKey:self.roomArr[indexPath.section]][indexPath.row];
    if ([self.wayIn isEqualToString:@"Account"]) {
        AccountRoomController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountRoom"];
        vc.house = house;

        [self.navigationController pushViewController:vc animated:YES];
    }else{
       
        if ([cell.roomStatus.text isEqualToString:@"空置"]) {
            NewSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"NewSignRoom"];
            vc.house =house;
            vc.communityName = self.apartmentName.text;
            [self.navigationController pushViewController: vc animated:YES];
        }else{
            CheckSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckSignRoom"];
            vc.houseID = house.houseID.stringValue;
            vc.delegate = self;
            vc.communityName = self.apartmentName.text;
            CommunityRelation* communityRelation = house.communityRelationInfo[0];
            vc.apartmentID = communityRelation.houseCommunityID.stringValue;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomStatusCell"];
    House *house  = [self.roomHighDic objectForKey:self.roomArr[indexPath.section]][indexPath.row];
    cell.roomNum.text = house.houseNum.stringValue;
    NSArray *rentInfo = house.rentInfo;
    if (rentInfo.count >0) {
        [rentInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Rent *rent = obj;
            if ([rent.rentIsDisable isEqual: @(0)]) {
                cell.roomStatus.text = @"已入住";
                cell.roomStatus.textColor = TDRGB(153, 153, 153);
            }else{
                cell.roomStatus.text = @"空置";
                cell.roomStatus.textColor = MainGreen;
            }
        }];
    }else{
        cell.roomStatus.text = @"空置";
        cell.roomStatus.textColor = MainGreen;
    }
    
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
    if (section % 3 == 0) {
        smallView.backgroundColor = MainBlue;
    }else if(section %3 == 1){
        smallView.backgroundColor = MainRed;
    }else{
        smallView.backgroundColor = MainGreen;
    }
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;//根据手机语言产生变化，数字变中文
    NSString *highNum = [formatter stringFromNumber:self.roomArr[section]];
    
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

-(void)passValue:(NSString *)value{
    for (int i = 0; i <self.apartmentArr.count; i++) {
        Community *community = self.apartmentArr[i];
        if (community.communityID.integerValue == value.integerValue) {
            self.currentAparment = community;
            break;
        }
    }
    self.apartmentName.text = self.currentAparment.communityName;
    [self getRoomList];
    [self.tableView reloadData];
}
//---点击公寓名字的view,跳转到公寓列表-----///
-(void)addTapForView{
    self.apartmentName.text = self.currentAparment.communityName;
    if (self.apartmentArr.count > 1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickToComList)];
        [self.comTitleView addGestureRecognizer:tap];
    }else{
        self.changLabel.hidden = YES;
    }
   
}
-(void)ClickToComList{
    
    ShowCommunityController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowCommunity"];
    vc.communityArray = self.apartmentArr;
    vc.curCommunity = self.currentAparment;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)getaparmentList:(NSNotification *)info{
    
}
#pragma mark -m 获取公寓信息


-(void)getRoomList{
    [self.roomArr removeAllObjects];
    [self.roomHighDic removeAllObjects];
    for (int i = 0; i < self.currentAparment.houseInfoList.count ; i ++) {
        House *house = self.currentAparment.houseInfoList[i];
        NSArray *roomHigh = [self.roomHighDic objectForKey:house.houseHightNum];
        if (roomHigh.count <=0) {
            NSArray *arr = [NSArray arrayWithObject:house];
            [self.roomHighDic setObject:arr forKey:house.houseHightNum];
            [self.roomArr addObject:house.houseHightNum];
        }else{
            NSMutableArray *oldRoomArr =  [[self.roomHighDic objectForKey:house.houseHightNum] mutableCopy];
            [oldRoomArr insertObject:house atIndex:0];
            [self.roomHighDic setObject:oldRoomArr forKey:house.houseHightNum];
        }
        
    }
    [self roomDicByHighNum];
}

//根据层排序
-(void)roomDicByHighNum{
    
    //block比较方法，数组中可以是NSInteger，NSString（需要转换）
    NSComparator finderSort = ^(id num1,id num2){
        
        if ([num1 integerValue] > [num2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([num1 integerValue] < [num2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
    };
    
    self.roomArr = [[self.roomArr sortedArrayUsingComparator:finderSort] mutableCopy];
    
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i <self.roomArr.count; i++) {
        
        NSArray *newArr =  [[[self.roomHighDic objectForKey:self.roomArr[i]] reverseObjectEnumerator] allObjects];
        [newDic setObject:newArr forKey:self.roomArr[i]];
        
    }
    //
    self.roomHighDic = newDic;
}

@end

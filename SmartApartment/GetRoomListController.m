//
//  GetRoomListController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#import "MyDelegate.h"
#import "GetRoomListController.h"
//#import "ShowCommunityController.h"
//#import "AccountRoomController.h"
#import "RoomStatusCell.h"
#import "NewSignRoomController.h"
#import "CheckSignRoomController.h"

#import "Community.h"
@interface GetRoomListController ()<MyDelegate>
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;
@property (weak, nonatomic) IBOutlet UILabel *changLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comTitleAutoWidth;
@property (weak, nonatomic) IBOutlet UIView *comTitleView;

@property(strong,nonatomic)NSArray<Community *> *apartmentArr;

@property(strong,nonatomic)NSMutableArray<NSString *> *communityNameArr;

@property(strong,nonatomic)NSMutableArray<NSString *> *communityCityArr;

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

-(NSMutableArray *)communityNameArr{
    if(_communityNameArr == nil){
        _communityNameArr = [NSMutableArray array];
    }
    return _communityNameArr;
}

-(NSMutableArray *)communityCityArr{
    if (_communityCityArr == nil) {
        _communityCityArr = [NSMutableArray array];
    }
    return _communityCityArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getaparmentList:) name:@"getApartmentList" object:nil];
     [self getApartmentList];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated{
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//        AccountRoomController *vc = [[UIStoryboard storyboardWithName:@"AccountBook" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountRoom"];
//    
//        vc.houseID = [NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseID"]];
//        NSArray *rentArr = [roomData objectForKey:@"rentInfo"];
//        for (int i= 0; i < rentArr.count; i++) {
//            NSDictionary *dic = rentArr[i];
//            NSString *isDisable = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rentIsDisable"]];
//            if (isDisable.integerValue == 0) {
//                vc.rentInfo = dic;
//                break;
//            }
//        }
//        
//        vc.delegate = self;
//        vc.houseNum = [NSString stringWithFormat:@"%@房",[roomData objectForKey:@"houseNum"]];
//        vc.communityName = self.apartmentName.text;
//        vc.apartmentID = [[roomData objectForKey:@"communityRelationInfo"][0] objectForKey:@"houseCommunityID"];
//        [self.navigationController pushViewController:vc animated:YES];
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
        NSLog(@"公寓ID--%@----传入的ID%@",community.communityID,value);
        if (community.communityID.integerValue == value.integerValue) {
//            currentAparmentDic = apartDic;
        }
    }
    self.apartmentName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"New_CommunityName"];
//    CGSize size = [self.apartmentName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.apartmentName.font,NSFontAttributeName, nil]];
//    [self.comTitleAutoWidth setConstant:size.width];
    [self getRoomList];
    [self.tableView reloadData];
}
//---点击公寓名字的view,跳转到公寓列表-----///
-(void)addTapForView{
    if (self.communityNameArr.count > 1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickToComList)];
        [self.comTitleView addGestureRecognizer:tap];
    }else{
        self.changLabel.hidden=YES;
    }
   
}
-(void)ClickToComList{
//    ShowCommunityController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowCommunity"];
//    vc.communityNameArr = communityCityNameArr;
//    vc.communityCityDic = communityCityNameDic;
//    vc.delegate = self;
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)getaparmentList:(NSNotification *)info{
    [self getApartmentList];
}
#pragma mark -m 获取公寓信息
-(void)getApartmentList{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"9999",@"pageSize" ,nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
            if (!err && [response intForKey:@"rcode"] == 10000) {
                NSLog(@"---%@",[response objectForKey:@"data"]);
                NSArray *comArr = [response objectForKey:@"data"];
                NSMutableArray* communityArray = [NSMutableArray array];
                int index = 0;
                for (NSDictionary* dic in comArr) {
                    Community* community = [Community yy_modelWithDictionary:dic];
                    [communityArray addObject:community];
                    if (index == 0) {
                        self.apartmentName.text = community.communityName;
                        [[NSUserDefaults standardUserDefaults] setObject:community.communityID forKey:@"comID"];
                        self.currentAparment = community;
                    }
                    
                    [self.communityNameArr addObject:community.communityName];
                    [self.communityCityArr addObject:community.communityCity];
                
                    index++;
                }
                 self.apartmentArr = communityArray;
                
                
                if (communityArray.count >0) {
                   
                    [self getRoomList];
                    
                }else{
                    self.apartmentName.text =@"暂无公寓";
                }
                
                [self addTapForView];
                
            }else{
                if (!err) {
                   RequestBad
                }else{
                    [Alert showFail:@"网络异常，请检查网络!" View:self.navigationController.navigationBar andTime:3 complete:nil];
                }

            }
        [self.tableView reloadData];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



-(void)getRoomList{
    
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

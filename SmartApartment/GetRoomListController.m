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
@interface GetRoomListController ()<MyDelegate>
@property (weak, nonatomic) IBOutlet UILabel *apartmentName;
@property (weak, nonatomic) IBOutlet UILabel *changLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comTitleAutoWidth;
@property (weak, nonatomic) IBOutlet UIView *comTitleView;

@end

@implementation GetRoomListController
{
    //公寓名字数组
    NSMutableArray *communityCityNameArr;
    //公寓城市的数组
    NSMutableDictionary *communityCityNameDic;
    //公寓数据数组
    NSArray *apartmentArr;
    //当前公寓字典
    NSDictionary *currentAparmentDic;
    //起始公寓名和ID
    NSString *startApartmentName;
    NSString *startApartmentID;
    
    NSMutableArray *roomArr;
    //层数字典--key是层数，value是房间
    NSMutableDictionary *roomHighDic;
    
    NSMutableArray *tempRoomArr;
    //排序后的房间数组
    NSArray *allRoomArr;
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
    
    return roomHighDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = [roomHighDic objectForKey:roomArr[section]];
    return arr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomStatusCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *roomData  = [roomHighDic objectForKey:roomArr[indexPath.section]][indexPath.row];
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
            vc.roomData =roomData;
            vc.communityName = self.apartmentName.text;
            [self.navigationController pushViewController: vc animated:YES];
        }else{
            CheckSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckSignRoom"];
            vc.houseID = [NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseID"]];
            vc.delegate = self;
            vc.communityName = self.apartmentName.text;
            vc.apartmentID = [[roomData objectForKey:@"communityRelationInfo"][0] objectForKey:@"houseCommunityID"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomStatusCell"];
    NSDictionary *roomData  = [roomHighDic objectForKey:roomArr[indexPath.section]][indexPath.row];
    cell.roomNum.text = [NSString stringWithFormat:@"%@",[roomData objectForKey:@"houseNum"]];
    NSArray *rentInfo = [roomData objectForKey:@"rentInfo"];
    if (rentInfo.count >0) {
        [rentInfo enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *rentDic = obj;
            NSString *rentOk =[NSString stringWithFormat:@"%@", [rentDic objectForKey:@"rentIsDisable"]];
            if (rentOk.integerValue == 0) {
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

-(void)passValue:(NSString *)value{
    for (int i = 0; i <apartmentArr.count; i++) {
        NSDictionary *apartDic = apartmentArr[i];
        NSLog(@"公寓ID--%@----传入的ID%@",[apartDic objectForKey:@"communityID"],value);
        if ([NSString stringWithFormat:@"%@",[apartDic objectForKey:@"communityID"]].integerValue ==value.integerValue) {
            currentAparmentDic = apartDic;
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
    if (communityCityNameArr.count > 1) {
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
    communityCityNameArr = [NSMutableArray arrayWithCapacity:0];
    communityCityNameDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"9999",@"pageSize" ,nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
        @try {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                NSArray *comArr = [response objectForKey:@"data"];
                if (comArr.count >0) {
                    apartmentArr = comArr;
                    for (int i = 0; i <comArr.count; i++) {
                        NSDictionary *dic = comArr[i];
                        //获取第一个公寓名
                        if (i == 0) {
                            self.apartmentName.text = [dic objectForKey:@"communityName"];
                            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"communityID"] forKey:@"comID"];
                            startApartmentName = self.apartmentName.text;
                            startApartmentID =[dic objectForKey:@"communityID"];
//                            CGSize size = [self.apartmentName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.apartmentName.font,NSFontAttributeName, nil]];
//                            [self.comTitleAutoWidth setConstant:size.width];
                            currentAparmentDic = apartmentArr[0];
                        }
                        NSDictionary *comDic =communityCityNameDic[[dic objectForKey:@"communityCity"]];
                        if (comDic.count <=0) {
                            NSArray *arr = [NSArray arrayWithObject:dic];
                            [communityCityNameArr addObject:[dic objectForKey:@"communityCity"]];
                            [communityCityNameDic setObject:arr forKey:[dic objectForKey:@"communityCity"]];
                        }else{
                            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                            NSArray *oldComArr = [communityCityNameDic objectForKey:[dic objectForKey:@"communityCity"]];
                            [arr addObject:dic];
                            for (int j = 0; j <oldComArr.count; j++) {
                                [arr addObject:oldComArr[j]];
                            }
                            [communityCityNameDic setObject:arr forKey:[dic objectForKey:@"communityCity"]];
                        }
                    }
                    
                    [self passValue:info.object];
                    
                }else{
                    self.apartmentName.text =@"暂无公寓";
                }
                
            }else{
                if (!err) {
                   RequestBad
                }else{
                    [Alert showFail:@"网络异常，请检查网络!" View:self.navigationController.navigationBar andTime:3 complete:nil];
                }
                
            }
        } @catch (NSException *exception) {
            NSLog(@"出现异常%@",exception);
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark -m 获取公寓信息
-(void)getApartmentList{
    communityCityNameArr = [NSMutableArray arrayWithCapacity:0];
    communityCityNameDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"9999",@"pageSize" ,nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
            if (!err && [response intForKey:@"rcode"] == 10000) {
                NSLog(@"----%@",[response objectForKey:@"data"]);
                NSArray *comArr = [response objectForKey:@"data"];
                if (comArr.count >0) {
                    apartmentArr = comArr;
                    for (int i = 0; i <comArr.count; i++) {
                        NSDictionary *dic = comArr[i];
                        //获取第一个公寓名
                        if (i == 0) {
                            self.apartmentName.text = [dic objectForKey:@"communityName"];
                            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"communityID"] forKey:@"comID"];
                            startApartmentName = self.apartmentName.text;
                            startApartmentID =[dic objectForKey:@"communityID"];
//                            CGSize size = [self.apartmentName.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.apartmentName.font,NSFontAttributeName, nil]];
//                            [self.comTitleAutoWidth setConstant:size.width];
                            currentAparmentDic = apartmentArr[0];
                        }
                        NSDictionary *comDic =communityCityNameDic[[dic objectForKey:@"communityCity"]];
                        if (comDic.count <=0) {
                            NSArray *arr = [NSArray arrayWithObject:dic];
                            [communityCityNameArr addObject:[dic objectForKey:@"communityCity"]];
                            [communityCityNameDic setObject:arr forKey:[dic objectForKey:@"communityCity"]];
                        }else{
                            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                            NSArray *oldComArr = [communityCityNameDic objectForKey:[dic objectForKey:@"communityCity"]];
                            [arr addObject:dic];
                            for (int j = 0; j <oldComArr.count; j++) {
                                [arr addObject:oldComArr[j]];
                            }
                            [communityCityNameDic setObject:arr forKey:[dic objectForKey:@"communityCity"]];
                        }
                    }
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

-(void)getRoomList{
    roomArr = [NSMutableArray arrayWithCapacity:0];
    roomHighDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *arr = [currentAparmentDic objectForKey:@"houseInfoList"];
    allRoomArr = arr;
    for (int i = 0; i < arr.count ; i ++) {
        NSDictionary *roomDic = arr[i];
        NSArray *roomHigh = [roomHighDic objectForKey:[roomDic objectForKey:@"houseHightNum"]];
        if (roomHigh.count <=0) {
            NSArray *arr = [NSArray arrayWithObject:roomDic];
            [roomHighDic setObject:arr forKey:[roomDic objectForKey:@"houseHightNum"]];
            [roomArr addObject:[roomDic objectForKey:@"houseHightNum"]];
        }else{
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *oldRoomArr =  [roomHighDic objectForKey:[roomDic objectForKey:@"houseHightNum"]];
            [arr addObject:roomDic];
            for (int i = 0; i < oldRoomArr.count; i++) {
                [arr addObject:oldRoomArr[i]];
            }
            [roomHighDic setObject:arr forKey:[roomDic objectForKey:@"houseHightNum"]];
        }
        
    }
    tempRoomArr = [NSMutableArray arrayWithArray:allRoomArr];
    [self roomDicByHighNum];
}

@end

//
//  SAapartmentViewController.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//  公寓列表

#import "SAapartmentViewController.h"

#import "SAapartementCell.h"
//#import "BatchAddRoomController.h"
#import "SAapartementAddCell.h"
#import "SAaddApartmentTableviewController.h"
#import "MJRefresh.h"
#import "SAeditApartmentTableViewController.h"

#import "SAcreatemoreHouseVC.h"
#import "SAcreatemoreHouseVC.h"

#import "SAshowhouseCollectionVC.h"

//#import "SVProgressHUD.h"

//#import "UIImage+UIImageScale.h"

#import "MBProgressHUD.h"

#import "YYModel.h"
#import "Geography.h"
#import "Community.h"

#import "ApertmentRejectController.h"
@interface SAapartmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *editWriteBtn;

@property(nonatomic,strong)NSIndexPath *indexPath;

@property(nonatomic,strong)NSIndexPath *clickIndexPath;//被点击的公寓

@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *apartmentList;

@property(nonatomic,strong)NSArray* apertmentArray;


@property(nonatomic,assign)BOOL isEditSelected;
@end

@implementation SAapartmentViewController

- (NSMutableArray *)apartmentList{
    
    if (_apartmentList == nil) {
        _apartmentList = [NSMutableArray array];
    }
    return _apartmentList;
    
}

- (NSMutableArray *)areaArray{
    if (_areaArray==nil) {
        _areaArray=[NSMutableArray array];
    }
    return _areaArray;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    [self requestGetAreaList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self bbEndRrefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 结束更新
- (void)bbEndRrefresh{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)requestGetAreaList{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];;
    params[@"key"] = [ModelTool find_UserData].key;
    [WebAPIForRenthouse getAreaList:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"]  == 10000) {
            NSArray* array =  response[@"data"][0];
            for (NSDictionary* dic in array) {
                Geography* geography = [Geography yy_modelWithDictionary:dic];
                [self.areaArray addObject:geography];
            }
        }
        [self.tableView.mj_header beginRefreshing];
    }];
}

//*****************************添加表格视图
//*****************************添加表格视图
//*****************************添加表格视图
//*****************************添加表格视图
//*****************************添加表格视图
//*****************************添加表格视图

- (void)addTableView{

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"SAapartementCell" bundle:nil]  forCellReuseIdentifier:@"SAapartementCell"];
    [tableView registerNib:[UINib nibWithNibName:@"SAapartementAddCell" bundle:nil]  forCellReuseIdentifier:@"SAapartementAddCell"];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself requestApartmentList];
    }];
}

//*****************************请求公寓列表
//*****************************请求公寓列表
//*****************************请求公寓列表
//*****************************请求公寓列表
//*****************************请求公寓列表
//*****************************请求公寓列表

#pragma mark - 请求公寓列表
- (void)requestApartmentList{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]= [ModelTool find_UserData].key;
    params[@"pageSize"]=@"100000";
    
    [WebAPIForRenthouse requestApartmentList:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            NSArray *comArr = [response objectForKey:@"data"];
            for (NSDictionary* dic in comArr) {
                Community* community = [Community yy_modelWithDictionary:dic];
                [self.apartmentList addObject:community];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showMessage:[response objectForKey:@"rmsg"]];
        }
        [self bbEndRrefresh];

        
    }];
}

#pragma mark - cell代理

- (void)clickEdit:(UIButton *)btn{

    Community *community = self.apartmentList[btn.tag];
    SAeditApartmentTableViewController *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAeditApartmentTableViewController"];
    vc.communityNodeID = community.communityNodeID.stringValue;
    vc.communityCity = community.communityCity;
    vc.apartmentID=[NSString stringWithFormat:@"%@",community.communityID];
    vc.apartmentNameString=community.communityName;
    vc.apartmentAddressString=community.communityAddress;
    vc.powerMoneyString=community.communityElectricUnitPrice;
    vc.waterMoneyString=community.communityWaterUnitPrice;
    vc.otherMoneyString=community.communityOtherChargePrice;
    vc.otherMoneyDescriptionString=community.communityOtherChargeDesc;
    vc.apartmentPicArray=community.communityPicAffixs;
    
    //进入编辑后，退出编辑模式
    self.editWriteBtn.selected=NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.apartmentList.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<self.apartmentList.count) {
        return 250;
    }else{
        return 190;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row < self.apartmentList.count) {
        //公寓cell
        static NSString *doorRecodrID = @"SAapartementCell";
        SAapartementCell *cell = [tableView dequeueReusableCellWithIdentifier:doorRecodrID];
        [cell.editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchDown];
        cell.editBtn.tag=indexPath.row;
        if (cell == nil) {
            cell = [[SAapartementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doorRecodrID];
            [cell.editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchDown];
            cell.editBtn.tag=indexPath.row;
        }
        
        cell.editBtn.hidden= !self.editWriteBtn.selected;
        cell.community =self.apartmentList[indexPath.row];
        return cell;
    }else{
        //加号cell
        static NSString *doorRecodrID = @"SAapartementAddCell";
        SAapartementAddCell *cell = [tableView dequeueReusableCellWithIdentifier:doorRecodrID];
        if (cell == nil) {
            cell = [[SAapartementAddCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:doorRecodrID];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.editWriteBtn.selected) {
        [MBProgressHUD showMessage:@"请退出编辑模式"];
        return;
    }
    
    if (self.tableView.mj_header.state  == MJRefreshStateRefreshing || self.tableView.mj_footer.state  == MJRefreshStateRefreshing) {
        return;
    }
    
    if (indexPath.row<self.apartmentList.count) {

        //展示房间
        //10认证中，20认证失败，30认证通过
        Community *community = self.apartmentList[indexPath.row];
         [[NSUserDefaults standardUserDefaults] setObject:community.communityName forKey:@"communityName"];
    
        //备用先不认证公寓
//        if (community.communityStatus==30 ) {
//            
//        }else
        //公寓被驳回
        if(community.communityStatus.integerValue == 20){
            ApertmentRejectController *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"ApertmentReject"];
            vc.communityDic = self.apertmentArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
            return;
            
        }else{
            SAshowhouseCollectionVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAshowhouseCollectionVC"];
            vc.communityID = community.communityID.stringValue;
            vc.bbWaterPrice = community.communityWaterUnitPrice;
            vc.bbElectricPrice = community.communityElectricUnitPrice;
            vc.bbOtherPrice = community.communityOtherChargePrice;
            //vc.houseInfoArray=community.houseInfoList;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
//--------------------------------------
//            else{
//            //[Alert showFail:@"认证中" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        }
    }else{
        //添加公寓
        SAaddApartmentTableviewController *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"addnewApartment"];
        vc.areaArray=self.areaArray;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)clickToPop:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - 滑动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < self.apartmentList.count) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        Community *community = self.apartmentList[indexPath.row];
        if (indexPath.row<[self.apartmentList count]) {
            [self requestDelteApartment:community tableView:tableView IndexPath:indexPath];
            
        }
    }
    
}

- (void)requestDelteApartment:(Community*)apartmentModel tableView:(UITableView*)tableview IndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = [ModelTool find_UserData].key;
    params[@"communityID"]=[NSString stringWithFormat:@"%@",apartmentModel.communityID];
    
    [WebAPIForRenthouse deleteApartment:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            [self.apartmentList removeObjectAtIndex:indexPath.row];
            [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [MBProgressHUD showMessage:[response objectForKey:@"rmsg"]];
        }
    }];
}

#pragma mark - 编辑公寓
- (IBAction)editApartment:(UIButton*)sender{
    
    _isEditSelected = !_isEditSelected;
    self.editWriteBtn.selected = _isEditSelected;
    [self.tableView reloadData];
//    [self resetBtnView];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self resetBtnView];
//}

//- (void)resetBtnView{
//    if (self.editWriteBtn.selected) {
//        NSArray *array = self.tableView.visibleCells;
//        for (UITableViewCell *cell in array) {
//            if ([cell isKindOfClass:[SAapartementCell class]]) {
//                SAapartementCell *cell2=(SAapartementCell *)cell;
//                cell2.editBtn.hidden=NO;
//            }
//        }
//    }else{
//        NSArray *array = self.tableView.visibleCells;
//        for (UITableViewCell *cell in array) {
//            if ([cell isKindOfClass:[SAapartementCell class]]) {
//                SAapartementCell *cell2=(SAapartementCell *)cell;
//                cell2.editBtn.hidden=YES;
//            }
//        }
//    }
//}



@end

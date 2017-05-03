//
//  SAshowhouseCollectionVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//  展示房间

#import "SAshowhouseCollectionVC.h"
#import "SAshowhouseCollectionViewCell.h"
#import "SAshowhouseAddCollectionViewCell.h"

#import "SAcreatemoreHouseVC.h"


//#import "SAhouseInfoModel.h"

//#import "MJExtension.h"

//#import "RoomPayMsgController.h"

#import "SAcreateOneHouseVC.h"
#import "NewSignRoomController.h"
#import "CheckSignRoomController.h"

//#import "RenterRoomMsgController.h"

//#import "SAapartmentModel.h"

//#import "SAChargeModel.h"

#import "MJRefresh.h"

@interface SAshowhouseCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property(nonatomic,strong)NSMutableArray *houseArrayList;
@property(nonatomic,strong)NSMutableArray *communityhouseArrayList;
@property(nonatomic,strong)NSMutableArray *chargeList;
@property(nonatomic,copy)NSString *stringKey;
@end

@implementation SAshowhouseCollectionVC{
    //int cout;
    int padding;
    int rowCount;
    BOOL hasCollectionView;
    BOOL isRefreshing;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.stringKey= [ModelTool find_UserData].key;
    padding=15;
    rowCount=3;
    [self initCollectionView];
    [self bbStartHeadRefresh];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.communityhouseArrayList = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self bbEndRrefresh];
    NSLog(@"停止刷新");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 开始更新
- (void)bbStartHeadRefresh{
   
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getCommunityHouseListWithApartmentApi];
    }];
    [self.collectionView.mj_header beginRefreshing];
    isRefreshing=true;
}
#pragma mark - 结束更新
- (void)bbEndRrefresh{
    isRefreshing=false;
    [self.collectionView.mj_header endRefreshing];
}

#pragma mark  设置CollectionView的的参数
- (void) initCollectionView
{
    if (!self.collectionView) {
        hasCollectionView=true;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-20) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
        self.collectionView.backgroundColor=[UIColor whiteColor];
        //注册Cell
        static NSString * const reuseIdentifier = @"SAshowhouseCollectionViewCell";
        [self.collectionView registerNib:[UINib nibWithNibName:@"SAshowhouseCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        static NSString * const reuseIdentifier2 = @"SAshowhouseAddCollectionViewCell";
        [self.collectionView registerNib:[UINib nibWithNibName:@"SAshowhouseAddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier2];
        [self.view addSubview:self.collectionView];
    }
}

//请求公寓房间列表
- (void)getCommunityHouseListWithApartmentApi{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    params[@"pageSize"]=@"100000";
    [WebAPIForRenthouse requestApartmentList:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//
//            NSArray *array = response[@"data"];
//            
//            if (array.count>0) {
//                 [self.communityhouseArrayList  removeAllObjects];
//                for (int i = 0 ; i < array.count; i ++) {
//                    
//                    NSDictionary *obj = array[i];
//                    SAapartmentModel *apartmentModel = [SAapartmentModel mj_objectWithKeyValues:obj];
//                    
//                    NSString *communityIDString = [NSString stringWithFormat:@"%d",apartmentModel.communityID];
//                    if ([communityIDString isEqualToString:self.communityID]) {
//                        [self.communityhouseArrayList addObjectsFromArray:apartmentModel.houseInfoList];
//                    }
//                }
//                [self dealDataWithApartment];
//            }else{
//                [self bbEndRrefresh];
//            }
//            
//        }else{
//            [self bbEndRrefresh];
//            NSString *string =[response objectForKey:@"rmsg"];
//            if (string.length>0) {
//                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//            }
//        }
    }];
}

- (void)dealDataWithApartment{
    [self.houseArrayList removeAllObjects];
    
    for (int i =0; i<self.communityhouseArrayList.count; i++) {
//todo
//        SAhouseInfoModel *model = [SAhouseInfoModel mj_objectWithKeyValues:self.communityhouseArrayList[i]];
//        [self.houseArrayList addObject:model];
    }
    
    [self requestChargeInfoData];
}

- (NSString *)dateNow{
    NSString* date=[[NSString alloc]init];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMM"];
    date = [formatter stringFromDate:[NSDate date]];
    return date;
}

//请求费用数据
- (void)requestChargeInfoData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=self.stringKey;
    params[@"communityID"]=self.communityID;
    [WebAPIForRenthouse getCommunityNoPayOrder:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            NSArray *ary = response[@"data"];
//            if (ary.count>0) {
//                [self.chargeList removeAllObjects];
//                [self bbEndRrefresh];
//                [self.chargeList addObjectsFromArray:ary];
//            }
//        }
//        [self bbEndRrefresh];
//        [self.collectionView reloadData];
        
    }];
}

#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.houseArrayList.count+1;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     NSLog(@"%ld",(unsigned long)self.houseArrayList.count);
    if (indexPath.row<self.houseArrayList.count) {
        static NSString *identify = @"SAshowhouseCollectionViewCell";
        SAshowhouseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        cell.communityID=self.communityID;
        
        cell.billArray=self.chargeList;
        cell.model=self.houseArrayList[indexPath.row];
       
        if (self.deleteBtn.selected) {
            cell.deleteBtn.hidden=NO;
            cell.closeImage.hidden=NO;
        }else{
           cell.deleteBtn.hidden=YES;
            cell.closeImage.hidden=YES;
        }
        
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        static NSString *identify = @"SAshowhouseAddCollectionViewCell";
        SAshowhouseAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        if (self.houseArrayList.count>0) {
            cell.addHouseLabel.text=@"添加房间";
        }else{
            cell.addHouseLabel.text=@"批量添加房间";
        }
        return cell;
    }
}

#pragma mark - 删除房间
- (void)deleteBtnClik:(UIButton *)sender {
    [self showAlertController:sender];
}

- (void)showAlertController:(UIButton *)sender{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除房间吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [_collectionView performBatchUpdates:^{
            [self requestDeleteHose:sender.tag];
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark - 请求后台删除房屋
- (void)requestDeleteHose:(NSInteger)tag{
//    SAhouseInfoModel *model = self.houseArrayList[tag];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"key"]=self.stringKey;
//    params[@"houseID"]=model.houseID;
//    [WebAPIForRenthouse deleteHouse:params callback:^(NSError *err, id response) {
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            [Alert showFail:[NSString stringWithFormat:@"删除房屋%@",responseModel.rmsg] View:self.navigationController.navigationBar andTime:WARNING_TIME complete:^(BOOL isComplete) {
//                
//            }];
//    
//            [self.houseArrayList removeObjectAtIndex:tag];
//            [self.collectionView reloadData];
//            if (self.houseArrayList.count==0) {
//                self.deleteBtn.selected=false;
//            }
//            [self resetBtnView];
//        }else{
//            NSString *string =[response objectForKey:@"rmsg"];
//            if (string.length>0) {
//                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//            }
//        }
//    }];
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width =(self.view.width - (rowCount+2)*padding  *ratio)/rowCount;
    return  CGSizeMake(width,width/105*127);
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(padding *ratio, padding *ratio, padding *ratio, padding *ratio);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return padding *ratio;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return padding *ratio;
}

#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.deleteBtn.selected) {
        [Alert showFail:@"请退出编辑模式" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
//todo
//    if (indexPath.row<self.houseArrayList.count) {
//        //FIXME:跳转给辉
//        SAhouseInfoModel *model = self.houseArrayList[indexPath.row];
//        
//        if ([model.houseStatus isEqualToString:LOGINHOUSE]) {
//            CheckSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckSignRoom"];
//            vc.houseID = model.houseID;
//            vc.apartmentID = self.communityID;
//            vc.communityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"communityName"];
//            [self.navigationController pushViewController:vc animated:YES];
//        }else if([model.houseStatus isEqualToString:EMPTYHOUSE]){
//            NewSignRoomController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"NewSignRoom"];
//            NSMutableDictionary *dic = [model mj_keyValues];
//            vc.roomData =dic;
//            vc.communityName = [[NSUserDefaults standardUserDefaults] objectForKey:@"communityName"];
//            [self.navigationController pushViewController: vc animated:YES];
//            //没签约
////            RoomPayMsgController *vc = [[UIStoryboard storyboardWithName:@"ApartmentManager" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomPayMsg"];
////            vc.houseId=model.houseID;
////            vc.comID=self.communityID;
////            [self.navigationController pushViewController:vc animated:YES];
//        }
//        
//    }else{
//        //批量建房
//        if (self.houseArrayList.count>0) {
//            SAcreateOneHouseVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreateOneHouseVC"];
//            vc.communityID=self.communityID;
//            
//            [self.navigationController pushViewController:vc animated:YES];
//        }else{
//            SAcreatemoreHouseVC *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreatemoreHouseVC"];
//            vc.communityID=self.communityID;
//            vc.bbElectricPrice=self.bbElectricPrice;
//            vc.bbWaterPrice=self.bbWaterPrice;
//            vc.bbOtherPrice=self.bbOtherPrice;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        
//    }
    
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark-跳转退出
- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)houseArrayList{
    if (_houseArrayList == nil) {
        _houseArrayList = [NSMutableArray array];
    }
    return _houseArrayList;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resetBtnView];
}

#pragma mark - 删除房间
- (IBAction)deleteHouse:(UIButton*)sender {
    self.deleteBtn=sender;
    self.deleteBtn.selected = !self.deleteBtn.selected;
    [self resetBtnView];
}

- (void)resetBtnView{
    if (self.deleteBtn.selected) {
        NSArray *array = self.collectionView.visibleCells;
        for (UICollectionViewCell *cell in array) {
            if ([cell isKindOfClass:[SAshowhouseCollectionViewCell class]]) {
                SAshowhouseCollectionViewCell *cell2=(SAshowhouseCollectionViewCell *)cell;
                cell2.deleteBtn.hidden=NO;
                cell2.closeImage.hidden=NO;
            }
        }
    }else{
        NSArray *array = self.collectionView.visibleCells;
        for (UICollectionViewCell *cell in array) {
            if ([cell isKindOfClass:[SAshowhouseCollectionViewCell class]]) {
                SAshowhouseCollectionViewCell *cell2=(SAshowhouseCollectionViewCell *)cell;
                cell2.deleteBtn.hidden=YES;
                cell2.closeImage.hidden=YES;
            }
        }
    }
}

- (NSMutableArray *)communityhouseArrayList{
    if (_communityhouseArrayList == nil) {
        _communityhouseArrayList = [NSMutableArray array];
    }
    return _communityhouseArrayList;
}

- (NSMutableArray *)chargeList{
    if (_chargeList == nil) {
        _chargeList = [NSMutableArray array];
    }
    return _chargeList;
}

@end

//
//  SAcreathouseFinishVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//  批量创建房屋完成界面

#import "SAcreathouseFinishVC.h"
#import "SAhouseDecripitionCell.h"

//#import "SAhouseDescriptionDodel.h"

//#import "SVProgressHUD.h"

//#import "MJExtension.h"

#import "SAcreathouseFinishEditViewController.h"

@interface SAcreathouseFinishVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *countArray;
@property(nonatomic,strong)NSMutableDictionary *countDict;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *allhouseArray;

@property(nonatomic,copy)NSString *editString;
@property(nonatomic,copy)NSString *keyString;
@end

@implementation SAcreathouseFinishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightBtn];
    self.keyString = [ModelTool find_UserData].key;
    [self.countDict removeAllObjects];
    self.countDict=self.houseDict;
    if (self.countDict.count>0) {
        [self addTableView];
    }
    [self dealData];
    NSLog(@"[SAcreathouseFinishVC communityID]%@",self.communityID);
}

- (void)dealData{
    
    [self.countDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyvalue=key;
        
        NSString *objvalue=obj;
        int objint = objvalue.intValue;
        for (int i=0; i<objint; i++) {
//todo
//            SAhouseDescriptionDodel *model = [[SAhouseDescriptionDodel alloc]init];
//            if (i<9) {
//                model.houseNumber=[NSString stringWithFormat:@"%@0%d",keyvalue,i+1];
//            }else{
//                model.houseNumber=[NSString stringWithFormat:@"%@%d",keyvalue,i+1];
//            }
//            
//            model.houseRentMoney= [NSString stringWithFormat:@"租金%@元/月",self.rentMoneyString];
//            model.houseDepostMoney= [NSString stringWithFormat:@"押金%@元",self.depostiMoneyString];
//            model.houseRentMoneyNumber=self.rentMoneyString;
//            model.houseDepostMoneyNumber=self.depostiMoneyString;
//            [self.allhouseArray addObject:model];
        }
    }];
    
    NSSortDescriptor  *moneyWithSort ;
    moneyWithSort  =[[NSSortDescriptor alloc]initWithKey:@"houseNumber" ascending:YES];
    NSArray *elementarr=[NSArray arrayWithObjects:moneyWithSort, nil];
    self.allhouseArray=[NSMutableArray arrayWithArray:[self.allhouseArray sortedArrayUsingDescriptors:elementarr]];
}

- (void)addTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-164)];
    tableView.delegate   = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"SAhouseDecripitionCell" bundle:nil]  forCellReuseIdentifier:@"SAhouseDecripitionCell"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    [self initBtn];
}

- (void)initBtn{
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundColor:TDGROBAL_COLOR];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(requestCreatMoreHouse) forControlEvents:UIControlEventTouchDown];
    [btn setFrame:CGRectMake(0, self.tableView.y+self.tableView.height+20, 205, 38)];
    [btn setCenterX:self.view.centerX];
    btn.layer.cornerRadius=8;
    [self.view addSubview:btn];
}

#pragma mark - 按钮点击  完成批量建房

- (void)requestCreatMoreHouse{
    if ([self.editString isEqualToString:@"取消"]) {
        [Alert showFail:@"请退出编辑模式" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
//todo
//    [SVProgressHUD showWithStatus:@""];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"communityID"]=self.communityID;
    params[@"houseData"]=[self pingString];
    params[@"key"]=self.keyString;
//todo
//    [WebAPIForRenthouse creatRenthouse:params callback:^(NSError *err, id response) {
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            
//            [SVProgressHUD dismiss];
//            
//            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
//            
//            if(index>2){
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
//            }else{
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            }
//        }else{
//            NSString *string =[response objectForKey:@"rmsg"];
//            if (string.length>0) {
//                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//            }
//            [SVProgressHUD dismiss];
//        }
//    }];
}

#pragma mark -拼接数据
- (NSString*)pingString{
    NSMutableArray *array = [NSMutableArray array];
//todo
//    for (SAhouseDescriptionDodel *model in self.allhouseArray) {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[@"houseNum"]=model.houseNumber;//房号
//        dict[@"monthRent"]=model.houseRentMoneyNumber;//租金
//        dict[@"rentDeposit"]=model.houseDepostMoneyNumber;//押金
//        dict[@"houseWaterUnitPrice"]=self.bbWaterPrice;
//        dict[@"houseElectricUnitPrice"]=self.bbElectricPrice;
//        
//        //默认值
//        dict[@"initWater"]=@"";
//        dict[@"initElectric"]=@"";
//        dict[@"houseOtherChargePrice"]=self.bbOtherPrice;
//        dict[@"houseOtherChargeDesc"]=@"";
//        [array addObject:dict];
//    }
    
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:array] encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allhouseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SAhouseDecripitionCell";
    SAhouseDecripitionCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[SAhouseDecripitionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    cell.model=self.allhouseArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//todo
//    SAcreathouseFinishEditViewController *vc = [[UIStoryboard storyboardWithName:@"rentHouse" bundle:nil] instantiateViewControllerWithIdentifier:@"SAcreathouseFinishEditViewController"];
//    SAhouseDescriptionDodel *selectmodel = self.allhouseArray[indexPath.row];
//    
//    vc.depositMoneyString=selectmodel.houseDepostMoneyNumber;
//    vc.rentMoneyString=selectmodel.houseRentMoneyNumber;
//    vc.homeNum=selectmodel.houseNumber;
//    vc.TDPersonMyDataDetailViewControllerBlock =^(NSString *rentMoeny ,NSString *depositMoeny){
//        selectmodel.houseRentMoney= [NSString stringWithFormat:@"租金%@元/月",rentMoeny];
//        selectmodel.houseDepostMoney= [NSString stringWithFormat:@"押金%@元",depositMoeny];
//        NSMutableArray *tempHouseArray = [NSMutableArray array];
//        tempHouseArray =self.allhouseArray;
//        [tempHouseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            SAhouseDescriptionDodel *model= obj;
//            if (model.houseNumber==selectmodel.houseNumber) {
//                model.houseRentMoneyNumber=rentMoeny;
//                model.houseDepostMoneyNumber=depositMoeny;
//                self.allhouseArray=tempHouseArray;
//                
//                SAhouseDescriptionDodel *model= self.allhouseArray[0];
//                NSLog(@"%@",model.houseRentMoney);
//            }
//        }];
//        
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return TRUE;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row<[self.allhouseArray count]) {
            //注意：要做的操作必须在删除之前，就是在removeObjectAtIndex之前
            [self.allhouseArray removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -m 点击保存，返回到初始建房的界面
- (IBAction)clickToPopRoomList:(id)sender {

}

- (NSMutableArray *)countArray{
    if (_countArray == nil) {
        _countArray = [NSMutableArray array];
    }
    return _countArray;
}

- (NSMutableArray *)allhouseArray{
    if (_allhouseArray == nil) {
        _allhouseArray = [NSMutableArray array];
    }
    return _allhouseArray;
}

- (void)addRightBtn{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat H = 21.5;
    [button setFrame:CGRectMake(0, 0, H*2, H)];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(clickRightBarAction:) forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = leftItem;
}

- (void)clickRightBarAction:(UIButton *)sender
{
    
    //如果tableView处于编辑状态
    if (self.tableView.editing) {
        //取消tableView编辑状态
        self.tableView.editing = NO;
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        self.editString=@"编辑";
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObject:[self.navigationItem.rightBarButtonItems firstObject]];
    }
    else
    {
        //设置tableView编辑状态
        self.tableView.editing = YES;
        // 设置 导航栏左边第一个的UIBarButtonItem标题
        [sender setTitle:@"取消" forState:UIControlStateNormal];
        self.editString=@"取消";
        // 设置 导航栏左边的UIBarButtonItem
        NSMutableArray *mArr = [NSMutableArray arrayWithObject:[self.navigationItem.rightBarButtonItems firstObject]];
        self.navigationItem.rightBarButtonItems = mArr;
    }
}

@end

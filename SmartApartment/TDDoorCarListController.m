//
//  TDDoorCarListController.m
//  SmartApartment
//
//  Created by Jevons on 2017/5/4.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDDoorCarListController.h"
#import "AcModel.h"
#import "MJRefresh.h"
#import "SelectDoorCardCell.h"

#import "TDBindingICCardStartViewController.h"
@interface TDDoorCarListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableView;

@end

@implementation TDDoorCarListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
//    [self getAcList];
    
}


-(void)setupTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAcList)];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectDoorCardCell" bundle:nil] forCellReuseIdentifier:@"SelectDoorCardCell"];
    [self.view addSubview:self.tableView];
    
    if (self.acModelArray.count>0) {
        [self.tableView reloadData];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.acModelArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectDoorCardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectDoorCardCell"];
    cell.acmodel = self.acModelArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectDoorCardCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.mode == SelectDoorCardCellDisabled) {
        return;
    }
    cell.mode = SelectDoorCardCellChecked;
    TDBindingICCardStartViewController* vc = [[TDBindingICCardStartViewController alloc]init];
    vc.houseID = self.houseID;
    vc.acmodel = cell.acmodel;
    vc.memberID = self.memberID;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

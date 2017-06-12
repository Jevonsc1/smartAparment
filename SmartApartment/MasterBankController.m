

//
//  MasterBankController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//  提现

#import "MasterBankController.h"
#import "MoneyRecordCell.h"


#import "SAMastermoeny.h"

#import "SATakeoutMoneyVC.h"

#import "SAMastermoneyCell.h"

#import "SAMastermoeny.h"

#import "MasterMyBankController.h"

#import "SAUserbobankModel.h"

#import "SAUserboModel.h"

#import "SAUserdataModel.h"

#import "SAEmptyresultView.h"

#import "SAMastermoneyNew.h"

@interface MasterBankController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UILabel *waitPayMoney;//待结算金额
@property (weak, nonatomic) IBOutlet UITextField *searchBar;//搜索的内容
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyAutoHeight;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (weak, nonatomic) IBOutlet UIView *waitPaymoneyView;
@property (weak, nonatomic) IBOutlet UIView *searchBarView;

@property (nonatomic,strong)UIAlertController *alertController;

@property(nonatomic,strong)NSMutableArray *moenyListArray;

@property(nonatomic,strong)NSMutableArray *moenyListArrayBackup;

@property(nonatomic,strong)SAEmptyresultView *empthResultView;

@property(nonatomic,strong)NSMutableArray *tempListArray;

@property(nonatomic,strong)UIView *tipSView;

@end

@implementation MasterBankController{
    NSInteger arrIndex;
    NSMutableArray *searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableview];
    //self.searchBar.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestSearch:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self requestData];
    
    self.waitPayMoney.hidden=YES;
    
    //请求待结算金额
    [self requestAvailablePD];
    //请求屋主金额来往数据
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter ]removeObserver:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 开始搜索

- (void)requestSearch:(NSNotification *)info{
    UITextField *string = info.object;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userName"]=string.text;
    params[@"pageSize"]=[NSString stringWithFormat:@"%d",INT_MAX];
    params[@"pageNum"]= @"0";
    params[@"key"]= [ModelTool find_UserData].key;
    if (string.text.length>0) {
        [WebAPI searchPDRechargeLog:params callback:^(NSError *err, id response) {
            if (!err && [response intForKey:@"rcode"] ==10000) {
                
                NSArray *array =response[@"data"];
                if (array.count==0) {
                    //结果为空的view
                    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SAEmptyresultView" owner:self options:nil];
                    self.empthResultView = [nib objectAtIndex:0];
                    [self.empthResultView setFrame:CGRectMake(0, self.searchBarView.y+self.searchBarView.height, self.view.width, self.view.height)];
                    [self.view addSubview:self.empthResultView];
                    
                    [Alert showFail:@"搜索结果为空" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }else{
                    for (UIView *view in self.view.subviews) {
                        if ([view isKindOfClass:[SAEmptyresultView class]]) {
                            [view removeFromSuperview];
                        }
                    }
                    
                    [self.moenyListArray removeAllObjects];
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.moenyListArray addObject: [SAMastermoeny yy_modelWithDictionary:obj]];
                    }];
                    
                }
                
                [self.tableview reloadData];
            }else{
                NSString *string =[response objectForKey:@"rmsg"];
                if (string.length>0) {
                    [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }else{
                    [Alert showFail:@"请求数据超时，请稍后再试" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }
            }
        }];
    }else{
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[SAEmptyresultView class]]) {
                [view removeFromSuperview];
            }
        }
        //退出搜索，返回旧值
        [self.moenyListArray removeAllObjects];
        [self.moenyListArray addObjectsFromArray: self.moenyListArrayBackup];
        [self.tableview reloadData];
    }
    
}

-(void)requestAvailablePD{
    if (self.masterUser) {
        self.waitPayMoney.hidden = NO;
        self.waitPayMoney.text = self.masterUser.memberAvailablePD;
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"key"]=[ModelTool find_UserData].key;
        
        [WebAPI getBOInfo:params callback:^(NSError *err, id response) {
            if (!err && [response intForKey:@"rcode"] ==10000) {
                SAUserdataModel *model = [SAUserdataModel yy_modelWithDictionary:response[@"data"]];
                self.waitPayMoney.hidden=NO;
                self.waitPayMoney.text = model.memberAvailablePD;
                
            }else{
                NSString *string =[response objectForKey:@"rmsg"];
                if (string.length>0) {
                    [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }else{
                    [Alert showFail:@"请求数据超时，请稍后再试" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
                }
            }
        }];
    }
    
}

#pragma mark - 请求结算金额数据
-(void)requestData{
    [self.moenyListArray removeAllObjects];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=[ModelTool find_UserData].key;
    params[@"pageSize"]=[NSString stringWithFormat:@"%d",INT_MAX];
    params[@"pageNum"]=@"0";
    //旧getPDRechargeLog
    //新getPDCashLog暂时不用
    [WebAPI getPDRechargeLog:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"]==10000) {
            //保存数据
            NSArray *array =response[@"data"];
            NSMutableArray *mutarray =[[NSMutableArray alloc]init];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               [mutarray addObject: [SAMastermoeny yy_modelWithDictionary:obj]];
                //[mutarray addObject: [SAMastermoneyNew mj_objectWithKeyValues:obj]];
            }];
            [self.moenyListArray addObjectsFromArray:[[mutarray reverseObjectEnumerator]allObjects]];
            [self.moenyListArrayBackup addObjectsFromArray:self.moenyListArray];
            
        }
        else{
            if (err) {
                [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    
                }];
            }else
            {
                RequestBad
            }
        }
         [self.tableview reloadData];
        
    }];
    
}

- (void)addTableview{
    self.tableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"SAMastermoneyCell" bundle:nil]  forCellReuseIdentifier:@"SAMastermoneyCell"];
}

#pragma mark - 表格视图

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moenyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"SAMastermoneyCell";
    SAMastermoneyCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (cell == nil) {
        cell = [[SAMastermoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    }
    
    cell.model=self.moenyListArray[indexPath.row];
    //cell.modelNew=self.moenyListArray[indexPath.row];
    cell.masterRoom.hidden=YES;
    
    return cell;
}

#pragma mark - 显示隐藏搜索按钮

- (IBAction)needSearch:(UIButton *)sender {
    if (sender.tag == 1) {
        //显示搜索
        self.searchBar.hidden = NO;
        arrIndex = 0;
        sender.tag = 2;
        [UIView animateWithDuration:0.35 animations:^{
            [self.moneyAutoHeight setConstant:0];
            [self.view layoutIfNeeded];
        }];
        
    }
    else{
        //隐藏搜索显示内容
        self.searchBar.hidden = YES;
        sender.tag = 1;
        [UIView animateWithDuration:0.35 animations:^{
            [self.moneyAutoHeight setConstant:80];
            [self.view layoutIfNeeded];
        }];
        
        for (UIView *view in self.view.subviews) {
            if ([view isKindOfClass:[SAEmptyresultView class]]) {
                [view removeFromSuperview];
            }
        }
        
        //退出搜索，返回旧值
        [self.moenyListArray removeAllObjects];
        [self.moenyListArray addObjectsFromArray: self.moenyListArrayBackup];
        [self.tableview reloadData];
    }
}

#pragma mark -m 分页方法，返回数组
-(NSArray *)pageForArray:(NSArray *)arr{
    NSInteger index = arrIndex;
    arrIndex += 5;
    if (arrIndex <arr.count) {
        for (int i = 0 ; i<5; i++) {
            [searchArr addObject:arr[index +i]];
        }
    }else{
        for (int i = 0; i < arr.count - index; i ++) {
            [searchArr addObject:arr[index]];
        }
    }
    return searchArr;
}

#pragma mark - 退出
- (IBAction)clickToPop:(id)sender {
    if (self.searchBar.text.length >0) {
        //[self.whiteView removeFromSuperview];
        //隐藏搜索栏
        self.searchBar.text = @"";
        self.searchBar.hidden = YES;
        self.clickBtn.tag = 1;
        [UIView animateWithDuration:0.35 animations:^{
            [self.moneyAutoHeight setConstant:80];
            [self.view layoutIfNeeded];
        }];
        //退出搜索，返回旧值
        [self.moenyListArray removeAllObjects];
        [self.moenyListArray addObjectsFromArray: self.moenyListArrayBackup];
        [self.tableview reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 跳转至银行界面

- (IBAction)clicktobank:(id)sender {
    //判断有没有用户银行卡信息
    if ([self.waitPayMoney.text floatValue]==0) {
        [self showAlert:@"没有待结算金额"];
        return;
    }
    [self requestUserData];
}

- (void)showAlert:(NSString *)string{
    [self showAlert:string andView:self.waitPaymoneyView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAnimated:nil];
    });
}

- (void)hideAnimated:(void(^)(BOOL isComplete))complete{
    [UIView animateWithDuration:0.25 animations:^{
        self.tipSView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.tipSView removeFromSuperview];
        if (complete)
            complete(finished);
    }];
}

-(void)showAlert:(NSString *)msg andView:(UIView*)view{
    if (self.tipSView) {
        [self.tipSView removeFromSuperview];
    }
    self.tipSView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBarView.y+self.searchBarView.height, [UIScreen mainScreen].bounds.size.width, 40)];
    [self.tipSView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tipSView.width, self.tipSView.height)];
    [label setText:msg];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:13]];
    [label setTextColor:[UIColor whiteColor]];
    [self.tipSView addSubview:label];
    [self.view addSubview:self.tipSView];
    [UIView animateWithDuration:0.25 animations:^{
        [self.tipSView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    }];
}

#pragma mark - 获取屋主信息-判断用户的银行卡信息
-(void)requestUserData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=[ModelTool find_UserData].key;

    [WebAPI getBOInfo:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] ==10000) {
            SAUserdataModel *model = [SAUserdataModel yy_modelWithDictionary:response[@"data"]];
            if (model.bo.boBank.count>0) {
                //有银行卡
                NSArray *array = model.bo.boBank;
                SAUserbobankModel *bankModel = [SAUserbobankModel yy_modelWithDictionary:array[0]];
                
                if ([bankModel.bankStatus isEqualToString:@"1"]) {
                    
                    SATakeoutMoneyVC *vc = [[UIStoryboard storyboardWithName:@"moneyget" bundle:nil] instantiateViewControllerWithIdentifier:@"SATakeoutMoneyVC"];
                    vc.money=self.waitPayMoney.text;
                    vc.bobankNum=bankModel.bankNum;
                    vc.bobankName=bankModel.bankName;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    self.alertController = [UIAlertController alertControllerWithTitle:@"您的银行卡还没有通过审核" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [self showAlertController];
                }
            }else{
                //没有银行卡
                self.alertController = [UIAlertController alertControllerWithTitle:@"前去绑定您的银行卡" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [self showAlertController];
            }
        }else{
            NSString *string =[response objectForKey:@"rmsg"];
            if (string.length>0) {
                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            }else{
                [Alert showFail:@"请求数据超时，请稍后再试" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
            }
        }
    }];
}

- (void)showAlertController{
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        MasterMyBankController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMyBank"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.alertController addAction:cancelAction];
    [self.alertController addAction:confirmAction];
    
    [self presentViewController:self.alertController animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)moenyListArray{
    if (_moenyListArray == nil) {
        _moenyListArray = [NSMutableArray array];
    }
    return _moenyListArray;
}

- (NSMutableArray *)moenyListArrayBackup{
    if (_moenyListArrayBackup == nil) {
        _moenyListArrayBackup = [NSMutableArray array];
    }
    return _moenyListArrayBackup;
}

- (NSMutableArray *)tempListArray{
    if (_tempListArray == nil) {
        _tempListArray = [NSMutableArray array];
    }
    return _tempListArray;
}

@end


//
//  TDMyDoorCardListViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/5.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDMyDoorCardListViewController.h"
#import "TDMyDoorCardListTableViewCell.h"
#import "TDMyICCardViewController.h"
#import "TDBindingICCardStartViewController.h"
#import "WebAPIForMyDoorCard.h"
@interface TDMyDoorCardListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) NSInteger mobileStatus;
@property (assign, nonatomic) NSInteger ICCardStatus;
@property (assign, nonatomic) NSInteger IDCardStatus;
@property (strong, nonatomic) NSDictionary *doorCardStateInfo;
@end

@implementation TDMyDoorCardListViewController

- (void)touchUpInside:(UIButton *)button {
    switch ([button tag]) {
        case 0:
        {
            if (_ICCardStatus == 4) {// 挂失
                if (_mobileStatus == 1) {
                    TDBindingICCardStartViewController *controller = [[TDBindingICCardStartViewController alloc] init];
                    controller.houseID = _houseID;
                    [self.navigationController pushViewController:controller animated:YES];
                }else {
                    [self.view showHUDWithText:@"请先联系屋主开通手机开门功能" delay:3];
                }
            }
        }
            break;
        case 1:// 挂失
        {
            if (_ICCardStatus == 1) {// 启用
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否挂失 IC卡？" preferredStyle:UIAlertControllerStyleAlert];
                
                // Create the actions.
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    [self reportLossICCard];
                }];
                
                // Add the actions.
                [alertController addAction:cancelAction];
                [alertController addAction:otherAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }else if (_ICCardStatus == 4) {// 挂失
                [self cancelReportLossICCard];
            }
        }
            break;
        case 2:// 详情
        {
            TDMyICCardViewController *controller = [[TDMyICCardViewController alloc] init];
            controller.houseID = _houseID;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)reportLossICCard {
    if (!_houseID) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":_houseID,
                                 @"version":@"2.0"};
    [self.view showHUD];
    [WebAPIForMyDoorCard reportLossICCard:dictionary callback:^(NSError *err, id response) {
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            [self.view hideHUD];
            
            [self loadDoorCardStateInfo];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)cancelReportLossICCard {
    if (!_houseID) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":_houseID,
                                 @"version":@"2.0"};
    [self.view showHUD];
    [WebAPIForMyDoorCard cancelReportLossICCard:dictionary callback:^(NSError *err, id response) {
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            [self.view hideHUD];
            
            [self loadDoorCardStateInfo];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)loadDoorCardStateInfo {
    if (!_houseID) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":_houseID,
                                 @"version":@"2.0"};
    [self.view showHUD];
    [WebAPIForMyDoorCard loadDoorCardStateInfo:dictionary callback:^(NSError *err, id response) {
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response dictionaryForKey:@"data"];
            NSLog(@"%@",result);
            if ([result count] > 0) {
                _doorCardStateInfo = result;
                _mobileStatus = [_doorCardStateInfo intForKey:@"acMobileStatus"];
                _ICCardStatus = [_doorCardStateInfo intForKey:@"acICCardStatus"];
                _IDCardStatus = [_doorCardStateInfo intForKey:@"acIDCardStatus"];
                [_tableView reloadData];
            }
            [self.view hideHUD];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"我的门卡"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:NSClassFromString(@"TDMyDoorCardListTableViewCell") forCellReuseIdentifier:@"TDMyDoorCardListTableViewCell"];
    
    [self loadDoorCardStateInfo];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_doorCardStateInfo) {
        return 3;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            if (_mobileStatus == 3) {// 禁用
                return 70;
            }
        }
            break;
        case 1:
        {
            if (_ICCardStatus == 1) {// 启用
                return 85;
            }
            if (_ICCardStatus == 3) {// 禁用
                return 105;
            }
            if (_ICCardStatus == 4) {// 挂失
                return 85;
            }
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        default:
            break;
    }
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"TDMyDoorCardListTableViewCell";
    TDMyDoorCardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TDMyDoorCardListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.reopeningButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.reportTheLossButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailsButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
        {
            cell.cardType = DoorCardTypeMobile;
            cell.status = _mobileStatus;
            if (_mobileStatus == 3) {
                if ([_doorCardStateInfo intForKey:@"acMobileCloseDueTime"] == -1) {
                    cell.prompt = @"永久关闭";
                }
                if ([_doorCardStateInfo intForKey:@"acMobileCloseDueTime"] > 0) {
                    cell.prompt = [NSString stringWithFormat:@"预计 %@ 恢复", [_doorCardStateInfo dateForKey:@"acMobileCloseDueTime"]];
                }
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        case 1:
        {
            cell.cardType = DoorCardTypeICCard;
            cell.status = _ICCardStatus;
            if (_ICCardStatus == 3) {
                if ([_doorCardStateInfo intForKey:@"acICCardCloseDueTime"] == -1) {
                    cell.prompt = @"永久关闭";
                }
                if ([_doorCardStateInfo intForKey:@"acICCardCloseDueTime"] > 0) {
                    cell.prompt = [NSString stringWithFormat:@"预计 %@ 恢复", [_doorCardStateInfo dateForKey:@"acICCardCloseDueTime"]];
                }
            }
            if (_ICCardStatus == 2 && _mobileStatus != 2) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case 2:
        {
            cell.cardType = DoorCardTypeIDCard;
            //cell.status = [_doorCardStateInfo intForKey:@"acIDCardStatus"];
            cell.status = 5;
            //cell.prompt = [_doorCardStateInfo stringForKey:@"acIDCardCloseDueTime"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        if (_ICCardStatus == 2) {
            if (_mobileStatus == 1) {
                TDBindingICCardStartViewController *controller = [[TDBindingICCardStartViewController alloc] init];
                controller.houseID = _houseID;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                [self.view showHUDWithText:@"请先联系屋主开通手机开门功能" delay:3];
            }
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

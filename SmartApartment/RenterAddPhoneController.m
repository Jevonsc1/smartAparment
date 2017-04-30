//
//  RenterAddPhoneController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RenterAddPhoneController.h"
#import "RenterPhoneCell.h"
#import "RenterNameCell.h"
#import "RenterIDCell.h"
#import "UIImageView+WebCache.h"
@interface RenterAddPhoneController ()<UITextFieldDelegate>

@end

@implementation RenterAddPhoneController
{
    NSInteger oneSelectRow;

    NSString *renterPhone;
    NSString *renterName;
    NSDictionary *renterMsg;
    NSInteger renterStatus;
    NSString *memberID;
    BOOL hadSearch;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    oneSelectRow = 2;
    renterName = self.renter.renterTrueName;
    hadSearch = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return oneSelectRow;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0) {
            RenterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterPhoneCell"];
            cell.renterPhone.text = renterPhone;
            cell.renterPhone.tag = 1;
            [cell.searchBtn addTarget:self action:@selector(searchRenterForPhone) forControlEvents:UIControlEventTouchUpInside];
            cell.renterPhone.delegate = self;
            return cell;
        }else if(indexPath.row == 1){
            if (oneSelectRow == 2) {
                RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
                cell.renterName.text = renterName;
                cell.renterName.tag = 2;
                cell.renterName.delegate = self;
                return cell;
            }else{
                RenterIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterIDCell"];
                if (renterStatus == 1) {
                    [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:[renterMsg objectForKey:@"memberAvatar"]] placeholderImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"had_id_icon"]];
                    cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    cell.renterID.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterIDCardNum"];
                }else if(renterStatus == 2){
                    cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"no_id_icon"]];
                    cell.renterID.text = @"该用户还未认证";
                }else{
                   
                    
                }
                return cell;
            }
        }else{
            RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
            cell.renterName.text = renterName;
            cell.renterName.tag = 2;
            cell.renterName.delegate = self;
            return cell;
        }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return cellHeight;
    }else if(indexPath.row == 1){
        if (oneSelectRow == 2) {
            return cellHeight;
        }else{
            return 110*ratio;
        }
    }else{
        return cellHeight;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        renterPhone = textField.text;
    }
}

-(void)searchRenterForPhone{
    [self.view endEditing:YES];
    if (renterPhone.length != 11) {
        [Alert showFail:@"请填写正确的手机号!" View:self.navigationController.navigationBar andTime:1 complete:nil];
        return;
    }
    hadSearch = YES;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterPhone,@"userPhone", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getMemberInfoByPhone:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *renterDic = [response objectForKey:@"data"];
            if (renterDic.count >0) {
                memberID = [renterDic[0] objectForKey:@"memberID" ];
                NSDictionary *userDic = [renterDic[0] objectForKey:@"renter"];
                
                if (userDic.count <=0) {
                    renterStatus = 0;
                    [Alert showFail:@"该用户不是租客！" View:self.navigationController.navigationBar andTime:2 complete:nil];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return ;
                }
                NSString *userStatus = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterStatus"];
                renterMsg  = renterDic[0];
                renterName = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                if (userStatus.integerValue == 30) {
                    renterStatus = 1;
                }else{
                    renterStatus = 2;
                }
                oneSelectRow = 3;
            }else{
                renterStatus = 3;
                oneSelectRow = 2;
                [Alert showFail:@"没找到该手机号码的用户!" View:self.navigationController.navigationBar andTime:1 complete:nil];
            }
            
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];

}
-(void)addPhoneForRenter{
    
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}
- (IBAction)editPhoneForRenter:(id)sender {
    if (hadSearch) {
        //有租客信息
        if (renterStatus == 3) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.rent.rentRecordID,@"rentRecordID",renterName,@"memberName",renterPhone,@"memberPhone", nil];
            [WebAPI editVirtualMainRenter:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [Alert showFail:@"修改成功!" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    RequestBad
                }
            }];
        }else if(renterStatus == 0 ){
            [Alert showFail:@"无法修改该用户的手机号码!" View:self.navigationController.navigationBar andTime:2 complete:nil];
            return;
        }else{
            //用新的接口，替换
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.rent.rentRecordID,@"rentRecordID",memberID,@"memberID", nil];
            [WebAPI replaceVirtualMainRenter:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [Alert showFail:@"修改成功!" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else{
                    RequestBad
                }
            }];
        }
    }else{
        [self.view endEditing:YES];
        if (renterPhone.length != 11) {
            [Alert showFail:@"请填写正确的手机号!" View:self.navigationController.navigationBar andTime:1 complete:nil];
            return;
        }
        hadSearch = YES;
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterPhone,@"userPhone", nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [WebAPI getMemberInfoByPhone:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                NSArray *renterDic = [response objectForKey:@"data"];
                if (renterDic.count >0) {
                    memberID = [renterDic[0] objectForKey:@"memberID" ];
                    NSDictionary *userDic = [renterDic[0] objectForKey:@"renter"];
                    
                    if (userDic.count <=0) {
                        renterStatus = 0;
                        [Alert showFail:@"该用户不是租客！" View:self.navigationController.navigationBar andTime:2 complete:nil];
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        return ;
                    }
                    NSString *userStatus = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterStatus"];
                    renterMsg  = renterDic[0];
                    renterName = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    if (userStatus.integerValue == 30) {
                        renterStatus = 1;
                    }else{
                        renterStatus = 2;
                    }
                    oneSelectRow = 3;
                }else{
                    renterStatus = 3;
                    oneSelectRow = 2;
//                    [Alert showFail:@"没找到该手机号码的用户!" View:self.navigationController.navigationBar andTime:1 complete:nil];
                }
                if (renterStatus == 3) {
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.rent.rentRecordID,@"rentRecordID",renterName,@"memberName",renterPhone,@"memberPhone", nil];
                    [WebAPI editVirtualMainRenter:dic callback:^(NSError *err, id response) {
                        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                            [Alert showFail:@"修改成功!" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }else{
                            RequestBad
                        }
                    }];
                }else if(renterStatus == 0 ){
                    [Alert showFail:@"无法修改该用户的手机号码!" View:self.navigationController.navigationBar andTime:2 complete:nil];
                    return;
                }else{
                    //用新的接口，替换
                    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.rent.rentRecordID,@"rentRecordID",memberID,@"memberID", nil];
                    [WebAPI replaceVirtualMainRenter:dic callback:^(NSError *err, id response) {
                        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                            [Alert showFail:@"修改成功!" View:self.navigationController.navigationBar andTime:1 complete:^(BOOL isComplete) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                        }else{
                            RequestBad
                        }
                    }];
                }
            }else{
                RequestBad
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        }];
    }
}
@end

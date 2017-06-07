//
//  SelectIDMsgController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/23.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SelectIDMsgController.h"

@interface SelectIDMsgController ()

@end

@implementation SelectIDMsgController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"实名认证"];
}

- (IBAction)clickToMasterID:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n确认认证为屋主身份？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"1",@"memberRoleID",@"2.0",@"version", nil];
        [WebAPI setMemberRole:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                
               [MBProgressHUD showMessage:@"选择角色成功"];
                UserData *data = [ModelTool find_UserData];
                data.memberType = @"master";
                data.idStatus = @"未认证";
                data.boStatus  = 0;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                
            }else
            {
                if (!err) {
                    RequestBad
                }
                
                else{
                    
                    [Alert showFail:@"网络异常，请检查网络!" View:self.view andY:60 andTime:1 complete:nil];
                    
                }
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}
- (IBAction)clickToRenterID:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n确认认证为租客身份？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",@"2",@"memberRoleID",@"2.0",@"version", nil];
        [WebAPI setMemberRole:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                [MBProgressHUD showMessage:@"选择角色成功"];
                    UserData *data = [ModelTool find_UserData];
                    data.memberType = @"renter";
                    data.idStatus = @"未认证";
                    data.renterStatus = @"0";
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else
            {
                RequestBad
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:cancel];
    [ac addAction:ok];
    [self presentViewController:ac animated:YES completion:nil];
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end

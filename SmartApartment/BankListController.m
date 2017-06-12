//
//  BankListController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BankListController.h"
#import "BankCell.h"

@interface BankListController ()
@property(nonatomic,strong)NSMutableArray* bankList;
@end

@implementation BankListController
{
    //记录点击的按钮
    NSMutableArray *selectArr;
}

-(NSMutableArray *)bankList{
    if (!_bankList) {
        _bankList = [NSMutableArray array];
    }
    return _bankList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showProgress];
    selectArr = [NSMutableArray arrayWithCapacity:0];
    [WebAPI getBankList:nil callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
           self.bankList = [response objectForKey:@"data"];
            for (int i = 0; i< self.bankList.count; i++) {

                [selectArr addObject:@"2"];
            }
            [self.tableView reloadData];
        }
        else{
           RequestBad
            
        }
        [MBProgressHUD hideHUD];
    }];
    

}



#pragma mark - Table view data source
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.bankList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankCell" forIndexPath:indexPath];
    NSDictionary *dic = self.bankList[indexPath.row];
    if ([selectArr[indexPath.row] isEqualToString:@"1"]) {
         [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    }else{
         [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"isNotRight_icon"] forState:UIControlStateNormal];
    }
    [cell.bankName setText:[dic objectForKey:@"bank_name"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BankCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell.selectBtn setBackgroundImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:cell.bankName.text forKey:@"bankName"];
    for (int i = 0; i <selectArr.count; i++) {
        selectArr[i] = @"2";
    }
    if ([selectArr[indexPath.row] isEqualToString:@"2"]) {
        selectArr[indexPath.row] = @"1";
    }else{
        selectArr[indexPath.row] = @"2";
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    [self.tableView reloadData];
}


@end

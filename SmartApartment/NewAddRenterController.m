//
//  NewAddRenterController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "NewAddRenterController.h"
#import "RenterNameCell.h"
#import "RenterPhoneCell.h"
#import "AlertCell.h"
#import "RenterIDCell.h"
#import "UIImageView+WebCache.h"
#import "AddRenterResultController.h"
#import "IDCardCell.h"
//#import "AuthtionFirstController.h"
#import "CheckIDCardController.h"
#import "MyDelegateDic.h"
@interface NewAddRenterController ()<UITextFieldDelegate,MyDelegateDic>

@end

@implementation NewAddRenterController
{
    NSInteger oneSectionRows;
    UITapGestureRecognizer *phoneTap;
    NSString *renterPhone;
    NSString *renterName;
    NSInteger renterStatus;
    NSDictionary *renterMsg;
    NSDictionary *houseDic;
    NSDictionary *rentDic;
    
    //身份证正面和背面
    UIImage *frontIDImage;
    UIImage *backIDImage;
    NSString *frontID;
    NSString *backID;
    //是否允许修改身份证
    BOOL isAllowEditIDImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    oneSectionRows = 5;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.house.houseID,@"houseID",@"1",@"availableRentRecord", nil];
    [WebAPI getHouseInfo:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            houseDic = [response objectForKey:@"data"];
            NSArray *rentArr = [houseDic objectForKey:@"rentInfo"];
            if (rentArr.count >0) {
                rentDic = rentArr[0];
            }
        }else{
            RequestBad
        }
        
    }];
   
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden =NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (oneSectionRows == 4) {
        if (indexPath.row !=2) {
            return cellHeight;
        }else{
            return  32.5*ratio;
        }
    }else if (oneSectionRows == 5){
        if (indexPath.row !=2){
            return cellHeight;
        }else{
            return 32.5*ratio;
        }
    }else{
        if (indexPath.row == 3) {
            return 32.5*ratio;
        }else if (indexPath.row == 2){
            return 110*ratio;
        }else{
            return cellHeight;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return oneSectionRows;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
        [cell.cellIcon setImage:[UIImage imageNamed:@"check_house_icon"]];
        cell.cellName.text = @"房间名";
        cell.renterName.userInteractionEnabled = NO;
        cell.renterName.placeholder = [NSString stringWithFormat:@"%@房",self.house.houseNum];
        return cell;
    }else if (indexPath.row == 1){
        if (oneSectionRows == 5 || oneSectionRows == 6) {
            RenterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterPhoneCell"];
            cell.renterPhone.placeholder = @"请输入租客电话号码";
            [cell.searchBtn addTarget:self action:@selector(getMsgByPhone) forControlEvents:UIControlEventTouchUpInside];
            cell.renterPhone.tag = 2;
            cell.renterPhone.delegate = self;
            return cell;
        }else{
            RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
            cell.renterName.tag = 1;
            cell.renterName.delegate = self;
            return cell;
        }
    }else if (indexPath.row == 2){
        if (oneSectionRows == 5 ||oneSectionRows == 4) {
            AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
            if (oneSectionRows == 4) {
                cell.tipLabel.text = @"如有手机号请点击此处";
            }else{
                cell.tipLabel.text = @"如没有手机号请点击此处";
            }
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.tipLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:MainBlue range:NSMakeRange(cell.tipLabel.text.length-4, 4)];
            cell.tipLabel.attributedText = str;
            phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeOneSectionRows)];
            [cell.tipLabel addGestureRecognizer:phoneTap];
            return cell;
        }else{
            RenterIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterIDCell"];
            
            if (renterMsg.count <= 0) {
                cell.renterIDIcon.hidden = YES;
                [cell.renterIcon setImage:[UIImage imageNamed:@"noknow_id_user"]];
                cell.renterName.text =@"未知用户";
                cell.renterID.text = @"签约后请通知用户用手机号及手机验证码登录软件";
            }else{
                if (renterStatus == 1) {
                    [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:[renterMsg objectForKey:@"memberAvatar"]] placeholderImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"had_id_icon"]];
                    cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    cell.renterID.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterIDCardNum"];
                }else if(renterStatus == 2){
                    cell.renterName.text =[[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"no_id_icon"]];
                    cell.renterID.text = @"该用户还未认证";
                }else{
                    cell.renterIDIcon.hidden = YES;
                    [cell.renterIcon setImage:[UIImage imageNamed:@"noknow_id_user"]];
                    cell.renterName.text =[[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    cell.renterID.text = @"签约后请通知用户用手机号及手机验证码登录软件";
                    
                }

            }
            
            return cell;
        }

    }else if(indexPath.row == 3){
        if (oneSectionRows == 6) {
            AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
            if (oneSectionRows == 4) {
                cell.tipLabel.text = @"如有手机号请点击此处";
            }else{
                cell.tipLabel.text = @"如没有手机号请点击此处";
            }
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:cell.tipLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:MainBlue range:NSMakeRange(cell.tipLabel.text.length-4, 4)];
            cell.tipLabel.attributedText = str;
            phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeOneSectionRows)];
            [cell.tipLabel addGestureRecognizer:phoneTap];
            return cell;
        }else if (oneSectionRows == 4){
            IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell"];
            if (frontIDImage!=nil&&backIDImage!=nil) {
                [cell.frontImage setImage:frontIDImage];
                [cell.backImage setImage:backIDImage];
                cell.content.hidden = YES;
                cell.backImage.hidden= NO;
                cell.frontImage.hidden = NO;
            }else{
                cell.frontImage.hidden = YES;
                cell.backImage.hidden = YES;
                cell.content.hidden = NO;
            }
            return cell;
        }
        else{
            RenterNameCell *cell= [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
            cell.renterName.tag = 1;
            cell.renterName.delegate = self;
            return  cell;
        }
    }else if(indexPath.row == 4){
        if (oneSectionRows == 6) {
            RenterNameCell *cell= [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
            if (renterStatus == 1|| renterStatus == 2 ) {
                cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
            }else{
                cell.renterName.placeholder = @"请输入姓名";
                cell.renterName.tag = 1;
                cell.renterName.delegate = self;
            }
            
            
            return  cell;
        }else{
            IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell"];
            if (frontIDImage!=nil&&backIDImage!=nil) {
                [cell.frontImage setImage:frontIDImage];
                [cell.backImage setImage:backIDImage];
                cell.content.hidden = YES;
                cell.backImage.hidden= NO;
                cell.frontImage.hidden = NO;
            }else{
                cell.frontImage.hidden = YES;
                cell.backImage.hidden = YES;
                cell.content.hidden = NO;
            }
            return cell;
        }
    }else{
        IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell"];
        if (frontIDImage!=nil&&backIDImage!=nil) {
            [cell.frontImage setImage:frontIDImage];
            [cell.backImage setImage:backIDImage];
            cell.content.hidden = YES;
            cell.backImage.hidden= NO;
            cell.frontImage.hidden = NO;
        }else{
            cell.frontImage.hidden = YES;
            cell.backImage.hidden = YES;
            cell.content.hidden = NO;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (oneSectionRows == 5) {
        if (indexPath.row == 4&&indexPath.section == 0) {
//            self.navigationController.navigationBar.hidden = YES;
//            AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
//            vc.delegate = self;
//            vc.wayIn = @"SignRoom";
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (oneSectionRows == 4){
        if (indexPath.row == 3 && indexPath.section == 0 ) {
//            self.navigationController.navigationBar.hidden = YES;
//            AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
//            vc.delegate = self;
//            vc.wayIn = @"SignRoom";
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (oneSectionRows == 6){
        if(indexPath.section == 0 && indexPath.row == 5){
            if (renterStatus == 1) {
                //审核中或审核通过--跳转到查看图片页面
                CheckIDCardController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckIDCardController"];
                vc.frontImage = frontIDImage;
                vc.backImage = backIDImage;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                //审核失败或未审核----跳转到重新上传
//                self.navigationController.navigationBar.hidden = YES;
//                AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
//                vc.delegate = self;
//                vc.wayIn = @"SignRoom";
//                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
}
-(void)passValueForSignRoom:(NSDictionary *)value{
    frontIDImage = [value objectForKey:@"front"];
    backIDImage = [value objectForKey:@"back"];
    frontID = [value objectForKey:@"frontID"];
    backID = [value objectForKey:@"backID"];
    [self.tableView reloadData];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        renterName = textField.text;
    }else if (textField.tag == 2){
        renterPhone = textField.text;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        renterName = textField.text;
    }else if (textField.tag == 2){
        renterPhone = textField.text;
    }
}
- (IBAction)clickToPOp:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickToAddRenter:(id)sender {
    NSString *rentRecordID = [rentDic objectForKey:@"rentRecordID"];
    [self.view endEditing:YES];
    NSDictionary *dic ;
    if (renterName.length<= 0 ||renterName == nil  ) {
//        [XHToast showTopWithText:@"请填写租客姓名"];
        [MBProgressHUD showMessage:@"请填写租客姓名"];
        return;
    }
    if (renterName.length >5) {
//        [XHToast showTopWithText:@"租客姓名最多5个汉子字"];
        [MBProgressHUD showMessage:@"租客姓名最多5个汉子字"];
        return;
    }
    
    
       dic= [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterName,@"renterName",rentRecordID,@"rentRecordID",self.house.houseID,@"houseID",@"2",@"renterRoldID",renterPhone,@"renterPhone",backID,@"backIDCardAffixID",frontID,@"frontIDCardAffixID", nil];
        [WebAPI addVirtualRenter:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            AddRenterResultController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRenterResult"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            RequestBad
        }
    }];
}
//修改oneSectionRows
-(void)changeOneSectionRows{
    if (oneSectionRows == 4 ) {
        oneSectionRows = 5;
    }else{
        oneSectionRows = 4;
    }
    [self.tableView reloadData];
}

//获取手机号的信息
-(void)getMsgByPhone{
    [self.view endEditing:YES];
    if (renterPhone.length <11) {
        [Alert showFail:@"手机号码长度错误" View:self.view andTime:1.5 complete:nil];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterPhone,@"userPhone", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getMemberInfoByPhone:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *renterDic = [response objectForKey:@"data"];
            if (renterDic.count >0) {
                NSString *userStatus = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterStatus"];
                renterMsg  = renterDic[0];
                if (userStatus.integerValue == 30 || userStatus.integerValue == 10) {
                    
                    dispatch_group_t group =  dispatch_group_create();
                    
                    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterFrontIDCardImgPath"]]];
                        NSData *resultData = [NSData dataWithContentsOfURL:url];
                        frontIDImage = [UIImage imageWithData:resultData];
                        
                        NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterBackIDCardImgPath"]]];
                        NSData *resultData1 = [NSData dataWithContentsOfURL:url1];
                        backIDImage = [UIImage imageWithData:resultData1];
                        isAllowEditIDImage = NO;
                        
                    });
                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                    renterStatus = 1;
                }else{
                    isAllowEditIDImage = YES;
                    renterStatus = 2;
                }
            }else{
                isAllowEditIDImage = YES;
                renterMsg =nil;
                renterStatus = 3;
            }
            oneSectionRows = 6;
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
}
- (IBAction)clickToPop:(id)sender {
    [PopHome popToController:@"SignRoomOKController" andVC:self];
}

@end

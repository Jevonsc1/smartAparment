//
//  CheckSignRoomController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/28.
//  Copyright © 2016年 Trudian. All rights reserved.
//
#define grayText TDRGB(136,136,136)
#define blackText TDRGB(0,0,0)

#import "CheckSignRoomController.h"
#import "RenterIDCell.h"
#import "RoomOtherCell.h"
#import "UIImageView+WebCache.h"
#import "RenterAddPhoneController.h"
#import "UIView+Extension.h"
#import "IDCardCell.h"
#import "AuthtionFirstController.h"
#import "NewAddRenterController.h"
#import "SelectRentDateController.h"
#import "CheckIDCardController.h"

@interface CheckSignRoomController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *endRentbTN;
@property (weak, nonatomic) IBOutlet UIButton *addRenterBtn;
@property (weak, nonatomic) IBOutlet UINavigationItem *titleItem;

@property(nonatomic,strong)Renter* mainRenter;


@property(nonatomic,strong)Rent* rent;
@end

@implementation CheckSignRoomController
{
//    NSDictionary *houseDic;
//    NSDictionary *rentDic;
    NSInteger renterStatus;//1-已认证，2-未认证，3-未注册
//    NSDictionary *mainRenterDic;
    UITapGestureRecognizer *addPhoneTap;
    
    //身份证正面和背面
    UIImage *frontIDImage;
    UIImage *backIDImage;
    NSString *backIDCardAffixID;
    NSString *frontIDCardAffixID;
    //是否允许修改合约信息
    BOOL isAllowEdit;
    //合约租期
    NSString *rentTime;
    //出账日
    NSString *outPayDay;
    //缴费日期
    NSString *payBillDay;
    //房租
    NSString *rentMoney;
    //押金
    NSString *rentDeposit;
    //初始电表读数
    NSString *startDian;
    //电表单价
    NSString *unitDina;
    //初始水表读数
    NSString *startWater;
    //水表单价
    NSString *unitWater;
    //其他费用
    NSString *otherMoney;
    
    NSString *rentRecordID;
    
    //手机号
    NSString *renterPhone;
    NSString *menberID;
    NSString *renterName;
    
    NSInteger hasPayBill;
    
}
-(void)passValue:(NSString *)value{
    rentTime = value;
    payBillDay = [[value substringFromIndex:8] substringToIndex:2];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.endRentbTN cornerRadius:7 color:TDRGB(153, 153, 153)];
    isAllowEdit = NO;
    [self loadRentData];
    
 // 调整不同尺寸屏幕适配tablefooterview尺寸问题
    CGRect frame = self.tableView.tableFooterView.frame;
    frame.size.height = 100.0/(320.0-215.0)*(SCREEN_WIDTH-215.0);
    self.tableView.tableFooterView.frame = frame;

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO];
  
}

-(void)loadRentData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[ModelTool find_UserData].key,@"key",self.house.houseID,@"houseID",@"1",@"availableRentRecord", nil];
    [WebAPI getHouseInfo:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            House* house =[House yy_modelWithDictionary:[response objectForKey:@"data"]];
            if (house.rentInfo.count >0) {
                Rent* rent = house.rentInfo[0];
                //待解决，字段问题
                self.rent = rent;
                hasPayBill = rent.hasPayBill.integerValue;
                outPayDay = rent.rentRecordGraceDays.stringValue;
                payBillDay = rent.payDateMonth.stringValue;
                rentTime = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",rent.rentTime]],[TimeDate timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",rent.rentDueTime]]];
                rentDeposit = rent.rentDeposit;
                rentMoney =  rent.rentMoney;
                startDian =  rent.iniElectric.stringValue;
                startWater = rent.iniWater.stringValue;
                unitDina = rent.electricUnitPrice;
                unitWater = rent.waterUnitPrice;
                otherMoney = rent.otherChargePrice;
                rentRecordID = rent.rentRecordID.stringValue;
                NSArray *renterArr = rent.renterInfo;
                for (int i = 0; i < renterArr.count; i++) {
                    Renter *renter = renterArr[i];
                    //虚拟租客
                    if ([renter.renterRoleID isEqual:@1]) {
                        self.mainRenter = renter;
                        renterPhone = renter.renterPhone.stringValue;
                        if ([renter.renterIsVirtual isEqual:@1]) {
                            renterStatus = 3;
                        }else{
                            if ([renter.renterRoleID isEqual:@1]) {
                                if ([renter.renterStatus isEqual: @30]||[renter.renterStatus isEqual: @10]) {
                                    
                                    dispatch_group_t group =  dispatch_group_create();
                                    
                                    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        NSURL *url = [NSURL URLWithString:renter.renterIDCardObverseSidePath];
                                        NSData *resultData = [NSData dataWithContentsOfURL:url];
                                        frontIDImage = [UIImage imageWithData:resultData];
                                        
                                        NSURL *url1 = [NSURL URLWithString:renter.renterIDCardReverseSidePath];
                                        NSData *resultData1 = [NSData dataWithContentsOfURL:url1];
                                        backIDImage = [UIImage imageWithData:resultData1];
                                    });
                                    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                                        [self.tableView reloadData];
                                    });
                                    
                                    renterStatus = 1;
                                }else{
                                    renterStatus = 2;
                                }
                                
                                break;
                            }
                        }
                    }
                    
                    
                }
            }
            [self.tableView reloadData];
        }else{
//            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n网络异常，请检查网络!" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [ac dismissViewControllerAnimated:YES completion:nil];
//                [self.navigationController popViewControllerAnimated: YES];
//            }];
//            [ac addAction:ok];
//            [self presentViewController:ac animated:YES completion:nil];
            
                        if (!err) {
                            RequestBad
                        }else{
                            [Alert showFail:@"网络异常，请检查网络!" View:self.navigationController.navigationBar andTime:3 complete:nil];
                        }
        }
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        RenterIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterIDCell"];
        
        if (renterStatus == 1) {
            [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:self.mainRenter.renterMemberAvatar] placeholderImage:[UIImage imageNamed:@"no_id_user"]];
            [cell.renterIDIcon setImage:[UIImage imageNamed:@"had_id_icon"]];
            cell.renterName.text = self.mainRenter.renterTrueName;
             cell.renterID.font = [UIFont systemFontOfSize:14*ratio];
            cell.renterIDNum.font = [UIFont systemFontOfSize:14*ratio];
            cell.renterIDNum.text = [NSString stringWithFormat:@"身份证:%@",self.mainRenter.renterIDCardNum];
                cell.renterID.text = [NSString stringWithFormat:@"电话:%@",self.mainRenter.renterPhone];
            
        }else if(renterStatus == 2){
            cell.renterName.text = self.mainRenter.renterTrueName;
            [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
            [cell.renterIDIcon setImage:[UIImage imageNamed:@"no_id_icon"]];
            cell.renterID.text = @"该用户还未认证";
        }else if(renterStatus == 3){
             NSString *phone = self.mainRenter.renterPhone.stringValue;
             cell.renterID.font = [UIFont systemFontOfSize:14*ratio];
            if (phone.length <= 0 || phone == nil) {
                cell.renterIDIcon.hidden = YES;
                [cell.renterIcon setImage:[UIImage imageNamed:@"noknow_id_user"]];
                cell.renterName.text = self.mainRenter.renterTrueName;
                
                NSString *contentStr = @"如果该用户有手机号,可进行添加绑定\n请点击这里";
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
                [str addAttribute:NSForegroundColorAttributeName value:MainBlue range:NSMakeRange(str.length-5, 5)];
                addPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToAddPhone)];
                [cell.renterID addGestureRecognizer:addPhoneTap];
                cell.renterID.attributedText = str;
                

            }else{
                cell.renterIDIcon.hidden = YES;
                [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
                cell.renterName.text = self.mainRenter.renterTrueName;
                NSString *contentStr = [NSString stringWithFormat:@"电话:%@\n可点击这里进行修改",self.mainRenter.renterPhone];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
                [str addAttribute:NSForegroundColorAttributeName value:MainBlue range:NSMakeRange(str.length-6, 2)];
                addPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickToAddPhone)];
                [cell.renterID addGestureRecognizer:addPhoneTap];
                cell.renterID.attributedText = str;
//                cell.renterID.text =[NSString stringWithFormat:@"电话:%@",[mainRenterDic objectForKey:@"renterPhone"]];
            }
            
        }
        return cell;
        
    }else if(indexPath.section == 0 && indexPath.row == 1)
    {
        IDCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCardCell"];
        if (renterStatus ==1) {
            cell.selectIcon.hidden = YES;
        }else{
            cell.selectIcon.hidden = NO;
        }
        if (frontIDImage!=nil&&backIDImage!=nil) {
            [cell.frontImage setImage:frontIDImage];
            [cell.backImage setImage:backIDImage];
            [cell.backImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
            cell.backImage.contentMode =  UIViewContentModeScaleAspectFill;
            cell.backImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            cell.backImage.clipsToBounds  = YES;
            
            [cell.frontImage setContentScaleFactor:[[UIScreen mainScreen] scale]];
            cell.frontImage.contentMode =  UIViewContentModeScaleAspectFill;
            cell.frontImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            cell.frontImage.clipsToBounds  = YES;
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
    
    else if (indexPath.section == 1 && indexPath.row == 0){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"sign_ok_icon2"]];
        cell.cellName.text = @"签约房间";
        if(self.rent){
            
            cell.cellContent.text = [NSString stringWithFormat:@"%@ %@房",self.community.communityName,self.house.houseNum];
        }
        [cell.iconWidth setConstant:0];
        cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.tag = 3;
        cell.cellContent.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
        cell.cellName.text = @"合约期";
        if (outPayDay.length !=0) {
            cell.cellContent.text = rentTime;
        }else{
            if(self.rent){
            cell.cellContent.text = [NSString stringWithFormat:@"%@至%@",[TimeDate timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",self.rent.rentTime]],[TimeDate timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",self.rent.rentDueTime]]];
            }
        }
        rentTime = cell.cellContent.text;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.tag = 3;
        [cell.iconWidth setConstant:0];
        
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = NO;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon8"]];
        cell.cellName.text = @"房租";
        cell.cellContent.tag = 4;
         cell.cellContent.delegate = self;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if (self.rent) {
            cell.cellContent.text = self.rent.monthRent;
        }
         [cell.iconWidth setConstant:0];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
        rentMoney = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];;
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 3){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon4"]];
        cell.cellName.text = @"押金";
        cell.cellContent.tag = 5;
         cell.cellContent.delegate = self;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if(self.rent){
            cell.cellContent.text = self.rent.rentDeposit;
        }
         [cell.iconWidth setConstant:-1.5];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
        rentDeposit = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 4){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"bill_month_icon"]];
        cell.cellName.text = @"出账日";
        cell.cellContent.tag = 6;
        if (outPayDay.length !=0) {
            cell.cellContent.text =[NSString stringWithFormat:@"%@号",payBillDay];
        }else{
            if (self.rent) {
                cell.cellContent.text = [NSString stringWithFormat:@"%@号",self.rent.payDateMonth];
            }
        }
         [cell.iconWidth setConstant:0];
         cell.cellContent.userInteractionEnabled  = NO;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 5){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon5"]];
        cell.cellName.text = @"缴费日期";
        cell.cellContent.keyboardType = UIKeyboardTypeNumberPad;
        if (self.rent) {
             cell.cellContent.text = [NSString stringWithFormat:@"出账日过后%@天",self.rent.rentRecordGraceDays];
        }
         [cell.iconWidth setConstant:0];
        cell.cellContent.tag = 7;
         cell.cellContent.delegate = self;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
      
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
        return cell;
    }
    //    else if (indexPath.section == 2 && indexPath.row == 0){
    //        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
    //        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
    //        cell.cellName.text = @"管理费";
    //        cell.cellContent.tag = 8;
    //         cell.cellContent.placeholder = @"¥0";
    //        return cell;
    //    }
    //    else if (indexPath.section == 2 && indexPath.row == 1){
    //        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
    //        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
    //        cell.cellName.text = @"卫生费";
    //        cell.cellContent.tag = 9;
    //         cell.cellContent.placeholder = @"¥0";
    //        return cell;
    //    } else if (indexPath.section == 2 && indexPath.row == 2){
    //        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
    //        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
    //        cell.cellName.text = @"楼梯灯费";
    //        cell.cellContent.tag = 10;
    //         cell.cellContent.placeholder = @"¥0";
    //        return cell;
    //    }
    else if (indexPath.section == 2 && indexPath.row == 0){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"init_dian_icon"]];
        cell.cellName.text = @"初始电表读数";
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.tag = 11;
         cell.cellContent.delegate = self;
        if(self.rent){
            cell.cellContent.text = [NSString stringWithFormat:@"%.2f",[self RMBString:self.rent.iniElectric.stringValue].floatValue ];
        }
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
         [cell.iconWidth setConstant:-3];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
           startDian = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 1){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"check_dian_icon"]];
        cell.cellName.text = @"电费单价";
        cell.cellContent.tag = 12;
         cell.cellContent.delegate = self;
         cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if(self.rent){
            cell.cellContent.text = [self RMBString:self.rent.electricUnitPrice];
        }
         [cell.iconWidth setConstant:2];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
         unitDina = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 2){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"init_water_icon"]];
        cell.cellName.text = @"初始水表读数";
        cell.cellContent.tag = 13;
         cell.cellContent.delegate = self;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if (self.rent) {
            cell.cellContent.text = [NSString stringWithFormat:@"%.2f",[self changeFloat:self.rent.iniWater.stringValue].floatValue];
        }
         [cell.iconWidth setConstant:-2];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
         startWater = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 3) {
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"check_water_icon"]];
        cell.cellName.text = @"水费单价";
        cell.cellContent.tag = 14;
         cell.cellContent.delegate = self;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if (self.rent) {
            cell.cellContent.text = [self RMBString:self.rent.waterUnitPrice];
        }
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
         [cell.iconWidth setConstant:-1];
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
         unitWater = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
    else{
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
        cell.cellName.text= @"其他费用";
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        if(self.rent){
            cell.cellContent.text = [self RMBString:self.rent.otherChargePrice];
        }
         [cell.iconWidth setConstant:0];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.tag = 15;
         cell.cellContent.delegate = self;
        if (isAllowEdit) {
            cell.cellContent.textColor = blackText;
            cell.cellContent.userInteractionEnabled = YES;
        }else{
            cell.cellContent.textColor = grayText;
            cell.cellContent.userInteractionEnabled = NO;
        }
        otherMoney = [NSString stringWithFormat:@"%.2f",cell.cellContent.text.floatValue];
        return cell;
    }
}

-(void)clickToAddPhone{
    RenterAddPhoneController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"RenterAddPhone"];
    vc.renter = self.mainRenter;
    vc.rent = self.rent;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 编辑合约信息
 */
- (IBAction)clickToEdit:(id)sender {
    if (hasPayBill==1) {
        [Alert showFail:@"该合同已出账单，无法修改!" View:self.view andTime:1.5 complete:nil];
        return;
    }
    
    if (isAllowEdit) {
        isAllowEdit = NO;
        [self.addRenterBtn setTitle:@"添加租客" forState:UIControlStateNormal];
        self.endRentbTN.hidden = NO;
    }else{
        isAllowEdit = YES;
        [self.addRenterBtn setTitle:@"确认" forState:UIControlStateNormal];
        self.endRentbTN.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if(section == 1){
        return 6;
    }else if (section == 2){
        return 4;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
             return 110* ratio;
        }else{
            return cellHeight;
        }
    }else{
        return cellHeight;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
//定义sectionHeader的样式
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17 , 0, 7 *ratio, 17*ratio)];
    if (section % 3 == 0) {
        smallView.backgroundColor = MainBlue;
    }else if(section %3 == 1){
        smallView.backgroundColor = MainRed;
    }else{
        smallView.backgroundColor = MainGreen;
    }
    
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width/2, 32*ratio)];
    
    label.font = [UIFont systemFontOfSize:14 *ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    if (section == 0) {
        label.text = @"主租客信息";
    }else if (section == 1){
        label.text = @"合约基本信息";
    }else if(section == 2){
        label.text = @"非固定费用及单价";
    }else if (section == 3){
        label.text = @"每月固定费用";
    }else if (section == 4){
        label.text = @"房间家私及价值声明";
    }
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    
    
    
    //添加控件
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}
- (IBAction)clickToAddRenter:(id)sender {
    if (isAllowEdit) {
       
        
             [self SaveEditRent];
        
    }else{
        
        NewAddRenterController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"NewAddRenter"];
        vc.house = self.house;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}


/**
 保存编辑后的租约信息
 */
-(void)SaveEditRent{
    
    NSArray *rentArr = [rentTime componentsSeparatedByString:@"至"];
    if ([rentTime isEqualToString:@"请选择"] ) {
        [Alert showFail:@"请选择合约期！" View:self.navigationController.navigationBar andTime:1 complete:nil];
        return;
    }
    NSString *rentStart = [NSString stringWithFormat:@"%@",[self timeStringTotimeData:rentArr[0]]];
    NSString *rentEnd = [NSString stringWithFormat:@"%@",[self timeStringTotimeData:rentArr[1]]];
    
    //
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",rentStart,@"rentTime",rentEnd,@"rentDueTime",payBillDay,@"payDateMonth",rentMoney,@"monthRent",rentDeposit,@"rentDeposit",startWater,@"initWater",startDian,@"initElectric",unitWater,@"waterUnitPrice",unitDina,@"electricUnitPrice",otherMoney,@"otherChargePrice",outPayDay,@"rentGraceDay",nil];
    NSString *rentRecordData = [self dictionaryToJson:dic];
    NSDictionary *rentDataDic = [[NSDictionary alloc] initWithObjectsAndKeys:rentRecordData,@"rentRecordData",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",rentRecordID,@"rentRecordID",@"2.0",@"version", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI editRentRecord:rentDataDic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            [Alert showFail:@"修改成功！" View:self.navigationController.navigationBar andTime:1.5 complete:^(BOOL isComplete) {
                isAllowEdit = NO;
                [self checkAndEditID];
                [self.addRenterBtn setTitle:@"添加租客" forState:UIControlStateNormal];
                self.endRentbTN.hidden = NO;
               
                [self loadRentData];
                [self.tableView reloadData];
            }];
        }else{
            RequestBad
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}

- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 终止合约的按钮

 */
- (IBAction)clickToEndRent:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n确定终止合同？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.house.houseID,@"houseID",self.rent.rentRecordID,@"rentRecordID", nil];
        [WebAPI finishRentRecord:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                [Alert showFail:@"终止合同成功！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"getApartmentList" object:self.community.communityID];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                RequestBad
            }
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [ac dismissViewControllerAnimated:YES completion:nil];
    }];
    [ac addAction:ok];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
    
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 &&indexPath.row == 1&& isAllowEdit) {
        SelectRentDateController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectRentDate"];
        vc.delegate = self;
        RoomOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        vc.rentTime = cell.cellContent.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 0 &&indexPath.row == 1) {
//        self.navigationController.navigationBar.hidden = YES;
        if (renterStatus == 1) {
            //审核中或审核通过--跳转到查看图片页面
            CheckIDCardController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckIDCardController"];
            vc.frontImage = frontIDImage;
            vc.backImage = backIDImage;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
//            //审核失败或未审核----跳转到重新上传
////            self.navigationController.navigationBar.hidden = YES;
            AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
            vc.delegate = self;
            IDCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (!cell.backImage.hidden &&!cell.frontImage.hidden) {
                vc.frontImage = cell.frontImage.image;
                vc.backImage = cell.backImage.image;
            }
            vc.wayIn = @"SignRoom";
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}
-(void)passValueForSignRoom:(NSDictionary *)value{
    frontIDImage = [value objectForKey:@"front"];
    backIDImage = [value objectForKey:@"back"];
    frontIDCardAffixID = [NSString stringWithFormat:@"%@",[value objectForKey:@"frontID"]];
    frontIDCardAffixID = [NSString stringWithFormat:@"%@",[value objectForKey:@"backID"]];
    [self.tableView reloadData];
}
////输入框开始编辑时候以及结束编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 4||textField.tag == 5||textField.tag == 15) {
        textField.text = [textField.text substringFromIndex:1];
    }else if (textField.tag == 7){
        textField.text = outPayDay;
    }else if (textField.tag == 12){
        textField.text = unitDina;
    }else if (textField.tag == 14){
        textField.text = unitWater;
    }else if (textField.tag == 11){
        textField.text = startDian;
    }else if (textField.tag == 13){
        textField.text = startWater;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 4||textField.tag == 5||textField.tag == 15) {
        if (textField.tag == 4) {
            rentMoney = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"¥%@",rentMoney];
        }else if (textField.tag == 5){
            rentDeposit = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"¥%@",rentDeposit];
        }else if(textField.tag == 15){
            otherMoney = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"¥%@",otherMoney];
        }
        
    }else if (textField.tag == 7){
        if (textField.text.integerValue > 28) {
            outPayDay = @"28";
            
            [Alert showFail:@"缴费日期不能大于账单日过后28天" View:self.navigationController.navigationBar andTime:2 complete:nil];
        }else{
            outPayDay = textField.text;
        }
        textField.text = [NSString stringWithFormat:@"出账日过后%@天",outPayDay];
    }else if (textField.tag == 12){
        unitDina = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
        textField.text = [NSString stringWithFormat:@"每度¥%@",unitDina];
    }else if (textField.tag == 14){
        unitWater = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
        textField.text = [NSString stringWithFormat:@"每吨¥%@",unitWater];
    
    }else if (textField.tag == 11){
        startDian = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
    }else if(textField.tag == 13){
        startWater = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
    }
}

-(NSString *)timeStringTotimeData:(NSString *)time{
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
    
    [df setDateFormat:@"yyyy-MM-dd"];
    
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"] ];
    
    NSDate*date =[[NSDate alloc]init];
    
    date =[df dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(NSString *)changeFloat:(NSString *)stringFloat
{
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    NSUInteger zeroLength = 0;
    long i = length-1;
    for(; i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}


-(void)checkAndEditID{
    //判断租客状态--审核中同已认证--5可以换身份证
    if (renterStatus == 1) {
        //只能查看身份证
        //审核中或审核通过--跳转到查看图片页面

    }else{
        //可以换身份证
//        NSString *renterIsVirtual = [mainRenterDic objectForKey:@"renterIsVirtual"];
        //判断虚拟租客--替换租客接口
        
        if (frontIDImage&&backIDImage) {
            //不是虚拟租客就可以编辑租客
            NSString *menberID1 = self.mainRenter.renterMemberID.stringValue;
            NSDictionary *jsonDic = [[NSDictionary alloc] initWithObjectsAndKeys:backIDCardAffixID,@"backIDCardAffixID",frontIDCardAffixID,@"frontIDCardAffixID", nil];
            NSString *jsonStr = [self dictionaryToJson:jsonDic];
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",menberID1,@"memberID",rentRecordID,@"rentRecordID",@"2.0" ,@"version",jsonStr,@"renterData",nil];
            [WebAPI editRenter:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [Alert showFail:@"添加身份证照片成功!" View:self.view andTime:1.5 complete:nil];
                }else{
                    RequestBad
                }
            }];
        }
    }
}

-(NSString*)RMBString:(NSString*)value{
    NSString *rmb = (NSString *)value;
    if ([rmb hasSuffix:@".00"]) {
        rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    return [NSString stringWithFormat:@"%@元",rmb];
}
@end

//
//  NewSignRoomController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "NewSignRoomController.h"
#import "RenterPhoneCell.h"
#import "AlertCell.h"
#import "RenterNameCell.h"
#import "RenterIDCell.h"
#import "RoomOtherCell.h"
#import "UIImageView+WebCache.h"
#import "SelectRentDateController.h"
#import "SignRoomOKController.h"
#import "IDCardCell.h"
#import "CheckIDCardController.h"
//#import "AuthtionFirstController.h"
#import "MyDelegateDic.h"
@interface NewSignRoomController ()<MyDelegate,UITextFieldDelegate,MyDelegateDic>

@end

@implementation NewSignRoomController
{
    NSInteger oneSectionRows;
    //点击没有手机号码
    UITapGestureRecognizer *phoneTap;
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
    //租客名
    NSString *renterName;
    //租客手机
    NSString *renterPhone;
    //房间ID
    NSString *houseID;
    //查询的租客状态
    NSInteger renterStatus;//1-已认证，2-未认证，3-未注册
    //查询出来的租客信息
    NSDictionary *renterMsg;
    //身份证正面和背面
    UIImage *frontIDImage;
    UIImage *backIDImage;
    NSString *frontID;
    NSString *backID;
    //是否允许修改身份证
    BOOL isAllowEditIDImage;
    //是否输入了合法手机号码
    BOOL isRightPhone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isRightPhone = NO;
    oneSectionRows = 4;
    rentTime = @"请选择";
    outPayDay = @"";
    payBillDay = @"5";
    NSLog(@"%@",self.roomData);
    rentMoney = [self.roomData RMBForKey:@"houseMonthRent"];
    rentDeposit =[self.roomData RMBForKey:@"houseRequestRentDeposit"];
    startDian = [NSString stringWithFormat:@"%@",[self.roomData objectForKey:@"houseInitElectric"]];
    unitDina = [self.roomData RMBForKey:@"houseElectricUnitPrice"];
    startWater = [NSString stringWithFormat:@"%@",[self.roomData objectForKey:@"houseInitWater"]];
    unitWater = [self.roomData RMBForKey:@"houseWaterUnitPrice"];
    otherMoney = [self.roomData RMBForKey:@"houseOtherChargePrice"];
    houseID = [NSString stringWithFormat:@"%@",[self.roomData objectForKey:@"houseID"]];
    self.title = [NSString stringWithFormat:@"%@房",[self.roomData objectForKey:@"houseNum"]];
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return oneSectionRows;
    }else if(section == 1){
        return 5;
    }else if (section == 2){
        return 4;
    }else{
        return 1;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        if (oneSectionRows == 4) {
            if (isRightPhone) {
                return 110*ratio;
            }else{
                 return 32.5 *ratio;
            }
        }else  if(oneSectionRows == 3){
            return 50*ratio;
        }else if(oneSectionRows == 5){
            return 110 *ratio;
        }else{
            return cellHeight;
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 2){
        if (oneSectionRows == 3 || oneSectionRows == 5) {
            if (isRightPhone) {
                return cellHeight;
            }else{
                return 32.5 *ratio;
            }
        }else{
            return cellHeight;
        }
    }
    else{
        return cellHeight;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 &&indexPath.row == 0) {
        SelectRentDateController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectRentDate"];
        vc.delegate = self;
        RoomOtherCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        vc.rentTime = cell.cellContent.text;
        NSLog(@"%@",vc.rentTime);
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (oneSectionRows == 2) {
        if (indexPath.row == 1&&indexPath.section == 0) {
            
        }
    }else if (oneSectionRows == 4){
        if (indexPath.row == 3 && indexPath.section == 0 ) {
            self.navigationController.navigationBar.hidden = YES;
            
           
//            AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
//            vc.delegate = self;
//            IDCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            if (!cell.backImage.hidden &&!cell.frontImage.hidden) {
//                vc.frontImage = cell.frontImage.image;
//                vc.backImage = cell.backImage.image;
//            }
//            vc.wayIn = @"SignRoom";
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (oneSectionRows == 5){
         if(indexPath.section == 0 && indexPath.row == 4){
            if (renterStatus == 1) {
                //审核中或审核通过--跳转到查看图片页面
                CheckIDCardController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckIDCardController"];
                vc.frontImage = frontIDImage;
                vc.backImage = backIDImage;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                //审核失败或未审核----跳转到重新上传
//                self.navigationController.navigationBar.hidden = YES;
//                
//                AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
//                IDCardCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//                if (!cell.backImage.hidden &&!cell.frontImage.hidden) {
//                    vc.frontImage = cell.frontImage.image;
//                    vc.backImage = cell.backImage.image;
//                }
//                vc.delegate = self;
//                vc.wayIn = @"SignRoom";
//                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }
}
-(void)passValue:(NSString *)value{
    rentTime = value;
    outPayDay = [[value substringFromIndex:8] substringToIndex:2];
    [self.tableView reloadData];
}
-(void)passValueForSignRoom:(NSDictionary *)value{
    NSLog(@"%@",value);
    
    frontIDImage = [value objectForKey:@"front"];
    backIDImage = [value objectForKey:@"back"];
    frontID = [NSString stringWithFormat:@"%@",[value objectForKey:@"frontID"]];
    backID = [NSString stringWithFormat:@"%@",[value objectForKey:@"backID"]];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (oneSectionRows == 3) {
            if (isRightPhone) {
                RenterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterPhoneCell"];
                cell.renterPhone.placeholder = @"请输入租客电话号码";
                cell.renterPhone.font = [UIFont systemFontOfSize:16*ratio];
                [cell.searchBtn addTarget:self action:@selector(getMsgByPhone) forControlEvents:UIControlEventTouchUpInside];
                cell.renterPhone.tag = 2;
                cell.renterPhone.delegate = self;
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.renterPhone];
                return cell;
            }else{
                RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
                cell.renterName.placeholder = @"请输入姓名";
                cell.renterName.font = [UIFont systemFontOfSize:16*ratio];
                cell.renterName.tag = 1;
                cell.renterName.delegate = self;
                return cell;
            }
        }else{
            RenterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterPhoneCell"];
            cell.renterPhone.placeholder = @"请输入租客电话号码";
            cell.renterPhone.font = [UIFont systemFontOfSize:16*ratio];
            [cell.searchBtn addTarget:self action:@selector(getMsgByPhone) forControlEvents:UIControlEventTouchUpInside];
            cell.renterPhone.tag = 2;
            cell.renterPhone.delegate = self;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.renterPhone];
            return cell;
        }
    }else if (indexPath.section == 0 && indexPath.row == 1){
        if (oneSectionRows == 5) {
            RenterIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterIDCell"];
            
                if (renterStatus == 1) {
                    [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:[renterMsg objectForKey:@"memberAvatar"]] placeholderImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"had_id_icon"]];
                    cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    cell.renterID.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterIDCardNum"];
                    cell.renterIDIcon.hidden = NO;
                }else if(renterStatus == 2){
                     cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
                    [cell.renterIDIcon setImage:[UIImage imageNamed:@"no_id_icon"]];
                    cell.renterID.text = @"该用户还未认证";
                    cell.renterIDIcon.hidden = NO;
                }else{
                    cell.renterIDIcon.hidden = YES;
                    [cell.renterIcon setImage:[UIImage imageNamed:@"noknow_id_user"]];
                    cell.renterName.text = @"未知用户";
                    cell.renterID.text = @"签约后请通知用户用手机号及手机验证码登录软件";
                }
            
            
            return cell;
        }else{
            if (oneSectionRows==4) {
                if (isRightPhone) {
                    RenterIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterIDCell"];
                    
                    if (renterStatus == 1) {
                        [cell.renterIcon sd_setImageWithURL:[NSURL URLWithString:[renterMsg objectForKey:@"memberAvatar"]] placeholderImage:[UIImage imageNamed:@"no_id_user"]];
                        [cell.renterIDIcon setImage:[UIImage imageNamed:@"had_id_icon"]];
                        cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                        cell.renterID.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterIDCardNum"];
                        cell.renterIDIcon.hidden = NO;
                    }else if(renterStatus == 2){
                        cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                        [cell.renterIcon setImage:[UIImage imageNamed:@"no_id_user"]];
                        [cell.renterIDIcon setImage:[UIImage imageNamed:@"no_id_icon"]];
                        cell.renterID.text = @"该用户还未认证";
                        cell.renterIDIcon.hidden = NO;
                    }else{
                        cell.renterIDIcon.hidden = YES;
                        [cell.renterIcon setImage:[UIImage imageNamed:@"noknow_id_user"]];
                        cell.renterName.text = @"未知用户";
                        cell.renterID.text = @"签约后请通知用户用手机号及手机验证码登录软件";
                    }
                    
                    
                    return cell;
                }else{
                    AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
                    if (oneSectionRows == 3) {
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
                }
            }else{
                if (isRightPhone) {
                    RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
                    cell.renterName.placeholder = @"请输入姓名";
                    cell.renterName.font = [UIFont systemFontOfSize:16*ratio];
                    cell.renterName.tag = 1;
                    cell.renterName.delegate = self;
                    return cell;
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
        }
    }else if(indexPath.section == 0 && indexPath.row == 2) {
        if (oneSectionRows == 5 || oneSectionRows == 3) {
            if (isRightPhone) {
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
            }else{
                AlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertCell"];
                if (oneSectionRows == 3) {
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
            }
        }else{
            RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
            cell.renterName.placeholder = @"请输入姓名";
            cell.renterName.tag = 1;
            cell.renterName.delegate = self;
            return cell;
        }
      
    }else if(indexPath.section == 0 && indexPath.row == 3){
        if (oneSectionRows == 4) {
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
        RenterNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RenterNameCell"];
        cell.renterName.delegate = self;
        cell.renterName.tag =1;
        if (renterStatus == 1|| renterStatus == 2 ) {
             cell.renterName.text = [[renterMsg objectForKey:@"renter"] objectForKey:@"renterTrueName"];
        }else{
             cell.renterName.placeholder = @"请输入姓名";
        }
        return cell;
    }else if (indexPath.section == 0 &&indexPath.row == 4){
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
    else if (indexPath.section == 1 && indexPath.row == 0){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellName.text = @"合约期";
        if ([rentTime isEqualToString:@"请选择"]) {
            cell.cellContent.placeholder = rentTime;
        }else{
            cell.cellContent.text = rentTime;
        }
        [cell.iconWidth setConstant:0];
        cell.cellContent.tag = 3;
        cell.cellContent.userInteractionEnabled = NO;
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon8"]];
        cell.cellName.text = @"房租";
        cell.cellContent.tag = 4;
        cell.cellContent.delegate = self;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text = [NSString stringWithFormat:@"%@",rentMoney];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        [cell.iconWidth setConstant:0];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 2){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon4"]];
        cell.cellName.text = @"押金";
        cell.cellContent.tag = 5;
        cell.cellContent.delegate = self;
         cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text = [NSString stringWithFormat:@"%@",rentDeposit];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        [cell.iconWidth setConstant:-1.5];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 3){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"bill_month_icon"]];
        cell.cellName.text = @"出账日";
        cell.cellContent.tag = 6;
        if (outPayDay) {
            cell.cellContent.placeholder = [NSString stringWithFormat:@"%@号",outPayDay];
        }else{
            cell.cellContent.placeholder = @"";
        }
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.userInteractionEnabled = NO;
        [cell.iconWidth setConstant:0];
        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 4){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon5"]];
        cell.cellName.text = @"缴费日期";
        cell.cellContent.text =[NSString stringWithFormat:@"出账日过后%@天",payBillDay];
        cell.cellContent.tag = 7;
        cell.cellContent.delegate = self;
         cell.cellContent.keyboardType = UIKeyboardTypeNumberPad;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        [cell.iconWidth setConstant:0];
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
       cell.cellContent.tag = 11;
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text = [NSString stringWithFormat:@"%@",startDian];
        cell.cellContent.delegate = self;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        [cell.iconWidth setConstant:-1.5];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 1){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"check_dian_icon"]];
        cell.cellName.text = @"电费单价";
        cell.cellContent.tag = 12;
        cell.cellContent.delegate = self;
         cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text = [NSString stringWithFormat:@"每度%@",unitDina];
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        [cell.iconWidth setConstant:2];
        return cell;
    }
    else if (indexPath.section == 2 && indexPath.row == 2){
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"init_water_icon"]];
        cell.cellName.text = @"初始水表读数";
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text = [NSString stringWithFormat:@"%@",startWater];
        [cell.iconWidth setConstant:-2];
        cell.cellContent.tag = 13;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.delegate = self;
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 3) {
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"check_water_icon"]];
        cell.cellName.text = @"水费单价";
        cell.cellContent.tag = 14;
        cell.cellContent.delegate = self;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        cell.cellContent.text =[NSString stringWithFormat:@"每吨%@",unitWater];
        [cell.iconWidth setConstant:-1];
        return cell;
    }
    else{
        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon7"]];
        cell.cellName.text= @"其他费用";
        cell.cellContent.delegate = self;
        cell.cellContent.text = [NSString stringWithFormat:@"%@",otherMoney];
        cell.cellContent.tag = 15;
         cell.cellContent.font = [UIFont systemFontOfSize:16*ratio];
        cell.cellContent.keyboardType = UIKeyboardTypeDecimalPad;
        [cell.iconWidth setConstant:0];
        return cell;
    }
//    else if (indexPath.section == 4 && indexPath.row == 0){
//        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
//        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
//        cell.cellName.text = @"合约期";
//        return cell;
//    }
//    else if (indexPath.section == 4 && indexPath.row == 1){
//        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
//        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
//        cell.cellName.text = @"合约期";
//        return cell;
//    }
//    else if (indexPath.section == 4 && indexPath.row == 2){
//        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
//        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
//        cell.cellName.text = @"合约期";
//        return cell;
//    }
//    else {
//        RoomOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomOtherCell"];
//        [cell.icon setImage:[UIImage imageNamed:@"room_bill_icon6"]];
//        cell.cellName.text = @"合约期";
//        return cell;
//    }
    
}
////输入框开始编辑时候以及结束编辑
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 4||textField.tag == 5||textField.tag == 15) {
        textField.text = [textField.text substringFromIndex:1];
    }else if (textField.tag == 7){
        textField.text = payBillDay;
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
-(void)textFieldChanged:(NSNotification *)info{
//    UITextField *textField = info.object;
//    if (textField.text.length <=0) {
//        textField.font = [UIFont systemFontOfSize:16*ratio];
//    }else{
//        textField.font = [UIFont boldSystemFontOfSize:24*ratio];
//    }
//    if (textField.text.length == 3||textField.text.length == 8) {
//        NSString *string = textField.text;
//        textField.text = [NSString stringWithFormat:@"%@ ",string];
//    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 2) {
        if (textField.text.length <=0) {
            textField.font = [UIFont systemFontOfSize:16*ratio];
        }else{
            textField.font = [UIFont boldSystemFontOfSize:24*ratio];
        }
        if (string.length == 0)
            return YES;
        
        if (textField.text.length == 3||textField.text.length == 8) {
            NSString *string = textField.text;
            textField.text = [NSString stringWithFormat:@"%@ ",string];
                    return YES;
        }

    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 4||textField.tag == 5||textField.tag == 15) {
        if (textField.tag == 4) {
            rentMoney = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"%@",[self RMBForKey:rentMoney]];
        }else if (textField.tag == 5){
            rentDeposit = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"%@",[self RMBForKey:rentDeposit]];
        }else if(textField.tag == 15){
            otherMoney = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
            textField.text = [NSString stringWithFormat:@"%@",[self RMBForKey:otherMoney]];
        }
        
    }else if (textField.tag == 7){
        if (textField.text.integerValue > 28) {
            payBillDay = @"28";
            
            [Alert showFail:@"缴费日期不能大于账单日过后28天" View:self.navigationController.navigationBar andTime:2 complete:nil];
        }else{
        payBillDay = textField.text;
        }
        textField.text = [NSString stringWithFormat:@"出账日过后%@天",payBillDay];
    }else if (textField.tag == 12){
        unitDina = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
        textField.text = [NSString stringWithFormat:@"每度%@",[self RMBForKey:unitDina]];
    }else if (textField.tag == 14){
        unitWater = [NSString stringWithFormat:@"%.2f",textField.text.floatValue];
        textField.text = [NSString stringWithFormat:@"每吨%@",[self RMBForKey:unitWater]];
    }else if(textField.tag == 1){
        renterName = textField.text;
    }else if(textField.tag == 2){
        renterPhone = textField.text;
        renterPhone = [renterPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textField.text.length <=0) {
            textField.font = [UIFont systemFontOfSize:16*ratio];
        }
        if ([self isMobileNumber:renterPhone]) {
            isRightPhone = YES;
            if (oneSectionRows==5) {
                oneSectionRows = 4;
            }else if (oneSectionRows == 4){
                oneSectionRows = 3;
            }
        }else{
            isRightPhone = NO;
            [Alert showFail:@"请输入合法手机号码！" View:self.navigationController.navigationBar andTime:1.5f complete:nil];
        }
        [self.tableView reloadData];
    }else if (textField.tag == 11){
        startDian = [self suffixForKey:[NSString stringWithFormat:@"%.2f",textField.text.floatValue]];
    }else if(textField.tag == 13){
        startWater = [self suffixForKey:[NSString stringWithFormat:@"%.2f",textField.text.floatValue]];
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
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(17, 0, 7 *ratio, 17*ratio)];
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
        label.text = @"租客信息";
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

//修改oneSectionRows
-(void)changeOneSectionRows{
    if (oneSectionRows == 4 || oneSectionRows == 5) {
        oneSectionRows = 3;
    }else{
        oneSectionRows = 4;
    }
    [self.tableView reloadData];
}
//获取手机号的信息
-(void)getMsgByPhone{
    [self.view endEditing:YES];
    if (renterPhone == nil || renterPhone.length != 11) {
        [Alert showFail:@"请输入正确的手机号码!" View:self.navigationController.navigationBar andTime:2 complete:nil];
        return;
    }
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterPhone,@"userPhone", nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebAPI getMemberInfoByPhone:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSArray *renterDic = [response objectForKey:@"data"];
            if (renterDic.count >0) {
                NSDictionary *userDic = [renterDic[0] objectForKey:@"renter"];
                if (userDic.count <=0) {
                    [Alert showFail:@"该用户不是租客！" View:self.navigationController.navigationBar andTime:2 complete:nil];
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                    return ;
                }
                NSString *userStatus = [[renterDic[0] objectForKey:@"renter"] objectForKey:@"renterStatus"];
                renterMsg  = renterDic[0];
                renterName = [[renterDic[0] objectForKey:@"renter"]
                              objectForKey:@"renterTrueName"];
                
                if (userStatus.integerValue == 30||userStatus.integerValue == 10) {
                    renterStatus = 1;
                    
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
                }else{
                    isAllowEditIDImage = YES;
                    renterStatus = 2;
                }
            }else{
                isAllowEditIDImage = YES;
                renterStatus = 3;
            }
            if (isRightPhone) {
                 oneSectionRows = 4;
            }else{
                 oneSectionRows = 5;
            }
        }else{
            RequestBad
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

///签约
- (IBAction)clickToSignRoom:(id)sender {
    NSLog(@"%@",renterName);
    [self.view endEditing:YES];
    if (!renterName || [renterName stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
//        [XHToast showTopWithText:@"请填写租客姓名!"];
        [MBProgressHUD showMessage:@"请填写租客姓名!"];
        return;
    }
    if (renterName.length >5) {
//        [XHToast showTopWithText:@"租客姓名最多5个汉子字"];
        [MBProgressHUD showMessage:@"租客姓名最多5个汉子字"];
        return;
    }
   
    NSArray *rentArr = [rentTime componentsSeparatedByString:@"至"];
    if ([rentTime isEqualToString:@"请选择"] ) {
        [Alert showFail:@"请选择合约期！" View:self.navigationController.navigationBar andTime:1 complete:nil];
        return;
    }
    NSString *rentStart = [NSString stringWithFormat:@"%@",[self timeStringTotimeData:rentArr[0]]];
    NSString *rentEnd = [NSString stringWithFormat:@"%@",[self timeStringTotimeData:rentArr[1]]];
    NSLog(@"%@",payBillDay);
    NSLog(@"%@",houseID);
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",renterName,@"renterName",@"1",@"renterRoleID",rentStart,@"rentTime",rentEnd,@"rentDueTime",outPayDay,@"payDateMonth",[NSString stringWithFormat:@"%.2f",rentMoney.floatValue],@"monthRent",[NSString stringWithFormat:@"%.2f",rentDeposit.floatValue],@"rentDeposit",[NSString stringWithFormat:@"%.2f",startWater.floatValue],@"initWater",[NSString stringWithFormat:@"%.2f",startDian.floatValue],@"initElectric",[NSString stringWithFormat:@"%.2f",unitWater.floatValue],@"waterUnitPrice",[NSString stringWithFormat:@"%.2f",unitDina.floatValue],@"electricUnitPrice",[NSString stringWithFormat:@"%.2f",otherMoney.floatValue],@"otherChargePrice",houseID,@"houseID",payBillDay,@"rentGraceDay", renterPhone,@"renterPhone",frontID,@"frontIDCardAffixID",backID,@"backIDCardAffixID",nil];
    [WebAPI signVirtualRenter:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            SignRoomOKController *vc = [[UIStoryboard storyboardWithName:@"SignRoom" bundle:nil] instantiateViewControllerWithIdentifier:@"SignRoomOK"];
            vc.roomDic = self.roomData;
            vc.communityName = self.communityName;
            vc.renterDic = renterMsg;
            vc.rentTime = rentTime;
            vc.renterStatus = renterStatus;
            vc.mainRenter = renterName;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
//           RequestBad View:self.navigationController.navigationBar andTime:4 complete:nil];
            RequestBad
        }
    }];
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
- (NSString *)RMBForKey:(NSString *)key {
    
        if ([key isKindOfClass:[NSString class]]) {
            NSString *rmb = (NSString *)key;
            if ([rmb hasSuffix:@".00"]) {
                rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
            }
            return [NSString stringWithFormat:@"%@元",rmb];
        }
        if ([key isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@元",[(NSNumber *)key stringValue]];
        }
    
    return @"0元";
}
- (NSString *)suffixForKey:(NSString *)key {
    
    if ([key isKindOfClass:[NSString class]]) {
        NSString *rmb = (NSString *)key;
        if ([rmb hasSuffix:@".00"]) {
            rmb = [rmb stringByReplacingOccurrencesOfString:@".00" withString:@""];
        }
        return [NSString stringWithFormat:@"%@",rmb];
    }
    if ([key isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",[(NSNumber *)key stringValue]];
    }
    
    return @"0";
}
// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0253-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end

//
//  AccessManagerController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/15.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AccessManagerController.h"
#import "AccessCloseView.h"
#import "AccessBtn.h"
#import "ACCheckIDCardController.h"
//#import "TDBindingICCardStartViewController.h"
@interface AccessManagerController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PhoneContentAutoTop;
@property (weak, nonatomic) IBOutlet UILabel *closePhoneMsg;
@property (weak, nonatomic) IBOutlet UILabel *recoverPhoneTime;
@property (weak, nonatomic) IBOutlet UILabel *openStatus;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

//IC卡的cell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ICContentAutoTop;
@property (weak, nonatomic) IBOutlet UILabel *closeICMsg;
@property (weak, nonatomic) IBOutlet UILabel *recoverICTime;
@property (weak, nonatomic) IBOutlet UIButton *ICCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *ICOpenStatus;
@property (weak, nonatomic) IBOutlet AccessBtn *reOpenBtn;
@property (weak, nonatomic) IBOutlet AccessBtn *missBtn;
@property (weak, nonatomic) IBOutlet AccessBtn *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *missHitLabel;





@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IDCardContentAutoTop;
@property (weak, nonatomic) IBOutlet UILabel *closeIDCardMsg;
@property (weak, nonatomic) IBOutlet UILabel *recoverIDCardTime;
@property (weak, nonatomic) IBOutlet UIButton *IDCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *IDCardStatus;
@property (weak, nonatomic) IBOutlet UILabel *rentTimeLabel;

@property (nonatomic, copy) NSString* memberID;

@end

@implementation AccessManagerController
{
    NSString * canIDOpen;
    NSString * canICOpen;
    NSString * canPhoneOpen;
    //权限
    NSString *acICCardStatus;
    NSString *acIDCardStatus;
    NSString *acMobileStatus;
    //关闭门禁的view
    //ic卡的view
    AccessCloseView *accessCloseView;
    //手机的view
    AccessCloseView *accessPhoneView;
    //身份证的view
    AccessCloseView *accessIDCardView;
    //关闭天数
    //手机关闭天数
    NSString *PhoneDayTime;
    //IC卡关闭天数
    NSString *ICCardDayTime;
    //ID卡关闭天数
    NSString *IDCardDayTime;
    //关闭原因
    //手机关闭原因
    NSString *phoneCloseReason;
    //IC卡关闭原因
     NSString *icCardCloseReason;
    //ID卡关闭原因
    NSString *idCardCloseReason;
    //手机恢复时间
    NSString *acMobileCloseDueTime;
    //IC卡恢复时间
    NSString *acICCardCloseDueTime;
    //身份证恢复时间
    NSString *acIDCardCloseDueTime;
    //ic卡view的6个按钮
    NSArray *ICCardViewSixBtnArr;
    //手机view的6个按钮
    NSArray *PhoneViewSixBtnArr;
    //身份证view的6个按钮
    NSArray *IDCardViewSixBtnArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
    [self getRenterACOptStatusInfo];
    self.rentTimeLabel.text = [TimeDate timeWithTimeIntervalString:self.renter.rentRecordDueTime.stringValue];
    
    idCardCloseReason = @"";
    icCardCloseReason = @"";
    phoneCloseReason = @"";
   
}
-(void)viewDidAppear:(BOOL)animated{
    [self initAccessCloseView];
    [self initAccessPhoneView];
    [self initAccessIDCardView];
}
-(void)getRenterACOptStatusInfo{
    NSDictionary* dic = @{ @"key" : [ModelTool find_UserData].key,
                           @"targetMemberID":_renter.renterMemberID,
                           @"version":@"2.0",
                           @"houseID":_renter.houseID};
    [WebAPIForMyDoorCard getRenterACOptStatusInfo:dic callback:^(NSError *err, id response) {
        NSLog(@"%@",response);
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *renterData = [response objectForKey:@"data"];

            acICCardStatus = [renterData objectForKey:@"acICCardStatus"];
            acIDCardStatus = [renterData objectForKey:@"acIDCardStatus"];
            acMobileStatus = [renterData objectForKey:@"acMobileStatus"];
            //关闭原因
            phoneCloseReason = [renterData objectForKey:@"acMobileCloseReason"];
            idCardCloseReason = [renterData objectForKey:@"acIDCardCloseReason"];
            icCardCloseReason = [renterData objectForKey:@"acICCardCloseReason"];
//            //恢复时间
            acMobileCloseDueTime = [renterData objectForKey:@"acMobileCloseDueTime"];
            acIDCardCloseDueTime = [renterData objectForKey:@"acIDCardCloseDueTime"];
            acICCardCloseDueTime = [renterData objectForKey:@"acICCardCloseDueTime"];
            //设置UI控件
            self.closePhoneMsg.text = [NSString stringWithFormat:@"原因:%@",phoneCloseReason];
            self.closeICMsg.text = [NSString stringWithFormat:@"原因:%@",icCardCloseReason];
            self.closeIDCardMsg.text =[NSString stringWithFormat:@"原因:%@",idCardCloseReason];
            //恢复时间
            self.recoverPhoneTime.text = [NSString stringWithFormat:@"恢复时间:%@",acMobileCloseDueTime];
            self.recoverICTime.text =[NSString stringWithFormat:@"恢复时间:%@",acICCardCloseDueTime];
            self.recoverIDCardTime.text =  [NSString stringWithFormat:@"恢复时间:%@",acIDCardCloseDueTime];
             [self setThreeCell];
            [self.tableView reloadData];
            
        }else
        {
            RequestBad
        }
    }];
}
/**
 初始化ic卡关闭的view
 */
-(void)initAccessCloseView{
    accessCloseView  = [[NSBundle mainBundle] loadNibNamed:@"AccessXib" owner:self options:nil][1];
    accessCloseView.frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height);
    accessCloseView.hidden = YES;
    accessCloseView.viewTitle.text = @"关闭IC卡开门";
    accessCloseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    accessCloseView.oneDayBtn.tag = 1;
    accessCloseView.threeDayBtn.tag = 1;
    accessCloseView.fiveDayBtn.tag = 1;
    accessCloseView.oneWeekBrn.tag = 1;
    accessCloseView.oneMonthBtn.tag = 1;
    accessCloseView.forevenBtn.tag = 1;
    [accessCloseView.rightAuto setConstant:16*ratio];
    [accessCloseView.leftAuto setConstant:16*ratio];
    ICCardViewSixBtnArr = [NSArray arrayWithObjects:accessCloseView.oneDayBtn,accessCloseView.threeDayBtn,accessCloseView.fiveDayBtn,accessCloseView.oneWeekBrn,accessCloseView.oneMonthBtn,accessCloseView.forevenBtn, nil];
    [accessCloseView.oneDayBtn addTarget:self action:@selector(oneDayClick:) forControlEvents:UIControlEventTouchUpInside];
     [accessCloseView.threeDayBtn addTarget:self action:@selector(threeDayClick:) forControlEvents:UIControlEventTouchUpInside];
     [accessCloseView.fiveDayBtn addTarget:self action:@selector(fiveDayClick:) forControlEvents:UIControlEventTouchUpInside];
     [accessCloseView.oneWeekBrn addTarget:self action:@selector(oneWeekClick:) forControlEvents:UIControlEventTouchUpInside];
     [accessCloseView.oneMonthBtn addTarget:self action:@selector(oneMonthClick:) forControlEvents:UIControlEventTouchUpInside];
     [accessCloseView.forevenBtn addTarget:self action:@selector(forevenClick:) forControlEvents:UIControlEventTouchUpInside];
    accessCloseView.selfDayView.layer.cornerRadius = 4;
    [accessCloseView.cancelBtn addTarget:self action:@selector(cancelToCloseICCard) forControlEvents:UIControlEventTouchUpInside];
    [accessCloseView.sureBtn addTarget:self action:@selector(sureCloseICCard) forControlEvents:UIControlEventTouchUpInside];
    accessCloseView.selfDayTextField.tag =1;
    accessCloseView.selfDayTextField.delegate = self;
    accessCloseView.closeMes.delegate = self;
    accessCloseView.closeMes.tag  = 1;
    [self.view addSubview:accessCloseView];
}

/**
 初始化手机关闭的view
 */
-(void)initAccessPhoneView{
    accessPhoneView  = [[NSBundle mainBundle] loadNibNamed:@"AccessXib" owner:self options:nil][1];
    accessPhoneView.frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height);
    accessPhoneView.hidden = YES;
    accessPhoneView.viewTitle.text = @"关闭手机开门";
    accessPhoneView.oneDayBtn.tag = 2;
    accessPhoneView.threeDayBtn.tag = 2;
    accessPhoneView.fiveDayBtn.tag = 2;
    accessPhoneView.oneWeekBrn.tag = 2;
    accessPhoneView.oneMonthBtn.tag = 2;
    accessPhoneView.forevenBtn.tag = 2;
    [accessPhoneView.rightAuto setConstant:16*ratio];
    [accessPhoneView.leftAuto setConstant:16*ratio];
    PhoneViewSixBtnArr = [NSArray arrayWithObjects:accessPhoneView.oneDayBtn,accessPhoneView.threeDayBtn,accessPhoneView.fiveDayBtn,accessPhoneView.oneWeekBrn,accessPhoneView.oneMonthBtn,accessPhoneView.forevenBtn, nil];
    [accessPhoneView.oneDayBtn addTarget:self action:@selector(oneDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.threeDayBtn addTarget:self action:@selector(threeDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.fiveDayBtn addTarget:self action:@selector(fiveDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.oneWeekBrn addTarget:self action:@selector(oneWeekClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.oneMonthBtn addTarget:self action:@selector(oneMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.forevenBtn addTarget:self action:@selector(forevenClick:) forControlEvents:UIControlEventTouchUpInside];
    accessPhoneView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    accessPhoneView.selfDayView.layer.cornerRadius = 4;
    [accessPhoneView.cancelBtn addTarget:self action:@selector(cancelToClosePhone) forControlEvents:UIControlEventTouchUpInside];
    [accessPhoneView.sureBtn addTarget:self action:@selector(sureClosePhone) forControlEvents:UIControlEventTouchUpInside];
    accessPhoneView.selfDayTextField.tag = 2;
    accessPhoneView.selfDayTextField.delegate = self;
    accessPhoneView.closeMes.tag = 2;
    accessPhoneView.closeMes.delegate = self;
    [self.view addSubview:accessPhoneView];
}


/**
 初始化身份证关闭的view
 */
-(void)initAccessIDCardView{
    accessIDCardView  = [[NSBundle mainBundle] loadNibNamed:@"AccessXib" owner:self options:nil][1];
    accessIDCardView.frame = CGRectMake(0, 0, self.view.width, [UIScreen mainScreen].bounds.size.height);
    accessIDCardView.hidden = YES;
    accessIDCardView.viewTitle.text = @"关闭身份证开门";
    accessIDCardView.oneDayBtn.tag = 3;
    accessIDCardView.threeDayBtn.tag = 3;
    accessIDCardView.fiveDayBtn.tag = 3;
    accessIDCardView.oneWeekBrn.tag = 3;
    accessIDCardView.oneMonthBtn.tag = 3;
    accessIDCardView.forevenBtn.tag = 3;
    [accessIDCardView.rightAuto setConstant:16*ratio];
    [accessIDCardView.leftAuto setConstant:16*ratio];
    IDCardViewSixBtnArr = [NSArray arrayWithObjects:accessIDCardView.oneDayBtn,accessIDCardView.threeDayBtn,accessIDCardView.fiveDayBtn,accessIDCardView.oneWeekBrn,accessIDCardView.oneMonthBtn,accessIDCardView.forevenBtn, nil];
    [accessIDCardView.oneDayBtn addTarget:self action:@selector(oneDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.threeDayBtn addTarget:self action:@selector(threeDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.fiveDayBtn addTarget:self action:@selector(fiveDayClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.oneWeekBrn addTarget:self action:@selector(oneWeekClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.oneMonthBtn addTarget:self action:@selector(oneMonthClick:) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.forevenBtn addTarget:self action:@selector(forevenClick:) forControlEvents:UIControlEventTouchUpInside];
    accessIDCardView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    accessIDCardView.selfDayView.layer.cornerRadius = 4;
    [accessIDCardView.cancelBtn addTarget:self action:@selector(cancelToCloseIDCard) forControlEvents:UIControlEventTouchUpInside];
    [accessIDCardView.sureBtn addTarget:self action:@selector(sureCloseIDCard) forControlEvents:UIControlEventTouchUpInside];
    accessIDCardView.selfDayTextField.tag = 3;
    accessIDCardView.selfDayTextField.delegate = self;
    accessIDCardView.closeMes.tag = 3;
    accessIDCardView.closeMes.delegate = self;
    [self.view addSubview:accessIDCardView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1--IC卡
    if (indexPath.row == 1) {
        
        self.closeICMsg.hidden = YES;
        self.recoverICTime.hidden = YES;
        self.ICOpenStatus.hidden = YES;
        self.ICCardBtn.hidden = NO;
        self.missHitLabel.hidden = YES;
        
        if (acICCardStatus.integerValue == 1) {
                //启用
            [self.ICContentAutoTop setConstant:(cellHeight-21*ratio)/2];
            self.reOpenBtn.enabled = NO;
            self.missBtn.enabled = YES;
            return cellHeight+40;
            
        }else if (acICCardStatus.integerValue == 2) {
                //未启用 
            [self.ICContentAutoTop setConstant:(cellHeight-21*ratio)/2];

            
            self.ICOpenStatus.hidden = NO;
            self.ICCardBtn.hidden = YES;
                
            self.detailBtn.hidden = YES;
            self.missBtn.hidden = YES;
            self.reOpenBtn.hidden = YES;
            return cellHeight;
        }
        else if (acICCardStatus.integerValue == 3) {
                //禁用
            self.reOpenBtn.enabled = NO;
            self.missBtn.enabled = NO;
            self.closeICMsg.hidden = NO;
            self.recoverICTime.hidden = NO;
            return cellHeight+80;
                
        }else if (acICCardStatus.integerValue == 4) {
                //挂失

            self.missBtn.selected = YES;
            self.missHitLabel.hidden = NO;
            self.reOpenBtn.enabled = YES;
            
            return cellHeight+40;
        }
        else{
            self.closeICMsg.hidden = NO;
            self.recoverICTime.hidden = NO;
            [self.ICContentAutoTop setConstant:10];
            return 83*ratio+40;
        }
        
    }else if(indexPath.row == 0){
        if (acMobileStatus.integerValue != 2) {
            self.phoneBtn.hidden = NO;
            self.openStatus.hidden = YES;
            if (acMobileStatus.integerValue == 1) {
                [self.PhoneContentAutoTop setConstant:(cellHeight-21*ratio)/2];
                self.closePhoneMsg.hidden = YES;
                self.recoverPhoneTime.hidden = YES;
                return cellHeight;
            }else{
                self.closePhoneMsg.hidden = NO;
                self.recoverPhoneTime.hidden = NO;
                [self.PhoneContentAutoTop setConstant:10];
                return 83*ratio;
            }
        }else{
            self.closePhoneMsg.hidden = YES;
            self.recoverPhoneTime.hidden = YES;
            self.phoneBtn.hidden = YES;
            self.closePhoneMsg.hidden = NO;
             [self.PhoneContentAutoTop setConstant:(cellHeight-21*ratio)/2];
            return cellHeight;
        }
    }
    else if (indexPath.row == 2){
        if (acIDCardStatus.integerValue != 2) {
            self.IDCardBtn.hidden = NO;
            self.IDCardStatus.hidden = YES;
            if (acIDCardStatus.integerValue == 1) {
                [self.IDCardContentAutoTop setConstant:(cellHeight-21*ratio)/2];
                self.closeIDCardMsg.hidden = YES;
                self.recoverIDCardTime.hidden = YES;
                return cellHeight;
            }else{
                self.closeIDCardMsg.hidden = NO;
                self.recoverIDCardTime.hidden = NO;
                [self.IDCardContentAutoTop setConstant:10];
                return 83*ratio;
            }
        }else{
            self.closeIDCardMsg.hidden = YES;
            self.recoverIDCardTime.hidden = YES;
            self.IDCardStatus.hidden = NO;
            self.IDCardBtn.hidden = YES;
            [self.IDCardContentAutoTop setConstant:(cellHeight-21*ratio)/2];
            return cellHeight;
        }
    }
    else{
        return cellHeight;
    }
}
- (IBAction)ClickReOpen:(AccessBtn *)sender {
    
    if (acICCardStatus.intValue == 4) {
//todo
//        TDBindingICCardStartViewController* vc = [[TDBindingICCardStartViewController alloc]init];
//        vc.navigationController.navigationBar.hidden = YES;
//        vc.houseID = self.houseID;
//        vc.memberID = self.memberID;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)ClickMissBtn:(AccessBtn *)sender {
    if (sender.selected) {
        [self cancelReportLossICCard];
    }else{
        [self reportLossICCard];
    }
    
}

- (void)reportLossICCard {
    if (!self.renter.houseID || !self.renter.renterMemberID) {
        return;
    }
    
    NSDictionary *dictionary = @{@"key":[ModelTool find_UserData].key,
                                 @"houseID":self.renter.houseID,
                                 @"targetMemberID":self.renter.renterMemberID,
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
            self.missBtn.selected = YES;
            [self getRenterACOptStatusInfo];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)cancelReportLossICCard {
    if (!self.renter.houseID || !self.renter.renterMemberID) {
        return;
    }
    
 
    NSDictionary *dictionary = @{@"key":[ModelTool find_UserData].key,
                                 @"houseID":_renter.houseID,
                                 @"targetMemberID":_renter.renterMemberID,
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
            self.missBtn.selected  = NO;
            [self getRenterACOptStatusInfo];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}
- (IBAction)ClickDetail:(AccessBtn *)sender {
    ACCheckIDCardController* cvc = [[ACCheckIDCardController alloc]init];
    cvc.renter = self.renter;
    [self.navigationController pushViewController:cvc animated:YES];
}


//1--IC卡，2--手机，3--身份证
-(void)oneDayClick:(UIButton *)sender{
    [self setTimeBtnStatus:sender];
    if (sender.tag == 1) {
        ICCardDayTime = @"1";
        NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:2 Hour:0 Minute:0 Second:0 andDate:0];
        accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else if(sender.tag == 2){
        PhoneDayTime = @"1";
        NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:2 Hour:0 Minute:0 Second:0 andDate:0];
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = @"1";
        NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:2 Hour:0 Minute:0 Second:0 andDate:0];
        accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
    
}
-(void)threeDayClick:(UIButton *)sender{
    [self setTimeBtnStatus:sender];
      NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:4 Hour:0 Minute:0 Second:0 andDate:0];
    if (sender.tag == 1) {
        ICCardDayTime = @"3";
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else if(sender.tag == 2){
        PhoneDayTime = @"3";
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = @"3";
      
        accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
}
-(void)fiveDayClick:(UIButton *)sender{
     [self setTimeBtnStatus:sender];
      NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:6 Hour:0 Minute:0 Second:0 andDate:0];
    if (sender.tag == 1) {
        ICCardDayTime = @"5";
        accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else if(sender.tag == 2){
        PhoneDayTime = @"5";
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = @"5";
        accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
}
-(void)oneWeekClick:(UIButton *)sender{
     [self setTimeBtnStatus:sender];
     NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:8 Hour:0 Minute:0 Second:0 andDate:0];
    if (sender.tag == 1) {
        ICCardDayTime = @"7";
        accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else if(sender.tag == 2){
        PhoneDayTime = @"7";
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = @"7";
        accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
}
-(void)oneMonthClick:(UIButton *)sender{
     [self setTimeBtnStatus:sender];
     NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:31 Hour:0 Minute:0 Second:0 andDate:0];
    if (sender.tag == 1) {
        ICCardDayTime = @"30";
         accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else if(sender.tag == 2){
        PhoneDayTime = @"30";
         accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = @"30";
         accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
}
-(void)forevenClick:(UIButton *)sender{
     [self setTimeBtnStatus:sender];
    if (sender.tag == 1) {
        ICCardDayTime = @"-1";
         accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"永久"];
    }else if(sender.tag == 2){
        PhoneDayTime = @"-1";
         accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"永久"];
    }else{
        IDCardDayTime = @"-1";
         accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"永久"];
    }
}

/**
 结束编辑自定义天数

 @param textField 自定义天数的输入框
 */
-(void)textFieldDidEndEditing:(UITextField *)textField{
       NSString *time = [self dateStringAfterlocalDateForYear:0 Month:0 Day:textField.text.integerValue+1 Hour:0 Minute:0 Second:0 andDate:0];
    if (textField.tag == 1) {
        ICCardDayTime = textField.text;
        accessCloseView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
        
    }else if (textField.tag == 2){
        PhoneDayTime = textField.text;
        accessPhoneView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }else{
        IDCardDayTime = textField.text;
        accessIDCardView.recoveryLabel.text = [NSString stringWithFormat:@"预计%@自动恢复该权限",time];
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        ICCardDayTime = textField.text;
        for (UIButton *btn in ICCardViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
        }
        
    }else if (textField.tag == 2){
        PhoneDayTime = textField.text;
        for (UIButton *btn in IDCardViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }else{
        IDCardDayTime = textField.text;
        for (UIButton *btn in ICCardViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
        }
    }
    
    [self setSelfDayTimeTextfield:YES andTag:textField.tag];
}

/**
 统一修改输入框样式

 @param selected 是否正在编辑
 @param tag 输入框的tag
 */
-(void)setSelfDayTimeTextfield:(BOOL)selected andTag:(NSInteger)tag{
    if (selected) {
        if (tag == 1) {
            accessCloseView.selfDayView.layer.borderWidth = 1;
            accessCloseView.selfDayView.layer.borderColor = TDRGB(46, 126, 224).CGColor;
            [accessCloseView.selfDayView setBackgroundColor:[UIColor whiteColor]];
            accessCloseView.dayLabel.textColor = TDRGB(46, 126, 224);
        }else if (tag == 2){
            accessPhoneView.selfDayView.layer.borderWidth = 1;
            accessPhoneView.selfDayView.layer.borderColor = TDRGB(46, 126, 224).CGColor;
             [accessPhoneView.selfDayView setBackgroundColor:[UIColor whiteColor]];
            accessPhoneView.dayLabel.textColor = TDRGB(46, 126, 224);
        }else{
            accessIDCardView.selfDayView.layer.borderWidth = 1;
            accessIDCardView.selfDayView.layer.borderColor = TDRGB(46, 126, 224).CGColor;
             [accessIDCardView.selfDayView setBackgroundColor:[UIColor whiteColor]];
            accessIDCardView.dayLabel.textColor = TDRGB(46, 126, 224);
        }
    }else{
        if (tag == 1) {
            accessCloseView.selfDayView.layer.borderWidth = 0;
            accessCloseView.selfDayView.backgroundColor = TDRGB(236, 236, 236);
            accessCloseView.dayLabel.textColor = TDRGB(51, 51, 51);
        }else if (tag == 2){
            accessPhoneView.selfDayView.layer.borderWidth = 0;
            accessPhoneView.selfDayView.backgroundColor = TDRGB(236, 236, 236);
            accessPhoneView.dayLabel.textColor = TDRGB(51, 51, 51);
        }else{
            accessIDCardView.selfDayView.layer.borderWidth = 0;
            accessIDCardView.selfDayView.backgroundColor = TDRGB(236, 236, 236);
            accessIDCardView.dayLabel.textColor = TDRGB(51, 51, 51);
        }
    }
}

/**
 开始编辑关闭的原因

 @param textView 关闭原因的输入框
 */
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            accessCloseView.y = accessCloseView.y - 200;
        }];
    }else if (textView.tag == 2){
        [UIView animateWithDuration:0.25 animations:^{
            accessPhoneView.y = accessPhoneView.y - 200;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            accessIDCardView.y = accessIDCardView.y - 200;
        }];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            accessCloseView.y = accessCloseView.y + 200;
        }];
    }else if (textView.tag == 2){
        [UIView animateWithDuration:0.25 animations:^{
            accessPhoneView.y = accessPhoneView.y + 200;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            accessIDCardView.y = accessIDCardView.y + 200;
        }];
    }
}

/**
 设置6个按钮的状态

 @param sender 传入的按钮
 */
-(void)setTimeBtnStatus:(UIButton *)sender{
    if (sender.tag == 1) {
        for (UIButton *btn in ICCardViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
        }
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        [sender setTitleColor:TDRGB(46, 126, 224) forState:UIControlStateNormal];
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = TDRGB(46, 126, 224).CGColor;
        sender.layer.cornerRadius = 8;
        [self setSelfDayTimeTextfield:NO andTag:1];
       
    }
    else if (sender.tag == 3){
        
        for (UIButton *btn in IDCardViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
        }
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        [sender setTitleColor:TDRGB(46, 126, 224) forState:UIControlStateNormal];
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = TDRGB(46, 126, 224).CGColor;
        sender.layer.cornerRadius = 8;
        [self setSelfDayTimeTextfield:NO andTag:3];
    }else{
        
        for (UIButton *btn in PhoneViewSixBtnArr) {
            [btn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
            btn.layer.borderWidth = 0;
            [btn setTitleColor:TDRGB(51, 51, 51) forState:UIControlStateNormal];
            NSLog(@"%f--%ld",btn.layer.borderWidth,(long)btn.tag);
        }
        [sender setBackgroundImage:nil forState:UIControlStateNormal];
        [sender setTitleColor:TDRGB(46, 126, 224) forState:UIControlStateNormal];
        sender.layer.borderWidth = 1;
        sender.layer.borderColor = TDRGB(46, 126, 224).CGColor;
        sender.layer.cornerRadius = 8;
        [self setSelfDayTimeTextfield:NO andTag:2];
    }
     [self.view endEditing:YES];
}

/**
 点击身份证开门的权限开通按钮
 */
- (IBAction)clickToIDCard:(UIButton *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [sender.imageView.layer addAnimation:transition forKey:@"a"];
    if (sender.tag == 1) {
        [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        sender.tag = 2;
        accessIDCardView.hidden = NO;
        accessCloseView.hidden = YES;
        accessPhoneView.hidden = YES;
    }else{
      
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n开启身份证开门" message:@"\n租客身份证开门功能将恢复正常使用\n是否确定开启?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                                         @"houseID":_renter.houseID,
                                         @"targetMemberID":_renter.renterMemberID,
                                         @"version":@"2.0"};
            [WebAPI openRenterIdentityCardAccess:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                    sender.tag = 1;
                    [self getRenterACOptStatusInfo];
                    [Alert showFail:@"开启成功!" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
                }else{
                    RequestBad;
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                    sender.tag = 2;
                }
            }];
            
        }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            sender.tag = 2;
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}

/**
 点击手机开门的权限开通按钮
 */
- (IBAction)clickToPhone:(UIButton *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [sender.imageView.layer addAnimation:transition forKey:@"a"];
    if (sender.tag == 1) {
        [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        sender.tag = 2;
        accessPhoneView.hidden = NO;
        accessCloseView.hidden = YES;
        accessIDCardView.hidden = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
        sender.tag = 1;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n开启手机开门" message:@"\n租客手机开门功能将恢复正常使用\n是否确定开启?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            

            NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                                         @"houseID":_renter.houseID,
                                         @"targetMemberID":_renter.renterMemberID,
                                         @"version":@"2.0"};
            [WebAPI openRenterMobileAccess:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                    sender.tag = 1;
                    [self getRenterACOptStatusInfo];
                    [Alert showFail:@"开启成功!" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
                }else{
                    RequestBad;
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                    sender.tag = 2;
                }
            }];
        }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            sender.tag = 2;
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}

/**
 点击按钮，改变IC卡开门的状态

 */
- (IBAction)ClickToICCard:(UIButton *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [sender.imageView.layer addAnimation:transition forKey:@"a"];
    if (sender.tag == 1) {
        [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        sender.tag = 2;
        accessCloseView.hidden = NO;
        accessPhoneView.hidden = YES;
        accessIDCardView.hidden = YES;
    }else{
        [sender setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
        sender.tag = 1;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n开启IC卡开门" message:@"\n租客IC卡开门功能将恢复正常使用\n是否确定开启?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
            NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                                         @"houseID":_renter.houseID,
                                         @"targetMemberID":_renter.renterMemberID,
                                         @"version":@"2.0"};
            [WebAPI openRenterICCardAccess:dic callback:^(NSError *err, id response) {
                if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
                    sender.tag = 1;
                    [self getRenterACOptStatusInfo];
                    [Alert showFail:@"开启成功!" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
                }else{
                    RequestBad;
                    [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
                    sender.tag = 2;
                }
            }];
            
            }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [sender setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            sender.tag = 2;
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        
        [self presentViewController:alertController animated:YES completion:^{}];

      
    }
}



- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 取消关闭手机开门的权限
 */
-(void)cancelToClosePhone{
    accessPhoneView.hidden = YES;
    self.phoneBtn.tag = 1;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.phoneBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.phoneBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
}

/**
 确定关闭手机开门
 */
-(void)sureClosePhone{
    self.phoneBtn.tag = 2;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.phoneBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.phoneBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
    phoneCloseReason = accessPhoneView.closeMes.text;
 
    NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                          @"houseID":_renter.houseID,
                          @"targetMemberID":_renter.renterMemberID,
                          @"version":@"2.0",
                          @"closeDayTime":IDCardDayTime,
                          @"closeReason":idCardCloseReason};
    [WebAPI closeRenterMobileAccess:dic callback:^(NSError *err, id response) {
        
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            accessCloseView.hidden = YES;
            [Alert showFail:@"关闭成功！" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
            accessPhoneView.hidden = YES;
            self.phoneBtn.tag = 1;
            [self getRenterACOptStatusInfo];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.phoneBtn.imageView.layer addAnimation:transition forKey:@"a"];
            [self.phoneBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}



/**
 取消关闭身份证开门的权限
 */
-(void)cancelToCloseIDCard{
    accessIDCardView.hidden = YES;
    self.IDCardBtn.tag = 1;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.IDCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.IDCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
}

/**
 确定关闭身份证开门
 */
-(void)sureCloseIDCard{
    self.IDCardBtn.tag = 2;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.IDCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.IDCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
    idCardCloseReason = accessIDCardView.closeMes.text;

    NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                                 @"houseID":_renter.houseID,
                                 @"targetMemberID":_renter.renterMemberID,
                                 @"version":@"2.0",
                                 @"closeDayTime":IDCardDayTime,
                                 @"closeReason":idCardCloseReason};
    [WebAPI closeRenterIdentityCardAccess:dic callback:^(NSError *err, id response) {
        
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            accessCloseView.hidden = YES;
            [Alert showFail:@"关闭成功！" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
            
            accessIDCardView.hidden = YES;
            self.IDCardBtn.tag = 1;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
           [self getRenterACOptStatusInfo];

            [self.IDCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
            [self.IDCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            [self.tableView reloadData];
            
        }else{
            RequestBad
        }
    }];
}


/**
 取消关闭
 */
-(void)cancelToCloseICCard{
    accessCloseView.hidden = YES;
    self.ICCardBtn.tag = 1;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.ICCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.ICCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
}
/**
 关闭IC卡的请求
 */
-(void)sureCloseICCard{
    self.ICCardBtn.tag = 2;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [self.ICCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
    [self.ICCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
    icCardCloseReason = accessCloseView.closeMes.text;
    
    if(icCardCloseReason.length == 0){
        [Alert showFail:@"原因不能为空" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
        return;
    }
    
    NSDictionary *dic = @{@"key":[ModelTool find_UserData].key,
                          @"houseID":_renter.houseID,
                          @"targetMemberID":_renter.renterMemberID,
                          @"version":@"2.0",
                          @"closeDayTime":IDCardDayTime,
                          @"closeReason":idCardCloseReason};
    [WebAPI closeRenterICCardAccess:dic callback:^(NSError *err, id response) {

        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            
            accessCloseView.hidden = YES;
            [Alert showFail:@"关闭成功！" View:self.navigationController.navigationBar andTime:1.5 complete:nil];
            self.ICCardBtn.tag = 1;

            [self getRenterACOptStatusInfo];
            accessCloseView.hidden = YES;
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [self.ICCardBtn.imageView.layer addAnimation:transition forKey:@"a"];
              [self.ICCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
            [self.tableView reloadData];
        }else{
            RequestBad
        }
    }];
}
-(void)setThreeCell{
    //开通了
    if (acMobileStatus.integerValue != 2) {
        self.phoneBtn.hidden = NO;
        self.openStatus.hidden = YES;
        //有权限
        if (acMobileStatus.integerValue == 1) {
            self.phoneBtn.tag = 1;
            [self.phoneBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
        }else{
            self.phoneBtn.tag = 2;
            [self.phoneBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        }
    }else{
        self.phoneBtn.hidden = YES;
        self.openStatus.hidden = NO;
    }
    
    
    if (acICCardStatus.integerValue != 2) {
        self.ICCardBtn.hidden = NO;
        self.ICOpenStatus.hidden = YES;
        //有权限
        if (acICCardStatus.integerValue != 3) {
            self.ICCardBtn.tag = 1;
            [self.ICCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
        }else{
            self.ICCardBtn.tag = 2;
            [self.ICCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        }
    }else{
        self.ICCardBtn.hidden = YES;
        self.ICOpenStatus.hidden = NO;
    }
    
    
    if (acIDCardStatus.integerValue != 2) {
        self.IDCardBtn.hidden = NO;
        self.IDCardStatus.hidden = YES;
        //有权限
        if (acIDCardStatus.integerValue == 1) {
            self.IDCardBtn.tag = 1;
            [self.IDCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14_1"] forState:UIControlStateNormal];
            
        }else{
            self.IDCardBtn.tag = 2;
            [self.IDCardBtn setImage:[UIImage imageNamed:@"room_bill_icon14"] forState:UIControlStateNormal];
        }
    }else{
        self.IDCardBtn.hidden = YES;
        self.IDCardStatus.hidden = NO;
    }
}


- (NSString *)dateStringAfterlocalDateForYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute Second:(NSInteger)second andDate:( NSString *)date
{
    // 当前日期
    NSDate *localDate =[NSDate date]; // 为伦敦时间
    // 在当前日期时间加上 时间：格里高利历
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponent = [[NSDateComponents alloc]init];
    
    [offsetComponent setYear:year ];  // 设置开始时间为当前时间的前x年
    [offsetComponent setMonth:month];
    [offsetComponent setDay:day];
    [offsetComponent setHour:(hour+8)]; // 中国时区为正八区，未处理为本地，所以+8
    [offsetComponent setMinute:minute];
    [offsetComponent setSecond:second];
    
    // 当前时间后若干时间
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponent toDate:localDate options:0];
    
    NSString *dateString = [NSString stringWithFormat:@"%@",minDate];
    dateString = [dateString substringToIndex:10];
    
    
    return dateString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        if (acICCardStatus.intValue == 2) {
//todo
//            TDBindingICCardStartViewController* vc = [[TDBindingICCardStartViewController alloc]init];
//            vc.houseID = self.houseID;
//            vc.memberID = self.memberID;
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end

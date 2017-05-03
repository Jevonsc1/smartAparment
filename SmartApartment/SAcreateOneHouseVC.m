//
//  SAcreateOneHouseVC.m
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/10.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SAcreateOneHouseVC.h"

//#import "SVProgressHUD.h"

//#import "MJExtension.h"

@interface SAcreateOneHouseVC ()
@property (weak, nonatomic) IBOutlet UITextField *roomName;
@property (weak, nonatomic) IBOutlet UITextField *rentMoeny;
@property (weak, nonatomic) IBOutlet UITextField *depositMoeny;
@property (weak, nonatomic) IBOutlet UITextField *powerMoney;
@property (weak, nonatomic) IBOutlet UITextField *waterMoney;
@property (weak, nonatomic) IBOutlet UITextField *otherMoney;
@property (weak, nonatomic) IBOutlet UITextView *otherMoneyDescription;
@property (weak, nonatomic) IBOutlet UIButton *firtBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UILabel *depositPersentLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,copy)NSString *keyString;
@end

@implementation SAcreateOneHouseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyString = [ModelTool find_UserData].key;
    self.saveBtn.layer.cornerRadius=8;
    [self defaultSet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (IBAction)popVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存创建房屋信息
- (IBAction)saveCreatHose:(id)sender {
    
    if (self.roomName.text.length==0) {
        [Alert showFail:@"请填写房号" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.rentMoeny.text.length==0) {
        [Alert showFail:@"请填写租金" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
    
    if (self.depositMoeny.text.length==0) {
        [Alert showFail:@"请填写押金比例" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
        return;
    }
//todo
//    if ([[BBEmojiCheck bbManager] isContainsBBEmoji2:self.otherMoneyDescription.text]) {
//        [Alert showFail:@"费用说明不能有表情" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        return;
//    }
//-------------------------------------------------------------------------------
//    
//    if (self.powerMoney.text.length==0) {
//        [Alert showFail:@"请填写电费" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        return;
//    }
//    
//    if (self.waterMoney.text.length==0) {
//        [Alert showFail:@"请填写水费" View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        return;
//    }
    
   
    
//todo
//    [SVProgressHUD showWithStatus:@""];
//    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"communityID"]=self.communityID;
    params[@"houseData"]=[self pingString];
    params[@"key"]=self.keyString;
    [WebAPIForRenthouse creatRenthouse:params callback:^(NSError *err, id response) {
//todo
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            [SVProgressHUD dismiss];
//            [Alert showFail:[NSString stringWithFormat:@"创建房间%@",responseModel.rmsg] View:self.navigationController.navigationBar andTime:WARNING_TIME complete:^(BOOL isComplete) {
//                
//                [self.navigationController popViewControllerAnimated:YES];
//                
//                
//            }];
//            
//        }else{
//            [SVProgressHUD dismiss];
//            NSString *string =[response objectForKey:@"rmsg"];
//            if (string.length>0) {
//                [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//            }
//        }
    }];
}

#pragma mark -拼接数据
- (NSString*)pingString{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"houseNum"]=self.roomName.text;//房号
    dict[@"monthRent"]=self.rentMoeny.text;//租金
    if (self.firtBtn.selected) {
        dict[@"rentDeposit"]=self.depositMoeny.text;//押金
    }else{
        float deposi =self.depositMoeny.text.floatValue * self.rentMoeny.text.floatValue;
        dict[@"rentDeposit"]=[NSString stringWithFormat:@"%0.f",deposi];//押金
    }
    
    dict[@"houseWaterUnitPrice"]=self.waterMoney.text;//水费
    dict[@"houseElectricUnitPrice"]=self.powerMoney.text;//电费
    dict[@"houseOtherChargePrice"]=self.otherMoney.text;
    dict[@"houseOtherChargeDesc"]=self.otherMoneyDescription.text;
    dict[@"initWater"]=@"";
    dict[@"initElectric"]=@"";
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dict];
    
    NSString *jsonString = [[NSString alloc] initWithData:[self toJSONData:array] encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

- (IBAction)clickGuding:(id)sender {
    //固定押金
    self.secondBtn.selected=NO;
    self.firtBtn.selected=YES;
    [self.firtBtn setImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    [self.secondBtn setImage:[UIImage imageNamed:@"isNotRight_icon"] forState:UIControlStateNormal];
    [self.depositPersentLabel setText:@"元"];
    self.depositMoeny.text =@"";
}

- (void)defaultSet{
    self.secondBtn.selected=NO;
    self.firtBtn.selected=YES;
    [self.depositPersentLabel setText:@"元"];
    self.depositMoeny.text =@"";
}

- (IBAction)clickAnyue:(id)sender {
    //按月押金
    self.secondBtn.selected=YES;
    self.firtBtn.selected=NO;
    [self.secondBtn setImage:[UIImage imageNamed:@"isRight_icon"] forState:UIControlStateNormal];
    [self.firtBtn setImage:[UIImage imageNamed:@"isNotRight_icon"] forState:UIControlStateNormal];
    [self.depositPersentLabel setText:@"个月房租"];
    self.depositMoeny.text =@"";
}


@end

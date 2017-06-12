//
//  MasterPersonController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "MasterPersonController.h"
#import "MasterBankController.h"
#import "MasterContractController.h"
#import "ContractListController.h"
#import "MasterSelfController.h"
#import "MasterMyBankController.h"
#import "SettingListController.h"
//#import "SelectIDMsgController.h"
#import "LoginViewController.h"
#import "IDSureResultController.h"
#import "AuthtionFirstController.h"
//#import "FBBLECentralManager.h"//蓝牙
#import "AuthtionResultController.h"
//#import "MJExtension.h"

#import "AFNetworking.h"

#import "UIButton+WebCache.h"
//#import "IDMsgUploadController.h"

#import "User.h"
#import "BankCard.h"
@interface MasterPersonController ()
//实名信息的图标和label
@property (weak, nonatomic) IBOutlet UILabel *authenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authenIcon;
//银行信息的图标和label
@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet UILabel *backLabel;


@property (weak, nonatomic) IBOutlet UILabel *rusumeMoney;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIButton *bbMasterPicture;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneIconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneIconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoIconWidht;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoIconHeight;

@property (nonatomic,strong)NSNumber* boBankStatus;

@property(nonatomic,strong)User* masterUser;
@end

@implementation MasterPersonController
{
    UserData *userData;
    
    NSString *fixIDString;
    
    NSString *boAuditSuggestion;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    [self.oneIconWidth setConstant:20*ratio];
    [ self.oneIconHeight setConstant:20*ratio];
    [ self.twoIconWidht setConstant:20*ratio];
    [ self.twoIconHeight setConstant:20*ratio];
//    //屋主身份审核通过刷新数据
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMater:) name:@"refreshMaster" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
   
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    userData = [ModelTool find_UserData];
    self.phoneLab.text = userData.memberPhone;

    
     [self getUserBank];
    
    if (userData.boStatus == 30) {
        [self.authenIcon setImage:[UIImage imageNamed:@"right_icon"]];
        self.authenIcon.hidden = NO;
        [self.authenLabel setText:@"已认证"];
     
        self.nickName.text = userData.trueName;
      
        userData.idStatus = @"已认证";
        self.authenLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:206.0/255.0 blue:27.0/255.0 alpha:1];
        
    }else if (userData.boStatus == 10){
     
        userData.idStatus = @"审核中";
        self.nickName.text = userData.memberNickName;
        [self.authenLabel setText:@"审核中"];
        [self.authenIcon setImage:[UIImage imageNamed:@"waitAc"]];
        [self.authenLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]];
    }else if(userData.boStatus == 20){
    
        userData.idStatus = @"被驳回";
        self.nickName.text = userData.memberNickName;
        [self.authenLabel setText:@"被驳回"];
        [self.authenIcon setImage:[UIImage imageNamed:@"noAc"]];
        [self.authenLabel setTextColor:MainRed];
    }else{
        userData.idStatus = @"未认证";
        self.nickName.text = userData.memberNickName;
        [self.authenLabel setText:@"未认证"];
        [self.authenIcon setImage:[UIImage imageNamed:@"noAc"]];
        [self.authenLabel setTextColor:MainRed];
    }
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return SCREEN_WIDTH/375*195;
    }else{
        return  cellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.row == 1) {
        //跳转结算页
        MasterBankController *vc = [[UIStoryboard storyboardWithName:@"moneyget" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterBank"];
        vc.resumeMoney = self.rusumeMoney.text;
        vc.hidesBottomBarWhenPushed = YES;
        if (self.masterUser) {
            vc.masterUser = self.masterUser;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
   
//     if (indexPath.row == 3 )
//    {
//          self.navigationController.navigationBar.hidden = NO;
//          self.tabBarController.tabBar.hidden = YES;
//        ContractListController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"ContractList"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    if (indexPath.row == 3) {
        [self clickTrueName];
    }
    
    if (indexPath.row == 4) {
        [self clickBankCard];
    }
    
     if(indexPath.row ==5){
        SettingListController *vc = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingList"];
         vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 6){
        [self logout];
    }
}


#pragma mark -m 银行卡
-(void)clickBankCard{
    if (userData.boStatus != 30   && [userData.memberType isEqualToString:@"master"]) {
        
        [Alert showFail:@"请先认证身份！" View:self.view andTime:1.5 complete:nil];
        //        [Alert showFail:@"请先认证身份!" View:self.view andY:100 andTime:2 complete:nil];
    }else{
        //银行卡
        if( [userData.memberType isEqualToString:@"master"]){
            if ([self.boBankStatus isEqual:@(0)]) {
                
                IDSureResultController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"IDSureResult"];
                vc.resultType = @"fail";
                vc.bankType = @"fail";
                vc.boAuditSuggestion = boAuditSuggestion;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(!self.boBankStatus){
                MasterMyBankController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMyBank"];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else{
                if ([self.boBankStatus isEqual:@(1)]) {
                    MasterMyBankController *vc = [[UIStoryboard storyboardWithName:@"HomeMaster" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMyBank"];
                    vc.changeBank = @"yes";
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    IDSureResultController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"IDSureResult"];
                    vc.resultType = @"wait";
                    vc.bankType = @"wait";
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
}
#pragma mark -m 实名认证
-(void)clickTrueName{
    if([userData.memberType isEqualToString:@"master"]&& userData.boStatus == 30){
        MasterSelfController *vc = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterSelf"];
        vc.personType = @"master";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if([userData.memberType isEqualToString:@"master"]&& userData.boStatus == 10){

        AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
                 [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        vc.resultType = 3;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ( [userData.memberType isEqualToString:@"master"]&& userData.boStatus == 20)
    {
        AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
                 [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        vc.resultType = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([userData.memberType isEqualToString:@"master"]&&userData.boStatus == 0)
    {
    
        AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
        [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        vc.renterType = @"master";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -m 登出
-(void)logout{
    //待思考：这样一次的保存，感觉没有必要
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确认退出登录!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [AppTool wlClearCachePath:USEFUL_DOOR_NODE_PATH];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userData.key,@"key", nil];
        
        [WebAPI loginOut:dic callback:^(NSError *err, id response) {
        }];
        
        userData.key = @"";
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        NSArray *arr = [UserData MR_findAll];
        for (UserData *data in arr) {
            if (![data.memberPhone isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
                [data MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
        UINavigationController *login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNav"];
        self.tabBarController.selectedIndex = 0;
        [self presentViewController:login animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:cancel];
    [ac addAction:sure];
    [self presentViewController:ac animated:YES completion:nil];

}
#pragma mark -m 刷新屋主数据
-(void)refreshData{
     [self getUserBank];
   
        [self getUserAccredit];
    
    //获取未结算余额
    [self refreshUserData];
}
-(void)refreshMater:(NSNotification *)info{
   
}
#pragma mark -m 刷新屋主信息
-(void)refreshUserData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [WebAPI getBOInfo:dic callback:^(NSError *err, id response) {
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            NSDictionary *rdic = [response objectForKey:@"data"];
            self.rusumeMoney.text = [NSString stringWithFormat:@"¥%@",[rdic objectForKey:@"memberAvailablePD"]];
        }
    }];
}

#pragma mark -m 获取屋主银行卡认证信息
-(void)getUserBank{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [WebAPI getBankCardInfo:dic callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            User* user = [User yy_modelWithJSON:[response objectForKey:@"data"]];
            self.masterUser = user;
             self.rusumeMoney.text = [NSString stringWithFormat:@"¥%@",user.memberAvailablePD];
            boAuditSuggestion = user.bo.boAuditSuggestion;
            NSArray *bankArr = user.bo.boBank;
            
            //BB:头像
            [self bbCirylePicture:self.bbMasterPicture];
            NSString *urlstring = user.memberAvatar;
            [self.bbMasterPicture sd_setBackgroundImageWithURL:[NSURL URLWithString:urlstring] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];

            
            
            if (bankArr.count > 0) {
                BankCard *bankCard = bankArr[0];
                self.boBankStatus = bankCard.bankStatus;
                if ([bankCard.bankStatus isEqual:@(1)]) {
                        self.bankIcon.hidden = NO;
                    [self.bankIcon setImage:[UIImage imageNamed:@"right_icon"]];
                        [self.backLabel setText:@"已认证"];
                        self.backLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:206.0/255.0 blue:27.0/255.0 alpha:1];
                }else if ([bankCard.bankStatus isEqual:@(2)]){
                    [self.backLabel setText:@"审核中"];
                    self.bankIcon.hidden =NO;
                    [self.bankIcon setImage:[UIImage imageNamed:@"waitAc"]];
                    [self.backLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]];
                }
                else{
                    
                    [self.backLabel setText:@"被驳回"];
                    self.bankIcon.hidden =NO;
                       [self.bankIcon setImage:[UIImage imageNamed:@"noAc"]];
                    [self.backLabel setTextColor:MainRed];
                }
  
            }
            else{
              
                [self.backLabel setText:@"未认证"];
                self.bankIcon.hidden =NO;
                   [self.bankIcon setImage:[UIImage imageNamed:@"noAc"]];
                [self.backLabel setTextColor:MainRed];
            }
        }
        
    }];
}
#pragma mark -m 获取屋主认证信息
-(void)getUserAccredit{
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [WebAPI getUserBaseInfo:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
            self.phoneLab.text =[dic objectForKey:@"memberPhone"];
            NSDictionary *boDic = [dic objectForKey:@"bo"];
            self.authenIcon.hidden = NO;
            if (boDic.count >0) {
              
                if ([NSString stringWithFormat:@"%@",[boDic objectForKey:@"boStatus"]].integerValue == 30  ) {
                    [self.authenIcon setImage:[UIImage imageNamed:@"right_icon"]];
                    self.authenIcon.hidden = NO;
                    [self.authenLabel setText:@"已认证"];
                    userData.memberType = @"master";
                    self.nickName.text = [boDic objectForKey:@"boTrueName"];
                    
                    userData.idStatus = @"已认证";
                    self.authenLabel.textColor = [UIColor colorWithRed:111.0/255.0 green:206.0/255.0 blue:27.0/255.0 alpha:1];
                }else if([NSString stringWithFormat:@"%@",[boDic objectForKey:@"boStatus"]].integerValue == 10){
                    userData.memberType = @"notype";
                    userData.idStatus = @"审核中";
                      self.nickName.text = userData.memberNickName;
                    [self.authenLabel setText:@"审核中"];
                    [self.authenIcon setImage:[UIImage imageNamed:@"noAc"]];
                    [self.authenLabel setTextColor:[UIColor lightGrayColor]];
                }else{
                    userData.memberType = @"notype";
                    userData.idStatus = @"被驳回";
                       self.nickName.text = userData.memberNickName;
                    self.nickName.text = [dic objectForKey:@"memberNickName"];
                    [self.authenLabel setText:@"未认证"];
                    [self.authenIcon setImage:[UIImage imageNamed:@"noAc"]];
                    [self.authenLabel setTextColor:[UIColor lightGrayColor]];

                }
            }else{
                userData.memberType = @"notype";
                userData.idStatus = @"未认证";
                   self.nickName.text = userData.memberNickName;
                self.nickName.text = [dic objectForKey:@"memberNickName"];
                [self.authenLabel setText:@"未认证"];
                [self.authenIcon setImage:[UIImage imageNamed:@"noAc"]];
                [self.authenLabel setTextColor:[UIColor lightGrayColor]];
            }
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
        }
    }];
}

#pragma mark -上传用户图片
- (IBAction)bbUploadPicture:(id)sender {
    [self takeBBImage];
    
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [strongSelf uploadBBImage:image];
    };
}

- (void)uploadBBImage:(UIImage *)image{
    [self bbCirylePicture:self.bbMasterPicture];
    [self.bbMasterPicture setBackgroundImage:image forState:UIControlStateNormal];
    
    //上传图片：参数1
    NSString *urlString = nil;
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        urlString = TEST_UPLOAD_API;
    }else {
        urlString = FORMAT_UPLOAD_API;
    }
    
    //上传图片：params参数：filename
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
    //上传图片：params参数：fileType
    NSData *imageData =UIImageJPEGRepresentation(image,0.5);
    NSString *fileType = [self contentTypeForImageData:imageData];
    //上传图片：params参数：imgData
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileName"]=fileName;
    params[@"fileType"]=fileType;
    params[@"imgData"]=imageString;
    params[@"key"]=[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:responseObject];
//        if (responseModel.rcode==10000) {
//            NSLog(@"[responseObject]%@",responseObject);
//            NSNumber *fixId= responseObject[@"data"][@"affix_id"];
//            fixIDString = [NSString stringWithFormat:@"%@",fixId];
//            [self requesteditMemberInfoData:fixIDString];
//        }else{
//            [Alert showFail:responseModel.rmsg View:self.navigationController.navigationBar andTime:2 complete:nil];
//            [SVProgressHUD dismiss];
//        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        
    }];
    //hasPic=true;
}

- (NSString *)contentTypeForImageData:(NSData *)data {
    //返回图片扩展名
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

#pragma mark - 开始上传头像
- (void)requesteditMemberInfoData:(NSString*)string{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=userData.key;
    params[@"memberAvatarAffixs"]=string;
    [WebAPIForRenthouse editMemberInfo:params callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            [MBProgressHUD showMessage:@"上传头像成功!"];
        }else{
            [MBProgressHUD showMessage:@"上传头像失败"];
        }
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            //TODO:
//            [XHToast showTopWithText:@"上传头像成功!"];
//            [self getUserBank];
//        }else{
//            [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        }
    }];
}

- (UIView *)bbCirylePicture:(UIView *)view{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds=YES;
    return view;
}

@end

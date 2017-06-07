//
//  UserPersonController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/29.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "UserPersonController.h"
#import "SettingListController.h"
//#import "MasterSelfController.h"
//#import "SelectIDMsgController.h"
//#import "MyRentRoomController.h"
//#import "IDSureResultController.h"
//#import "FBBLECentralManager.h"
#import "JPUSHService.h"
#import "AFNetworking.h"
//#import "IDMsgUploadController.h"
#import "AuthtionFirstController.h"
//#import "MJExtension.h"
//#import "TDOrderFinishedViewController.h"
#import "AuthtionResultController.h"
#import "UIButton+WebCache.h"

@interface UserPersonController ()
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *cerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cerIcon;
@property (weak, nonatomic) IBOutlet UIButton *bbRenterPicture;

@end

@implementation UserPersonController
{
    UserData *userdata;
    NSString *fixIDString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickToTDOrder) name:@"gotoNetWork" object:nil];
    self.tableView.scrollEnabled = NO;
    
}

//-(void)clickToTDOrder{
//    TDOrderFinishedViewController *controller = [[TDOrderFinishedViewController alloc] init];
//    controller.wayIn = @"network_noti";
//    [self.navigationController pushViewController:controller animated:YES];
//}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    self.cerIcon.height = 20  * ratio;
    self.cerIcon.width = self.cerIcon.height;
    if ([userdata.memberType isEqualToString:@"renter"]) {
         [self requestgetRenterInfoData];
    }

}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
//        [self refreshData];
      userdata = [ModelTool find_UserData];
    self.phone.text = userdata.memberPhone;
    if ([userdata.memberType isEqualToString:@"notype"]) {
        self.nickName.text = userdata.memberNickName;
        [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
        self.cerLabel.text = @"未认证";
        [self.cerLabel setTextColor:[UIColor redColor]];
     

    }else if([userdata.memberType isEqualToString:@"renter"]){
        if (userdata.renterStatus.integerValue== 30) {
            
            self.nickName.text = userdata.trueName;
            [self.cerIcon setImage:[UIImage imageNamed:@"right_icon"]];
            [self.cerLabel setTextColor:[UIColor colorWithRed:111.0/255.0 green:206.0/255.0 blue:27.0/255.0 alpha:1]];
            self.cerLabel.text = @"已认证";
            
        }else if (userdata.renterStatus.integerValue == 10){
            
            self.nickName.text = userdata.memberNickName;
            [self.cerIcon setImage:[UIImage imageNamed:@"waitAc"]];
            self.cerLabel.text = @"审核中";
            [self.cerLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]];
     
            
        }else if (userdata.renterStatus.integerValue == 0){
            
            self.nickName.text = userdata.memberNickName;
            [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
            self.cerLabel.text = @"未认证";
            [self.cerLabel setTextColor:[UIColor redColor]];
            
            
        }
        else{
            
            self.nickName.text = userdata.memberNickName;
            
            [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
            self.cerLabel.text = @"被驳回";
            [self.cerLabel setTextColor:[UIColor redColor]];
        }
    }else{
        if (userdata.boStatus== 30) {
            
            self.nickName.text = userdata.trueName;
            [self.cerIcon setImage:[UIImage imageNamed:@"right_icon"]];
            [self.cerLabel setTextColor:[UIColor colorWithRed:111.0/255.0 green:206.0/255.0 blue:27.0/255.0 alpha:1]];
            self.cerLabel.text = @"已认证";
            
        }else if (userdata.boStatus == 10){
            
            self.nickName.text = userdata.memberNickName;
            [self.cerIcon setImage:[UIImage imageNamed:@"waitAc"]];
            self.cerLabel.text = @"审核中";
            [self.cerLabel setTextColor:[UIColor colorWithRed:46.0/255.0 green:126.0/255.0 blue:224.0/255.0 alpha:1]];
            
            
        }else{
            
            self.nickName.text = userdata.memberNickName;
            
            [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
            self.cerLabel.text = @"被驳回";
            [self.cerLabel setTextColor:[UIColor redColor]];
            
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.view.width/375*195;
    }else{
        return  cellHeight;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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

    return 5;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 2) {
//        MyRentRoomController *myrentRoom = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MyRentRoom"];
//        [self.navigationController pushViewController:myrentRoom animated:YES];
//    }
   if(indexPath.row == 2 && userdata.renterStatus.integerValue == 30){
       self.tabBarController.tabBar.hidden = YES;
//       MasterSelfController *vc = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterSelf"];
//       vc.personType = @"renter";
//       [self.navigationController pushViewController:vc animated:YES];
     
    }else if (indexPath.row == 2 &&  userdata.renterStatus.integerValue == 20){
           self.tabBarController.tabBar.hidden = YES;
        AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
         [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        vc.resultType = 1;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row ==2 && userdata.renterStatus.integerValue == 10){
        AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
         [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.resultType = 3;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row ==2 &&[userdata.memberType isEqualToString:@"notype"]){
//        SelectIDMsgController *vc = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectIDMsg"];
//        [self.navigationController pushViewController:vc animated:YES];

    }
    else if(indexPath.row == 2 && userdata.renterStatus.integerValue == 0)
    {
        AuthtionFirstController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionFirstController"];
        vc.renterType = @"renter";
        vc.hidesBottomBarWhenPushed = YES;
        [[NSUserDefaults standardUserDefaults] setObject:@"您已成功提交资料，请等待审核…" forKey:@"IDMsg"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
     
        SettingListController *vc = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingList"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row ==4){
       
        UINavigationController *login = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginNav"];

        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userdata.key,@"key", nil];
     
    
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确认退出登录!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //FIXME:需要删除用户信息
//            [[FBBLECentralManager shareInsatance]stopCentralManagerService];
            NSString *path =USEFUL_DOOR_NODE_PATH;
            BOOL hasPath = [[NSFileManager defaultManager] fileExistsAtPath:path];
            if (hasPath) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            
            [WebAPI loginOut:dic callback:^(NSError *err, id response) {
            }];
            [JPUSHService setAlias:@"" callbackSelector:nil object:self];
            userdata.key = @"";
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            NSArray *arr = [UserData MR_findAll];
            for (UserData *data in arr) {
                if (![data.memberPhone isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
                    [data MR_deleteEntity];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                }
            }
            self.tabBarController.selectedIndex = 0;
            [self presentViewController:login animated:YES completion:nil];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:cancel];
        [ac addAction:sure];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

#pragma mark -m 刷新租客数据
-(void)refreshData{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userdata.key,@"key", nil];
    [WebAPI getUserBaseInfo:dic callback:^(NSError *err, id response) {
        NSString  *status =[response objectForKey:@"rcode"];
        if (!err && status.integerValue == 10000) {
            NSDictionary *dic = [response objectForKey:@"data"];
                     //认证后保存数据
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
               self.cerLabel.hidden = NO;
            self.phone.text =[dic objectForKey:@"memberPhone"];
            NSDictionary *renterDic = [dic objectForKey:@"renter"];
            if (renterDic.count>0) {
                
                if ( [NSString stringWithFormat:@"%@",[[dic objectForKey:@"renter"] objectForKey:@"renterStatus"]].integerValue == 30 ) {
                    userdata.memberType = @"renter";
                     self.nickName.text = [[dic objectForKey:@"renter"] objectForKey:@"renterTrueName"];
                    [self.cerIcon setImage:[UIImage imageNamed:@"right_icon"]];
                     self.cerLabel.text = @"已认证";
                    userdata.idStatus = @"已认证";
                    
                }else if([NSString stringWithFormat:@"%@",[[dic objectForKey:@"renter"] objectForKey:@"renterStatus"]].integerValue == 10){
                    userdata.memberType = @"notype";
                     self.nickName.text = userdata.memberNickName;
                    [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
                    self.cerLabel.text = @"审核中";
                    [self.cerLabel setTextColor:[UIColor lightGrayColor]];
                    userdata.idStatus = @"审核中";
                    
                }else{
                   userdata.memberType = @"notype";
                    self.nickName.text = userdata.memberNickName;
                    self.nickName.text = [dic objectForKey:@"memberNickName"];
                    [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
                    self.cerLabel.text = @"未认证";
                    [self.cerLabel setTextColor:[UIColor redColor]];
                    userdata.idStatus = @"被驳回";

                }
            }else{
                userdata.memberType = @"notype";
                self.nickName.text = userdata.memberNickName;
                self.nickName.text = [dic objectForKey:@"memberNickName"];
                [self.cerIcon setImage:[UIImage imageNamed:@"noAc"]];
                self.cerLabel.text = @"未认证";
                userdata.idStatus = @"未认证";
                [self.cerLabel setTextColor:[UIColor redColor]];
            }
            
        }
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }];
}

#pragma mark - 上传照片
- (IBAction)bbUploadPicture:(id)sender {
    NSLog(@"上传访客或者租客照片");
    [self takeBBImage];
    
    __weak typeof(self) weakSelf = self;
    self.returnBBImageBlock=^(UIImage *image){
        typeof(weakSelf) __strong strongSelf = weakSelf;
        [strongSelf uploadBBImage:image];
    };
}

- (void)uploadBBImage:(UIImage *)image{
    [self.bbRenterPicture setBackgroundImage:image forState:UIControlStateNormal];
    [self bbCirylePicture:self.bbRenterPicture];
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
//    params[@"key"]=[[BBKeyTool bbManager] bbKey];
    
    
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
    params[@"key"]=userdata.key;
    params[@"memberAvatarAffixs"]=string;
    [WebAPIForRenthouse editMemberInfo:params callback:^(NSError *err, id response) {
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            //TODO:
//            [XHToast showTopWithText:@"上传头像成功!"];
//            [self requestgetRenterInfoData];
//            NSLog(@"上传租客头像成功");
//        }else{
//            [Alert showFail:string View:self.navigationController.navigationBar andTime:WARNING_TIME complete:nil];
//        }
        
    }];
}
#pragma mark -m 登出
-(void)logout{
    //待思考：这样一次的保存，感觉没有必要
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确认退出登录!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [AppTool wlClearCachePath:USEFUL_DOOR_NODE_PATH];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userdata.key,@"key", nil];
        
        [WebAPI loginOut:dic callback:^(NSError *err, id response) {
        }];
        
        userdata.key = @"";
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

#pragma mark- 获取访客信息
- (void)requestgetRenterInfoData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"]=userdata.key;
    [WebAPIForRenthouse getRenterInfo:params callback:^(NSError *err, id response) {
//        SAResponse *responseModel =[SAResponse mj_objectWithKeyValues:response];
//        if (!err && responseModel.rcode==10000) {
//            //TODO:
//            [self bbCirylePicture:self.bbRenterPicture];
//            NSDictionary *dic = response[@"data"];
//            NSString *urlstring = [dic objectForKey:@"memberAvatar"];;
//            [self.bbRenterPicture sd_setBackgroundImageWithURL:[NSURL URLWithString:urlstring] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
//        }else{
//            NSString *string =[response objectForKey:@"rmsg"];
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

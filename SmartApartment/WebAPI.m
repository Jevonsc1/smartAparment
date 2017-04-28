//
//  WebAPI.m
//  CarLife
//
//  Created by kenshinhu on 2/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import "WebAPI.h"
#import "HTTPRequest.h"

@implementation WebAPI

+ (NSString *)urlString:(NSString *)url {
    if ([[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]] hasSuffix:@"_T"]) {
        return [NSString stringWithFormat:@"%@%@",TEST_API,url];
    }else {
        return [NSString stringWithFormat:@"%@%@",FORMAT_API,url];
    }
    
}
//-------------------------宽带订单支付接口-------------------//
+(void)payOrderVersion2:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/order/payOrder"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//----------------------------门禁管理-----------------------//
//获取门禁信息
+(void)getRenterAccess:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/getRenterAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//获取指定租客的开门记录
+(void)getRenterAcLogList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/getRenterAcLogList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//获取租客的权限状态
+(void)getRenterACOptStatusInfo:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/getRenterACOptStatusInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//关闭手机开门
+(void)closeRenterMobileAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/closeRenterMobileAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//关闭身份证开门
+(void)closeRenterIdentityCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/closeRenterIdentityCardAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//关闭IC卡开门
+(void)closeRenterICCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/closeRenterICCardAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//开启手机开门
+(void)openRenterMobileAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/openRenterMobileAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//开启身份证开门
+(void)openRenterIdentityCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/openRenterIdentityCardAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//关闭IC卡开门
+(void)openRenterICCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/openRenterICCardAccess"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//删除一般租客
+(void)deleteRenterInAcLog:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/deleteRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//获取指定租客的出入记录
+(void)getSomeRenterAcLogList:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Renter_access/getRenterAcLogList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//租客认证
+(void)validateRenter:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/renter/validateRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//屋主认证
+(void)validateBO:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Business_owner/validateBO"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+(void)editRentRecord:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Business_owner/editRentRecord"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//-----------------------------2期-------------------------------------//
//获取出入记录
+(void)getRenterAcLog:(NSDictionary *)paramster andType:(NSString *)type callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString;
    if ([type isEqualToString:@"master"]) {
        urlString= [self urlString:@"/Business_owner/getRenterAcLog"];
    }else{
        urlString= [self urlString:@"/renter/getRenterAcLog"];
    }
    
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//获取公寓账单
+(void)getAccountBook :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Business_owner/getAccountBook"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//租房列表
+(void)getCommunityRentInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityRentInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}


+(void)getHouseAllAvailabelBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseAllAvailabelBillList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

+(void)getIncomeTotal:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Business_owner/getIncomeTotal"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
+(void)operateHouseAC :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/operateHouseAC"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

///编辑虚拟租客
+(void)editVirtualMainRenter :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/editVirtualMainRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

///获取水费详情
+(void)getHouseWaterDetail :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseWaterDetail"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取电费详情
+(void)getHouseElectricDetail :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseElectricDetail"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取房间抄表历史
+(void)getHouseRecordLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseRecordLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取公寓已出账单
+(void)getCommunityAvailableBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityAvailableBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取房间账单
+(void)getHouseAvailableBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseAvailableBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取房间账单列表
+(void)getRentRecordAvailabelBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getRentRecordAvailabelBillList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///替换虚拟租客
+(void)replaceVirtualMainRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/replaceVirtualMainRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
+(void)editRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/Business_owner/editRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取公寓所有账单
+(void)getCommunityBill :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取公寓的抄表记录
+(void)getCommunityRecord:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityRecord"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

///设置账单为未缴
+(void)setHousePayBillUnpaid:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/setHousePayBillUnpaid"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//录入电费
+(void)recordHouseElectric:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/recordHouseElectric"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//录入水费
+(void)recordHouseWater:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/recordHouseWater"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///调整账单金额
+(void)editHousePayBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/editHousePayBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///获取房间账单日志记录
+(void)getHousePayBillLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHousePayBillLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///设置用户角色
+(void)setMemberRole:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/setMemberRole"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///签约虚拟客户
+(void)signVirtualRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/signVirtualRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//添加虚拟租客
+(void)addVirtualRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/addVirtualRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//虚拟租客修改密码
+(void)editVirtualMemberInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback
{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/editVirtualMemberInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///-----------------------------注册------------------------------------//
#pragma mark -m 用户注册
+(void)registerUser:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
     NSString *urlString = [self urlString:@"/common/regist"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 发送验证码
+(void)registerSendCode:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response) )callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/sendRegistSMS"];
    
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///-----------------------------登录------------------------------------//
#pragma mark -m 用户登录-账号userAccountLogin
+(void)userAccountLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response) )callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/loginPassword"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 用户登录-手机
+(void)userPhoneLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response) )callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/loginSMS"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 用户手机登录获取验证码userPhoneGetCodeLogin
+(void)userPhoneGetCodeLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response) )callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/sendLoginSMS"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///-----------------------------身份证验证------------------------------//
#pragma mark -m 上传身份证照片
+(void)uploadIDCardImage:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response) )callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/upload/uploadImgFile"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 认证身份证信息---屋主认证
+(void)certificateIDCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/validateBO"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 认证屋主银行卡
+(void)certificateMasterBankCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/validateBOBankCard"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 获取开户行
+(void)getBankList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/getBankList"];
    [request GET:urlString query:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
   
}
#pragma mark -m 租客身份认证
+(void)certificateRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/renter/validateRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 认证后，获取新的信息getUserBaseInfo
+(void)getUserBaseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/getMemberBaseInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取屋主信息
+(void)getBOInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getBOInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
///------------------------------找回密码-------------------------//
#pragma mark -m 重设密码
+(void)forgetPassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/findPassword"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 发送忘记密码验证码
+(void)sendForgetSMS:(NSDictionary *)paramster callback:(void (^)(NSError *, id))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/common/sendFindSMS"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 退出登录
+(void)loginOut:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/logout"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 修改密码
+(void)userChangePassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/resetPassword"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 发送修改密码的验证码
+(void)sendResetKeyCode:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/sendResetPasswordSMS"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//-----------------------------------屋主公寓---------------------//
#pragma mark -m 获取屋主的公寓列表
+(void)getCommunityInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getCommunityInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取公寓房间信息
+(void)getHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 编辑房间信息
+(void)editHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/editHouseInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 签约租客
+(void)signRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/signRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 添加租客
+(void)addRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/addRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 删除租客
+(void)deleteRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/deleteRenter"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}


#pragma mark -m 终止合同
+(void)finishRentRecord:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/finishRentRecord"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 修改房间的缴费信息
+(void)payHouseCharge:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/payHouseCharge"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 查询手机用户信息
+(void)getMemberInfoByPhone:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/member/getMemberInfoByPhone"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

//--------------------------------------租客-----------------------------------//
#pragma mark -m 我的合约
+(void)getRentRecordInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/renter/getAvailableHouseInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取待确认合约信息
+(void)RentergetRentRecordInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/renter/getRentRecordInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 屋主的银行卡信息
+(void)getBankCardInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getBOInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//------------------------------屋主金额-----------------------------------//
#pragma mark -m 查询金额记录
+(void)getPDRechargeLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getPDRechargeLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 查询金额记录（新）
+(void)getPDCashLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/getPDCashLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 搜索金额记录
+(void)searchPDRechargeLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/searchPDRechargeLog"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取公寓费用
+(void)getCommunityChargeInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/getCommunityChargeInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 水费录入
+(void)recordWaterValue:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/recordWaterValue"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 电费录入
+(void)recordElectricValue:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/recordElectricValue"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 生成公寓账单
+(void)createCommunityPayBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/community/createCommunityPayBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 租客获取房间账单
+(void)getHouseBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/house/getHouseBillList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取支付信息
+(void)payOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/order/payOrder"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取支付信息
+(void)payBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/order/payBill"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
//--------------------------宽带---------------------------------//
#pragma mark -m 获取宽带商品列表
+(void)getTelecomGoodsList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getTelecomGoodsList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 下单购买宽带套餐
+(void)TelecomGoodsOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/createTelecomGoodsOrder"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 查询宽带开通情况
+(void)getCurrentTelecomInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/telecom/getCurrentTelecomInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 获取承诺书以及安全数
+(void)getBook:(NSDictionary *)paramster andBookType:(NSString *)book callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:[NSString stringWithFormat:@"/misc/%@",book]];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
#pragma mark -m 编辑租客授权时间
+(void)editRenterInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/business_owner/editRenterInfo"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}

#pragma mark -m 代理商宽带列表
+(void)getTelecomInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback{
    HTTPRequest* request = [[HTTPRequest alloc]init];
    NSString *urlString = [self urlString:@"/agent/getTelecomInfoList"];
    [request POST:urlString body:paramster response:^(NSError *error, id response) {
        callback(error,response);
    }];
}
@end


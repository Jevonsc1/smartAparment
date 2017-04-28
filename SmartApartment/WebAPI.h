//
//  WebAPI.h
//  CarLife
//  服务主类,用于数据服务同步
//  Created by kenshinhu on 2/24/16.
//  Copyright © 2016 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "WebAPIForRenthouse.h"
#import "WebAPIForBroadband.h"
#import "WebAPIForMyDoorCard.h"

@interface WebAPI : NSObject

///------------------------宽带订单支付接口--------------------///
+(void)payOrderVersion2:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
///------------------------门禁管理-------------------------///

+(void)getRenterAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)getRenterAcLogList:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)deleteRenterInAcLog:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)getSomeRenterAcLogList:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;

+(void)closeRenterICCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;

+(void)getRenterACOptStatusInfo:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)closeRenterMobileAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)closeRenterIdentityCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;

+(void)openRenterICCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)openRenterMobileAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
+(void)openRenterIdentityCardAccess:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;

//新的租客认证
+(void)validateRenter:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
//新的屋主认证
+(void)validateBO:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;

+(void)editRentRecord:(NSDictionary *)paramster  callback:(void (^)(NSError * err, id response))callback;
///------------------------------2期-------------------------///
/*公寓出入记录*/
+(void)getRenterAcLog:(NSDictionary *)paramster andType:(NSString *)type callback:(void (^)(NSError * err, id response))callback;
/**
 获取账本首页的数据

 @param paramster 参数
 @param callback 返回
 */
+(void)getAccountBook :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//租房列表
+(void)getCommunityRentInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取历史账单
+(void)getHouseAllAvailabelBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取已出账单接口
+(void)getIncomeTotal:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+(void)operateHouseAC :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓房间的电费详情
+(void)getHouseElectricDetail :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//编辑虚拟租客
+(void)editVirtualMainRenter :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓房间的水费详情
+(void)getHouseWaterDetail :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取房间抄表历史
+(void)getHouseRecordLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//公寓已出账单
+(void)getCommunityAvailableBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//查看房间已出账单
+(void)getHouseAvailableBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
+(void)getRentRecordAvailabelBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//替换虚拟租客
+(void)replaceVirtualMainRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+(void)editRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓所有账单
+(void)getCommunityBill :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取公寓抄表记录
+(void)getCommunityRecord:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//设置账单为未缴
+(void)setHousePayBillUnpaid:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//录入水
+(void)recordHouseWater:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//录入电
+(void)recordHouseElectric:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
+(void)editHousePayBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
+(void)getHousePayBillLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
+(void)setMemberRole:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//签约虚拟租客
+(void)signVirtualRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//添加虚拟租客
+(void)addVirtualRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//虚拟租客修改密码
+(void)editVirtualMemberInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
///------------------------------1期-------------------------///
//用户注册

+(void)registerUser :(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//发送验证码
+(void)registerSendCode:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//用户登录--账号
+(void)userAccountLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//用户登录--手机验证码
+(void)userPhoneLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//用户登录--获取验证码
+(void)userPhoneGetCodeLogin:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//上传身份证照片uploadIDCardImage
+(void)uploadIDCardImage:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//保存用户认证资料
+(void)certificateIDCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//认证屋主银行卡
+(void)certificateMasterBankCard:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//银行开户行
+(void)getBankList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//租客身份认证
+(void)certificateRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//忘记密码
+(void)forgetPassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//忘记密码，发送验证码
+(void)sendForgetSMS:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//退出登录-清除key
+(void)loginOut:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//刷新获取用户信息
+(void)getUserBaseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
// 获取屋主信息
+(void)getBOInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//修改密码
+(void)userChangePassword:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//修改密码时发送验证码
+(void)sendResetKeyCode:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//我的合约
+(void)getRentRecordInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//我的银行卡
+(void)getBankCardInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//公寓列表
+(void)getCommunityInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//房间信息
+(void)getHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
+(void)editHouseInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//签约租客
+(void)signRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//添加租客
+(void)addRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//删除租客
+(void)deleteRenter:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//根据手机号码查询资料
+(void)getMemberInfoByPhone:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取待确认合约
+(void)RentergetRentRecordInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取金额记录
+(void)getPDRechargeLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//查询金额记录（新）
+(void)getPDCashLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//搜索金额记录
+(void)searchPDRechargeLog:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

//获取公寓费用
+(void)getCommunityChargeInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//录入水费
+(void)recordWaterValue:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//录入电费
+(void)recordElectricValue:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//生成公寓账单
+(void)createCommunityPayBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

//租客获取账单
+(void)getHouseBillList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取支付信息
+(void)payOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//新的支付信息
+(void)payBill:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//终止合同
+(void)finishRentRecord:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//费用查询中修改房屋信息
+(void)payHouseCharge:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//获取宽带商品列表
+(void)getTelecomGoodsList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//下单购买宽带商品
+(void)TelecomGoodsOrder:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
//查询宽带开通情况
+(void)getCurrentTelecomInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;

+(void)getBook:(NSDictionary *)paramster andBookType:(NSString *)book callback:(void (^)(NSError * err, id response))callback;

//编辑租客信息
+(void)editRenterInfo:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
#pragma mark -m 代理商宽带列表
+(void)getTelecomInfoList:(NSDictionary *)paramster callback:(void (^)(NSError * err, id response))callback;
@end

//
//  MasterInfo.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/25.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MasterInfo : NSObject
@property(nonatomic,copy)NSString* boAuditSuggestion;
@property(nonatomic,copy)NSString* boBackIDCardImgPath;
@property(nonatomic,strong)NSArray* boBank;
@property(nonatomic,copy)NSString* boCertificateNum;
@property(nonatomic,copy)NSString* boFrontIDCardImgPath;
@property(nonatomic,copy)NSString* boHandleIDCardImgPath;
@property(nonatomic,strong)NSNumber* boID;
@property(nonatomic,assign)BOOL boIsDisable;
@property(nonatomic,copy)NSString* boIDCardNum;
@property(nonatomic,strong)NSNumber* boMaxHouseNum;
@property(nonatomic,strong)NSNumber* boStatus;
@property(nonatomic,copy)NSString* boTrueName;
@property(nonatomic,strong)NSNumber* boValidTime;
@property(nonatomic,strong)NSNumber* boValidateStatus;


@end

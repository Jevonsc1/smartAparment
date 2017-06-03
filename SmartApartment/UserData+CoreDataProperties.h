//
//  UserData+CoreDataProperties.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/22.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "UserData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserData (CoreDataProperties)

+ (NSFetchRequest<UserData *> *)fetchRequest;

@property (nonatomic) int32_t boStatus;
@property (nullable, nonatomic, copy) NSString *idCardNum;
@property (nullable, nonatomic, copy) NSString *idStatus;
@property (nullable, nonatomic, copy) NSString *isOpenNet;
@property (nullable, nonatomic, copy) NSString *key;
@property (nonatomic) int32_t member_sex;
@property (nullable, nonatomic, copy) NSString *memberAddress;
@property (nonatomic) float memberAvailablePD;
@property (nullable, nonatomic, copy) NSString *memberAvatar;
@property (nonatomic) float memberFreezePD;
@property (nullable, nonatomic, copy) NSString *memberID;
@property (nonatomic) int32_t memberIsDisable;
@property (nullable, nonatomic, copy) NSString *memberNickName;
@property (nullable, nonatomic, copy) NSString *memberRegistTime;
@property (nullable, nonatomic, copy) NSString *memberType;
@property (nullable, nonatomic, copy) NSString *memberPhone;
@property (nullable, nonatomic, copy) NSString *password;
@property (nullable, nonatomic, copy) NSString *renterAddress;
@property (nullable, nonatomic, copy) NSString *renterStatus;
@property (nullable, nonatomic, copy) NSString *searchList;
@property (nullable, nonatomic, copy) NSString *searchRecord;
@property (nullable, nonatomic, copy) NSString *trueName;
@property (nullable, nonatomic, copy) NSString *renterID;
@end

NS_ASSUME_NONNULL_END

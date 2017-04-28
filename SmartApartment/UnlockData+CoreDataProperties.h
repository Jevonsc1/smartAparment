//
//  UnlockData+CoreDataProperties.h
//  SmartApartment
//
//  Created by Jevons on 2017/4/26.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "UnlockData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UnlockData (CoreDataProperties)

+ (NSFetchRequest<UnlockData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *app_id;
@property (nullable, nonatomic, copy) NSString *unlock_time;

@end

NS_ASSUME_NONNULL_END

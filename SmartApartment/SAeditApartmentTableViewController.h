//
//  SAeditApartmentTableViewController.h
//  SmartApartment
//
//  Created by williamliuwen on 2016/11/8.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BBImagebaseTableVC.h"

@interface SAeditApartmentTableViewController : BBImagebaseTableVC
@property(nonatomic,copy)NSString *apartmentID;
@property(nonatomic,copy)NSString *apartmentNameString;
@property(nonatomic,copy)NSString *apartmentAddressString;
@property(nonatomic,copy)NSString *powerMoneyString;
@property(nonatomic,copy)NSString *waterMoneyString;
@property(nonatomic,copy)NSString *keyString;
@property(nonatomic,copy)NSString *fixIDStringString;
@property(nonatomic,copy)NSString *otherMoneyString;
@property(nonatomic,copy)NSString *otherMoneyDescriptionString;
@property(nonatomic,strong)NSArray *apartmentPicArray;
@property(nonatomic,strong)NSArray *areaArray;
@property(nonatomic)NSString *communityNodeID;
@property(nonatomic)NSString *communityCity;
@end

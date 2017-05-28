//
//  ShowCommunityController.h
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegate.h"
#import "Community.h"
@interface ShowCommunityController : UITableViewController
@property(nonatomic,strong)Community *curCommunity;
@property(nonatomic,strong)NSArray* communityArray;
@property(nonatomic)NSObject<MyDelegate> *delegate;

@end

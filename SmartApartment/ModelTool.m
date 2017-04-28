//
//  ModelTool.m
//  SmartApartment
//
//  Created by Jevons on 2017/4/28.
//  Copyright © 2017年 Jevons. All rights reserved.
//

#import "ModelTool.h"

@implementation ModelTool

+(UserData *)find_UserData{
    NSArray *dataArr = [UserData MR_findAll];
    
    for (UserData *data in dataArr) {
        
        if ([data.memberPhone isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"]]) {
            return data;
        }
    }
    return [UserData MR_createEntity];
}

+(UnlockData *)create_UnlockData{
    return [UnlockData MR_createEntity];
}

+(UnlockData *)find_UnlockData{
    NSArray *dataArr = [UnlockData MR_findAllSortedBy:@"unlock_time" ascending:NO];
    if (dataArr.count == 0) {
       return  [UnlockData MR_createEntity];
    }else{
        return dataArr[0];
    }
}

+(void)delete_UnlockDataWith:(NSString*)time{
    NSArray *dataArr = [UnlockData MR_findAllSortedBy:@"unlock_time" ascending:NO];
    for (UnlockData* unlock in dataArr) {
        if(unlock.unlock_time == time){
            [unlock MR_deleteEntity];
        }
    }
}
@end

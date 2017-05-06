//
//  EntrySelectRoomView.h
//  SmartApartment
//
//  Created by Trudian on 17/2/10.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntrySelectRoomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;
@property (weak, nonatomic) IBOutlet UILabel *communityName;
@property (weak, nonatomic) IBOutlet UITableView *hightNumTable;
@property (weak, nonatomic) IBOutlet UITableView *roomNumTable;

@end

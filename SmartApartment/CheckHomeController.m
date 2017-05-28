//
//  CheckHomeController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "CheckHomeController.h"
#import "ShowCommunityController.h"
#import "HouseHistoryController.h"
#import "CheckInputReadController.h"
#import "ShowCheckHouseController.h"
@interface CheckHomeController ()<MyDelegate>
//公寓名字
@property (weak, nonatomic) IBOutlet UIView *comTitleView;
@property (weak, nonatomic) IBOutlet UILabel *comTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comTitleAutoWidth;
@property (weak, nonatomic) IBOutlet UILabel *changLabel;

@property(nonatomic,strong)Community* curCommunity;
@end

@implementation CheckHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.communityArray.count>0) {
        self.curCommunity = self.communityArray[0];
        self.comTitleLabel.text = self.curCommunity.communityName;
    }
    [self addTapForView];
    
}


//暂定跳转到历史记录
- (IBAction)ClickTopHistory:(id)sender {
    ShowCheckHouseController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowCheckHouse"];
    vc.community = self.curCommunity;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)clickToPop:(id)sender {
  
    [PopHome popToController:@"NewMasterHomeController" andVC:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckInputReadController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"CheckInputRead"];
    vc.community = self.curCommunity;
   
    if (indexPath.row == 0) {
        vc.wayIn = @"电费";
    }else{
        vc.wayIn = @"水费";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
-(void)passValue:(NSString *)value{
    for (int i = 0; i <self.communityArray.count; i++) {
        Community *apart = self.communityArray[i];
        if ([apart.communityID isEqualToString:value]) {
            self.curCommunity = apart;
        }
    }
    self.comTitleLabel.text = self.curCommunity.communityName;
}
//---点击公寓名字的view,跳转到公寓列表-----///
-(void)addTapForView{
    if (self.communityArray.count >1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickToComList)];
        [self.comTitleView addGestureRecognizer:tap];
    }
    else{
        self.changLabel.hidden = YES;
    }
}
-(void)ClickToComList{
    
    ShowCommunityController *vc = [[UIStoryboard storyboardWithName:@"CheckRead" bundle:nil] instantiateViewControllerWithIdentifier:@"ShowCommunity"];
    vc.communityArray = self.communityArray;
    vc.curCommunity = self.curCommunity;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end

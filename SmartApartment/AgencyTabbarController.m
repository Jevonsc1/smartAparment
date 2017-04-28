//
//  AgencyTabbarController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "AgencyTabbarController.h"
#import "BroadbandController.h"
@interface AgencyTabbarController ()

@end

@implementation AgencyTabbarController
{
    NSInteger tempIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    if (self.selectedIndex != 1) {
        self.navigationController.navigationBar.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    tempIndex = self.selectedIndex;

}
- (IBAction)clickToPop:(id)sender {
    self.tabBar.hidden = NO;
    self.selectedIndex = tempIndex;
}


@end

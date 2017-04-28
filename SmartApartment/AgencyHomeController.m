//
//  AgencyHomeController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "AgencyHomeController.h"
#import "BroadbandController.h"

@interface AgencyHomeController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeAutoTop;

@end

@implementation AgencyHomeController
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏的颜色
  
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0/255.0 green:101.0/255.0 blue:192.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -m 跳转到宽带
- (IBAction)turnToBroadBand:(id)sender {
    BroadbandController *vc = [[UIStoryboard storyboardWithName:@"Agency" bundle:nil] instantiateViewControllerWithIdentifier:@"Broadband"];
    vc.wayIn = @"home";
    [self.navigationController pushViewController:vc animated:YES];
}

@end

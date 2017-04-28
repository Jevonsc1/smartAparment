//
//  SelectPersonController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SelectPersonController.h"

@interface SelectPersonController ()
@property (weak, nonatomic) IBOutlet UIView *renter;
@property (weak, nonatomic) IBOutlet UIView *master;
@property(nonatomic,strong)UserData* user;

@end

@implementation SelectPersonController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0/255.0 green:101.0/255.0 blue:192.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:NO];
    //添加一个黑色view在状态栏中
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    [self.navView setBackgroundColor: [UIColor blackColor]];
    [self.view addSubview:self.navView];
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.user = [AppTool find_UserData];

    if ([self.user.memberType isEqualToString:@"master"] ) {
        self.renter.hidden = YES;
        self.master.hidden = NO;
//        UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"UserHome" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterPerson"];
//        
//        [self addChildViewController:vc1];
//        vc1.view.frame = CGRectMake(0, 20, SCREEN_WIDTH, self.view.height);
//        [self.view addSubview:vc1.view];
//        [vc1 didMoveToParentViewController:self];
    }else{
        self.renter.hidden = NO;
        self.master.hidden = YES;
//        UIViewController *vc1 = [[UIStoryboard storyboardWithName:@"UserHome" bundle:nil] instantiateViewControllerWithIdentifier:@"UserPerson"];
//        
//        [self addChildViewController:vc1];
//        vc1.view.frame = CGRectMake(0, 20, SCREEN_WIDTH, self.view.height);
//        [self.view addSubview:vc1.view];
//        [vc1 didMoveToParentViewController:self];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

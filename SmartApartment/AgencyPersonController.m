//
//  AgencyPersonController.m
//  SmartApartment
//
//  Created by Trudian on 16/11/30.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "AgencyPersonController.h"
#import "LoginViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface AgencyPersonController ()
@property (weak, nonatomic) IBOutlet UIButton *avaterIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation AgencyPersonController
{
    UserData *user;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    user = [ModelTool find_UserData];
    
    //添加一个黑色view在状态栏中
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.view addSubview:navView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.icon sd_setImageWithURL:[NSURL URLWithString:user.memberAvatar] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    self.icon.layer.masksToBounds = YES;
    [self.icon.layer setCornerRadius:self.icon.width/2];
    self.userName.text = user.trueName;
    self.phone.text = user.memberPhone;
    self.navigationController.navigationBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.view.width/375*195;
    }else{
        return  cellHeight;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"\n请确认退出登录!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.tabBar.hidden = YES;
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
            [self dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:cancel];
        [ac addAction:sure];
        [self presentViewController:ac animated:YES completion:nil];

        
      
    }
}

@end

//
//  MasterSelfController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "MasterSelfController.h"

@interface MasterSelfController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *IDCard;
@property (weak, nonatomic) IBOutlet UIImageView *renterOpenIcon;
@property (weak, nonatomic) IBOutlet UILabel *renterLabel;

@end

@implementation MasterSelfController
{

    UserData *userData;
    NSArray *acArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加一个黑色view在状态栏中
    userData = [ModelTool find_UserData];
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:navView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:@"acInfo.data"];
    // 解档
    acArr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    self.name.text = userData.trueName;
    self.IDCard.text = userData.idCardNum;
    self.renterLabel.hidden = NO;
    self.renterOpenIcon.hidden = NO;
  
    

}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return cellHeight;
    }
    else{
        if (acArr==nil||[acArr isKindOfClass:[NSNull class]]) {
            return 40 *ratio;
        }else{
            if (acArr.count <= 0) {
                return 40*ratio;
            }else
                return 80 * 320/375;
            

        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end

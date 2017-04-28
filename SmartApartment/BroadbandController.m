//
//  BroadbandController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/1.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "BroadbandController.h"
#import "apartmentCell.h"
#import "NetRoomListController.h"

@interface BroadbandController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableAutoTop;

@end

@implementation BroadbandController
{
    NSArray *comArr;

    NSMutableArray *comhouseArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0/255.0 green:101.0/255.0 blue:192.0/255.0 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //添加一个黑色view在状态栏中
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:navView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView.backgroundColor = [UIColor clearColor];
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    
    comhouseArr = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key", nil];
    [WebAPI getTelecomInfoList:dic callback:^(NSError *err, id response) {
        if(!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000){
            comArr = [response objectForKey:@"data"];
            for (int i = 0; i < comArr.count; i ++) {
                NSArray *arr = [comArr[i] objectForKey:@"houseInfo"];
                [comhouseArr addObject:arr];
                
            }
            [self.tableView reloadData];
        }else{
            if (err) {
                [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:3 complete:^(BOOL isComplete) {
                    
                }];
            }else{
               RequestBad
            }
        }
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
  
}
- (IBAction)clickToPop:(id)sender {
    self.tabBarController.tabBar.hidden = NO;
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return comArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *comInfo = comArr[indexPath.row];
    apartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"apartment"];
    cell.apartName.text = [comInfo objectForKey:@"communityName"];
    NSInteger openNetNum  = 0;
    NSArray *houseArr1 = comhouseArr[indexPath.row] ;
    
    if (houseArr1.count>0) {
        for (int i = 0; i<houseArr1.count; i++) {
            NSDictionary *houseDic = houseArr1[i];
            if ([NSString stringWithFormat:@"%@",[houseDic objectForKey:@"houseStatus"]].integerValue == 1) {
                NSArray *renterArr = [[houseDic objectForKey:@"rentInfo"][0] objectForKey:@"renterInfo"];
                for (int i = 0 ; i < renterArr.count; i++) {
                    
                    NSArray *temArr = [renterArr[i] objectForKey:@"telecomInfo"];
                    if (temArr.count > 0) {
                        NSDictionary *temDic = temArr[0];
                        if ([NSString stringWithFormat:@"%@",[temDic objectForKey:@"telecomStatus"]].integerValue == 1 && [NSString stringWithFormat:@"%@",[temDic objectForKey:@"telecomIsDisable"]].integerValue ==0) {
                            openNetNum++;
                            break;
                        }
                    }
                }
                
            }
           
        }
    }
    
    
    float openNum = (float)openNetNum;
    float houseCount = (float)houseArr1.count;
    float pre = openNum/houseCount ;
    if ([[NSString stringWithFormat:@"%f",pre] isEqualToString:@"nan"]) {
        pre = 0.0;
    }
    
    NSString *prec =  [NSString stringWithFormat:@"开通率%.0f",pre*100] ;
    cell.openPecent.text = [prec stringByAppendingString:@"%"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NetRoomListController *vc = [[UIStoryboard storyboardWithName:@"message" bundle:nil] instantiateViewControllerWithIdentifier:@"NetRoomList"];
    vc.houseArr = comhouseArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)passValue:(NSString *)value{
    NSLog(@"2%@",value);
    self.wayIn = value;
    [self.tableAutoTop setConstant:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end

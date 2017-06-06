//
//  TDOrderHistoryListViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDOrderHistoryListViewController.h"
#import "TDOrderHistoryListTableViewCell.h"
#import "TDOrderHistoryInfoViewController.h"

@interface TDOrderHistoryListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *tableDatas;
@end

@implementation TDOrderHistoryListViewController
{
    //没有数据的背景图
    UIView *bgView;
}
- (void)loadHistoryOrderInfoList {
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"pageNum":@"1",
                                 @"pageSize":@"10",
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband loadHistoryOrderInfoList:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            NSLog(@"%@",result);
            //[result createPropertyCode];
            if (result.count >0) {
                _tableDatas = [result arrayForKey:@"telecomInfoList"];
                if (_tableDatas.count >0) {
                    if (bgView) {
                        [bgView removeFromSuperview];
                    }
                }else{
                    [self initNodataView];
                }
            }
            [_tableView reloadData];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"历史订单"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TDOrderHistoryListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TDOrderHistoryListTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHistoryOrderInfoList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableDatas) {
        return [_tableDatas count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"TDOrderHistoryListTableViewCell";
    TDOrderHistoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TDOrderHistoryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *dictionary = [_tableDatas objectAtIndex:indexPath.row];
    [cell reloadData:dictionary];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [_tableDatas objectAtIndex:indexPath.row];
    if (dictionary) {
        TDOrderHistoryInfoViewController *controller = [[TDOrderHistoryInfoViewController alloc] init];
        controller.orderID = [dictionary stringForKey:@"orderID"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//没有账单的情况下，创建没有数据的界面
-(void)initNodataView{
    if (!bgView) {
        bgView= [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 175*ratio, 163*ratio)];
        iconView.centerX = bgView.centerX;
        [iconView setImage:[UIImage imageNamed:@"net_image"]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40+175*ratio, self.view.width, 21)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"您还没有订购过宽带~";
        label.textColor = TDRGB(102, 102, 102);
        label.font = [UIFont systemFontOfSize:16 *ratio];
        [bgView addSubview:label];
        [bgView addSubview:iconView];
        [self.tableView addSubview:bgView];
    }
}
@end

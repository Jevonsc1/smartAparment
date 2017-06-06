//
//  TDPricingPackageListViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/2/23.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDPricingPackageListViewController.h"
#import "TDPricingPackageListTableViewCell.h"
#import "TDPricingPackageInfoViewController.h"
#import "TDOrderHistoryListViewController.h"

@interface TDPricingPackageListViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *tableDatas;
@end

@implementation TDPricingPackageListViewController

- (void)loadTelecomInfoList {
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"pageNum":@"1",
                                 @"pageSize":@"10",
                                 @"version":@"2.0"};
    
    [WebAPIForBroadband loadTelecomInfoList:dictionary callback:^(NSError *err, id response) {
        
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response objectForKey:@"data"];
            NSLog(@"%@",result);
            [result createPropertyCode];
            _tableDatas = [result objectForKey:@"telecomInfoList"];
            [_tableView reloadData];
        }else {
            RequestBadByNoNav
        }
    }];
}

- (void)rightBarButtonItem:(UIBarButtonItem *)item {
    TDOrderHistoryListViewController *controller = [[TDOrderHistoryListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"订购套餐"];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"历史订单"style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItem:)];
    self.navigationItem.rightBarButtonItem  = right;
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16*ratio],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"TDPricingPackageListTableViewCell" bundle:nil] forCellReuseIdentifier:@"TDPricingPackageListTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTelecomInfoList];
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
    NSString *reuseIdentifier = @"TDPricingPackageListTableViewCell";
    TDPricingPackageListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TDPricingPackageListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    NSDictionary *dictionary = [_tableDatas objectAtIndex:indexPath.row];
    [cell reloadData:dictionary];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [_tableDatas objectAtIndex:indexPath.row];
    NSString *telecomID = [dictionary stringForKey:@"telecomID"];
    if (telecomID) {
        TDPricingPackageInfoViewController *controller = [[TDPricingPackageInfoViewController alloc] init];
        controller.telecomID = telecomID;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end

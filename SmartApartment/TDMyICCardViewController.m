//
//  TDMyICCardViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/6.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDMyICCardViewController.h"

@interface TDMyICCardViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *rowTitles;
@property (strong, nonatomic) NSMutableArray *detailTexts;
@end

@implementation TDMyICCardViewController

- (void)loadICCardStateInfo {
    if (!_houseID) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":_houseID,
                                 @"version":@"2.0"};
    
    [self.view showHUD];
    [WebAPIForMyDoorCard loadICCardStateInfo:dictionary callback:^(NSError *err, id response) {
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response dictionaryForKey:@"data"];
            [_detailTexts addObject:[result stringForKey:@"cardHolder"]];
            [_detailTexts addObject:[result stringForKey:@"communityName"]];
            [_detailTexts addObject:[result stringForKey:@"houseName"]];
            [_detailTexts addObject:[result dateForKey:@"bindTime"]];
            switch ([result intForKey:@"cardStatus"]) {
                case 1:
                {
                    [_detailTexts addObject:@"正常启用"];
                }
                    break;
                case 2:
                {
                    [_detailTexts addObject:@"未启用"];
                }
                    break;
                case 3:
                {
                    [_detailTexts addObject:@"已挂失"];
                    [_detailTexts addObject:[result dateForKey:@"reportLossTime"]];
                    [_rowTitles addObject:@"挂失时间"];
                }
                    break;
                case 4:
                {
                    [_detailTexts addObject:@"已禁用"];
                    [_detailTexts addObject:[result dateForKey:@"dueTime"]];
                    [_rowTitles addObject:@"预计恢复时间"];
                }
                    break;
                case 5:
                {
                    [_detailTexts addObject:@"账单关闭"];
                }
                    break;
                default:
                    break;
            }
            [_tableView reloadData];
            NSLog(@"%@",result);
            [self.view hideHUD];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的 IC卡"];
    
    _rowTitles = [[NSMutableArray alloc] initWithArray:@[@"持有人姓名",@"入住公寓",@"入住房间",@"IC卡绑定日期",@"IC卡状态"]];
    _detailTexts = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_tableView];
    
    [self loadICCardStateInfo];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_detailTexts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.textLabel setText:[_rowTitles stringAtIndex:indexPath.row]];
    
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
    [cell.detailTextLabel setText:[_detailTexts stringAtIndex:indexPath.row]];
    if ([[_rowTitles stringAtIndex:indexPath.row] isEqualToString:@"IC卡状态"]) {
        if ([[_detailTexts stringAtIndex:indexPath.row] isEqualToString:@"正常启用"]) {
            [cell.detailTextLabel setTextColor:RGB(102, 177, 79)];
        }else if ([[_detailTexts stringAtIndex:indexPath.row] isEqualToString:@"已禁用"]) {
            [cell.detailTextLabel setTextColor:RGB(229, 89, 89)];
        }else {
            [cell.detailTextLabel setTextColor:RGB(136, 136, 136)];
        }
    }else {
        [cell.detailTextLabel setTextColor:RGB(136, 136, 136)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

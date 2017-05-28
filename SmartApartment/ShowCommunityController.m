//
//  ShowCommunityController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/9.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ShowCommunityController.h"
#import "CheckCommunityCell.h"
#import "ShowCheckHouseController.h"
@interface ShowCommunityController ()

@end

@implementation ShowCommunityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}


- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.communityArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckCommunityCell" forIndexPath:indexPath];
    Community* community = self.communityArray[indexPath.row];
    cell.communityName.text = community.communityName;
    return cell;
}

//选择公寓，返回抄表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Community* community = self.communityArray[indexPath.row];
    [self.delegate passValue:community.communityID];
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 32*ratio;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
    view.backgroundColor = TDRGB(245.0,245.0, 245.0);
    //长条
    UIView *smallView = [[UIView alloc]initWithFrame:CGRectMake(18 *ratio, 0, 7 *ratio, 17*ratio)];
    smallView.backgroundColor = MainBlue;
    //文字
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 32*ratio)];
//    label.text = self.communityNameArr[section];
    label.font = [UIFont systemFontOfSize:14*ratio];
    label.textColor = TDRGB(136.0, 136.0, 136.0);
    //边线
    UIView *oneline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    oneline.backgroundColor = TDRGB(223, 223, 223);
    UIView *twoline = [[UIView alloc] initWithFrame:CGRectMake(0, view.height-1, self.view.width, 1)];
    twoline.backgroundColor = TDRGB(223, 223, 223);
    [view addSubview:oneline];
    [view addSubview:twoline];
    [view addSubview:smallView];
    [view addSubview:label];
    smallView.centerY = view.centerY;
    label.centerY = view.centerY;
    label.x = smallView.x+smallView.width+8;
    
    return view;
}

@end

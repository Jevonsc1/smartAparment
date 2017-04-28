//
//  ContractListController.m
//  SmartApartment
//
//  Created by Trudian on 16/10/31.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "ContractListController.h"
//#import "MyRentRoomController.h"
//#import "MyRenterRoomCell.h"
#import "MBProgressHUD.h"
@interface ContractListController ()
@property (weak, nonatomic) IBOutlet UILabel *communityName;
@property (weak, nonatomic) IBOutlet UILabel *communityIndex;
@property (weak, nonatomic) IBOutlet UIButton *rightSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftSelectBtn;

@end

@implementation ContractListController
{
    
    NSInteger comIndex;
    NSArray *communityList;
    NSArray *roomList;
    //租房信息
    NSMutableArray *renterRoomList;
    UserData *user;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    comIndex = 0;
    user = [ModelTool find_UserData];
    renterRoomList = [NSMutableArray arrayWithCapacity:0];
    //添加一个黑色view在状态栏中
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 20)];
    [navView setBackgroundColor: [UIColor blackColor]];
    [self.navigationController.navigationBar addSubview:navView];
//    [[tableviewExtern shareInsatance] setExtraCellLineHidden:self.tableView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __block ContractListController *blockSelf = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:user.key,@"key", @"9999",@"pageSize",nil];
    [WebAPI getCommunityInfoList:dic callback:^(NSError *err, id response) {
        
        if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
            communityList = [response objectForKey:@"data"];
            blockSelf.communityIndex.text = [NSString stringWithFormat:@"(1/%lu)",(unsigned long)communityList.count];
            NSDictionary *dic;
            if (communityList.count == 0) {
                self.rightSelectBtn.enabled = NO;
                self.leftSelectBtn.enabled = NO;
                self.communityName.text = @"暂无";
                self.communityIndex.text =@"";
            
            }else{
                dic = communityList[0];
            }
            blockSelf.communityName.text = [dic objectForKey:@"communityName"];
            
            //获取租房列表
            for (int i = 0 ; i <communityList.count; i++) {
                NSDictionary *dic = communityList[i];
                //筛选未出租的房屋
                NSMutableArray *hadRentRoom = [NSMutableArray arrayWithCapacity:0];
                NSArray *houseArr = [dic objectForKey:@"houseInfoList"];
                for (int i = 0 ; i<houseArr.count; i++) {
                    NSDictionary *rdic = houseArr[i];
                    if([[NSString stringWithFormat:@"%@",[rdic objectForKey:@"houseStatus"]] isEqualToString:@"1"]){
                        [hadRentRoom addObject:houseArr[i]];
                    }
                }
                [renterRoomList addObject:hadRentRoom];
        
            }
            [self.tableView reloadData];
        }
        else{
            if (err) {
                [Alert showFail:@"网络异常，请检查网络！" View:self.navigationController.navigationBar andTime:2 complete:^(BOOL isComplete) {
                }];
            }
            else{
              RequestBad
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)leftCommunity:(id)sender {
    
    if (comIndex >=1) {
        comIndex -- ;
    }
    else{
        return;
    }
    self.communityIndex.text = [NSString stringWithFormat:@"(%ld/%lu)",comIndex+1,(unsigned long)communityList.count];
    NSDictionary *dic = communityList[comIndex];
    [self.tableView reloadData];
    self.communityName.text =[dic objectForKey:@"communityName"];

}

- (IBAction)rightCommunity:(id)sender {
    
    if (comIndex <communityList.count-1) {
        comIndex ++ ;
    }
    else{
        return;
    }
    self.communityIndex.text = [NSString stringWithFormat:@"(%ld/%lu)",comIndex+1,(unsigned long)communityList.count];
    NSDictionary *dic = communityList[comIndex];
    [self.tableView reloadData];
    self.communityName.text =[dic objectForKey:@"communityName"];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (renterRoomList.count != 0) {
         NSArray *houseArr = renterRoomList[comIndex];
        return houseArr.count;
    }else{
        return  0;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MyRenterRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contractCell" forIndexPath:indexPath];
//    NSDictionary *dic = renterRoomList[comIndex][indexPath.row];
//    cell.houseName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"houseNum"]];
    return [[UITableViewCell alloc]init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    MyRentRoomController *vc = [[UIStoryboard storyboardWithName:@"PsCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"MyRentRoom"];
//    vc.houseInfo = renterRoomList[comIndex][indexPath.row];
//    
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

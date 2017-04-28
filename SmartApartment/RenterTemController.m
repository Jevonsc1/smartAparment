//
//  RenterTemController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/2.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "RenterTemController.h"
#import "renterUserCell.h"
#import "UIImageView+WebCache.h"
@interface RenterTemController ()

@end

@implementation RenterTemController
{
    NSArray *renterInfo;
    NSMutableArray *renters;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[tableviewExtern shareInsatance]setExtraCellLineHidden:self.tableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    renters = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = [self.renterArr objectForKey:@"rentInfo"];
    self.title = self.houseName;
    renterInfo = [arr[0] objectForKey:@"renterInfo"];
    if (self.netStates.integerValue == 1) {
        for (int i = 0; i <renterInfo.count; i++) {
            NSDictionary *dic = renterInfo[i];
            if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"renterRoleID"]].integerValue == 1) {
                [renters addObject:dic];
            }
        }
    }
    else{
        [renters addObjectsFromArray:renterInfo];
    }
    NSLog(@"%@",renters);
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return renters.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110*ratio;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = renters[indexPath.row];
    renterUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"renterUserCell" ];
    [cell.avater sd_setImageWithURL:[dic objectForKey:@"renterMemberAvatar"] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    cell.renterName.text = [dic objectForKey:@"renterTrueName"];
    cell.renterPhone.text = [dic objectForKey:@"renterPhone"];
    if(self.netStates.integerValue == 1){
        cell.renterSize.text = @"主租客";
    }else{
        cell.renterSize.text = self.netType;
    }
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"renterMemberSex"]].integerValue == 0) {
        [cell.sexIcon setImage:[UIImage imageNamed:@"man"]];
    }else{
        [cell.sexIcon setImage:[UIImage imageNamed:@"girl"]];
    }
    
    return cell;
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

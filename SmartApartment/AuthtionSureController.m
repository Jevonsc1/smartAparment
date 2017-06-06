//
//  AuthtionSureController.m
//  SmartApartment
//
//  Created by Trudian on 17/2/25.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "AuthtionSureController.h"
#import "AuthtionResultController.h"

@interface AuthtionSureController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *idNumber;
@property (weak, nonatomic) IBOutlet UIImageView *forwardImg;
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UIImageView *handImg;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *idnumText;

@end

@implementation AuthtionSureController
{
    NSArray *imageArr;
    NSArray *imageIDsArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"实名认证"];
    self.tableView.scrollEnabled = NO;
    imageArr = [self.imageDic objectForKey:@"images"];
    imageIDsArr = [self.imageDic objectForKey:@"imageIDs"];
    self.forwardImg.image = imageArr[0];
    self.backImg.image = imageArr[1];
    self.handImg.image = imageArr[2];
    self.nameText.text = self.idName;
    self.idnumText.text = self.idnumber;
    [self setViewBorder];
}
-(void)setViewBorder{
    self.oneView.layer.borderWidth = 1;
    self.twoView.layer.borderWidth = 1;
    self.threeView.layer.borderWidth = 1;
    self.oneView.layer.borderColor = TDRGB(204, 204, 204).CGColor;
    self.twoView.layer.borderColor = TDRGB(204, 204, 204).CGColor;
    self.threeView.layer.borderColor = TDRGB(204, 204, 204).CGColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


/**
 提交资料
 */
- (IBAction)clickToUploadMsg:(id)sender {
    if (self.nameText.text.length <=0) {
        [Alert showFail:@"请填写姓名!" View:self.view andTime:1.5 complete:nil];
        return;
    }
    if (self.idnumText.text.length <= 0) {
        [Alert showFail:@"请填写身份证号码!" View:self.view andTime:1.5 complete:nil];
        return;
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:imageIDsArr[1],@"backIDCardAffixID",imageIDsArr[0],@"frontIDCardAffixID",imageIDsArr[2],@"handleIDCardAffixID",[[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"],@"key",self.idnumText.text,@"userIDCard",self.nameText.text,@"userTrueName",@"2.0",@"version", nil];
    //屋主现在没有宽带模块
    if ([self.renterType isEqualToString:@"master"]) {
        [WebAPI validateBO:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
                vc.resultType = 3;
                UserData *data = [ModelTool find_UserData];
                data.idStatus = @"审核中";
                data.renterStatus = @"10";
                data.boStatus = 10;
                vc.mutDictionary = self.mutDictionary;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                RequestBadByNoNav
            }
        }];
    }else{
        [WebAPI validateRenter:dic callback:^(NSError *err, id response) {
            if (!err && [NSString stringWithFormat:@"%@",[response objectForKey:@"rcode"]].integerValue == 10000) {
                AuthtionResultController *vc = [[UIStoryboard storyboardWithName:@"IDAuthtion" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthtionResultController"];
                vc.resultType = 3;
                UserData *data = [ModelTool find_UserData];
                data.idStatus = @"审核中";
                data.renterStatus = @"10";
                data.boStatus = 10;
                vc.mutDictionary = self.mutDictionary;
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                RequestBadByNoNav
            }
        }];
    }
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    // Configure the cell...
    
    return cell;
}
*/

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

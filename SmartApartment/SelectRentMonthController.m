//
//  SelectMonthController.m
//  SmartApartment
//
//  Created by Trudian on 16/12/27.
//  Copyright © 2016年 Trudian. All rights reserved.
//

#import "SelectRentMonthController.h"

@interface SelectRentMonthController ()

@end

@implementation SelectRentMonthController
{
    UIView *tempContentView;
    NSString *monthLength;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   
   
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tempContentView) {
        UIImageView *imageView = tempContentView.subviews[0];
        [imageView setImage:[UIImage imageNamed:@"isNotRight_icon"]];
    }
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *contentView = cell.subviews[1];
    tempContentView = contentView;
    UIImageView *nowImageView = contentView.subviews[0];
    [nowImageView setImage:[UIImage imageNamed:@"isRight_icon"]];
    UILabel *label = contentView.subviews[1];
    if (indexPath.row <=10) {
        monthLength = [label.text substringToIndex:label.text.length-2];
    }else{
        monthLength = [NSString stringWithFormat:@"%ld",[label.text substringToIndex:1].integerValue *12];
    }
    [self.delegate passValue:monthLength];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)clickToPop:(id)sender {
    [self.delegate passValue:monthLength];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickToPopVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

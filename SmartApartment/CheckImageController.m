//
//  CheckImageController.m
//  SmartApartment
//
//  Created by Trudian on 17/1/20.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "CheckImageController.h"

@interface CheckImageController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation CheckImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%d",self.index];
    [self.imageV setImage:self.image];
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickToPop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

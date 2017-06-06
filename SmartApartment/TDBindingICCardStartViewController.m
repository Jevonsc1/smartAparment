//
//  TDBindingICCardStartViewController.m
//  SmartApartment
//
//  Created by 刘靖 on 2017/4/7.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import "TDBindingICCardStartViewController.h"
#import "TDBindingICCardPromptViewController.h"

#import "TDDoorCarListController.h"
#import "AcModel.h"
#import "YYModel.h"
#import "SelectedACView.h"
#import "WebAPIForMyDoorCard.h"
@interface TDBindingICCardStartViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timeInterval;
@property (strong, nonatomic) NSString *applyId;
@property (assign, nonatomic) BOOL isCheckICCardStatus;

@property(nonatomic,strong)NSMutableArray* acModelArray;
@end

@implementation TDBindingICCardStartViewController

-(void)getAcList{
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":self.houseID,
                                 @"version":@"2.0"};
    [WebAPIForMyDoorCard getAcList:dictionary callback:^(NSError *err, id response) {
        if (!err && [response intForKey:@"rcode"] == 10000) {
            NSArray* array = response[@"data"][@"acList"];
            NSLog(@"----%@",array);
            [self.acModelArray removeAllObjects];
            for (NSDictionary* dic in array) {
                AcModel* model = [AcModel yy_modelWithDictionary:dic];
                [self.acModelArray addObject:model];
            }
        }else{
            
        }
    }];
}

- (void)checkApplyICCard {
    if (!_applyId) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"applyId":_applyId,
                                 @"version":@"2.0"};
    
    [self.view showHUD];
    [WebAPIForMyDoorCard checkApplyICCard:dictionary callback:^(NSError *err, id response) {
        
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response dictionaryForKey:@"data"];
            NSLog(@"%@",result);
            [self.view hideHUD];
            
            TDBindingICCardPromptViewController *controller = [[TDBindingICCardPromptViewController alloc] init];
            if ([result intForKey:@"applyStatus"] == 3) {// 失败
                controller.status = BindingICCardStatusFailure;
                controller.statusDesc = [result stringForKey:@"applyDesc"];
            }else if ([result intForKey:@"applyStatus"] == 2) {// 成功
                controller.status = BindingICCardStatusSuccess;
            }else {// 申请中
                [self checkApplyICCard];
                return;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)checkICCardStatus {
    if (!_applyId) {
        return;
    }
    
    if (_isCheckICCardStatus) {
        return;
    }
    _isCheckICCardStatus = YES;
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"applyId":_applyId,
                                 @"version":@"2.0"};

    [WebAPIForMyDoorCard checkApplyICCard:dictionary callback:^(NSError *err, id response) {
        
        if (err) {
            NSLog(@"%@",err.domain);
            _isCheckICCardStatus = NO;
            return;
        }
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response dictionaryForKey:@"data"];
            NSLog(@"%@",result);
            if ([result intForKey:@"applyStatus"] == 2) {// 成功
                [_timer setFireDate:[NSDate distantFuture]];
                TDBindingICCardPromptViewController *controller = [[TDBindingICCardPromptViewController alloc] init];
                controller.status = BindingICCardStatusSuccess;
                [self.navigationController pushViewController:controller animated:YES];
            }
            _isCheckICCardStatus = NO;
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            _isCheckICCardStatus = NO;
        }
    }];
}

- (void)startApplyICCard {
//    NSString *acAPPID;
//    NSArray *localIDs = [NSArray arrayWithContentsOfFile:USEFUL_DOOR_NODE_PATH];
//    if ([localIDs count] == 0) {
//        NSDictionary *localIDDict = [NSDictionary dictionaryWithContentsOfFile:USEFUL_DOOR_NODE_PATH];
//        localIDs = [localIDDict allValues];
//    }
//    if ([localIDs count] > 0) {
//        acAPPID = [localIDs stringAtIndex:0];
//    }
    
    if (!_houseID || !_acmodel.acAPPID) {
        return;
    }
    
    NSString *key = [[NSUserDefaults standardUserDefaults] objectForKey:@"userKey"];
    NSDictionary *dictionary = @{@"key":key,
                                 @"houseID":_houseID,
                                 @"acAPPID":_acmodel.acAPPID,
                                 @"targetMemberID":_memberID?_memberID:@"",
                                 @"syncType":@"0",
                                 @"version":@"2.0"};
    [self.view showHUD];
    NSLog(@"%@",dictionary);
    [WebAPIForMyDoorCard applyICCard:dictionary callback:^(NSError *err, id response) {
        
        if (err) {
            NSLog(@"%@",err.domain);
            [self.view updateHUDWithText:err.domain];
            return;
        }
        NSLog(@"%@",response);
        NSString *code = [response objectForKey:@"rcode"];
        if ([code integerValue] == 10000) {
            NSDictionary *result = [response dictionaryForKey:@"data"];
            [self.view hideHUD];
            
            _applyId = [result stringForKey:@"applyId"];
            _timeInterval = 10+1;//[result intForKey:@"timeOut"];
            [_timer setFireDate:[NSDate distantPast]];
            
            [self.operatingButton setTitle:@"请刷卡" forState:UIControlStateNormal];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self.operatingButton setBackgroundColor:RGB(153, 153, 153)];
                [self.operatingButton cornerRadius:123/2 color:RGB(153, 153, 153)];
            } completion:^(BOOL finished) {
 //               [self hiddenLeftBarButtonItem];
            }];
        }else {
            NSLog(@"%@",[response objectForKey:@"rmsg"]);
            [self.view updateHUDWithText:[response objectForKey:@"rmsg"]];
        }
    }];
}

- (void)timerFired:(NSTimer *)timer {
    _timeInterval -= 1;
    if (_timeInterval == 0) {
        if ([[self.operatingButton currentTitle] isEqualToString:@"请刷卡"]) {
            _timeInterval = 3;
            [self.operatingButton setTitle:@"绑定验证中" forState:UIControlStateNormal];
            [self.operatingPromptLabel setHidden:YES];
            
        }else if ([[self.operatingButton currentTitle] isEqualToString:@"绑定验证中"]) {
            
            [_timer setFireDate:[NSDate distantFuture]];
            [self checkApplyICCard];
        }
    }else {
        NSString *timeString = [NSString stringWithFormat:@" %d ",(int)_timeInterval];
        NSString *string = [NSString stringWithFormat:@"绑定已开始，当门禁指示灯变为蓝色时\n将 IC 卡靠近门禁读卡区域\n您只有%@秒时间进行刷卡绑定",timeString];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:string];
        if (timeString) {
            NSRange range = NSMakeRange([[attributedText string] rangeOfString:timeString].location, [[attributedText string] rangeOfString:timeString].length);
            [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
            [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(229, 89, 89) range:range];
        }
        NSRange range = NSMakeRange([[attributedText string] rangeOfString:@"蓝色"].location, [[attributedText string] rangeOfString:@"蓝色"].length);
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
        [attributedText addAttribute:NSForegroundColorAttributeName value:RGB(46, 126, 224) range:range];
        [self.operatingPromptLabel setAttributedText:attributedText];
        
        [self checkICCardStatus];
    }
}

- (void)touchUpInside:(UIButton *)button {
    
    if ([[button currentTitle] isEqualToString:@"绑定 IC卡"]) {
        if (self.acModelArray.count == 0) {
            [self.view updateHUDWithText:@"没有门口机"];
            return;
        }
        
        if (self.acModelArray.count == 1) {
            [self.operatingButton setTitle:@"开始绑定" forState:UIControlStateNormal];
            [self.operatingPromptLabel setText:@"请在门禁读卡器旁边，准备好 IC 卡\n再点击【开始绑定】，在 10 秒内进行绑定"];
            [self.operatingButton setFrame:CGRectMake((SCREEN_WIDTH-123)/2, 64+SCREEN_WIDTH*0.53+50, 123, 123)];
            [self.operatingButton cornerRadius:123/2 color:RGB(46, 126, 224)];
            self.acmodel = self.acModelArray[0];
        }else{
            TDDoorCarListController* vc = [[TDDoorCarListController alloc]init];
            vc.houseID = self.houseID;
            vc.acModelArray = self.acModelArray;
            vc.memberID = self.memberID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([[button currentTitle] isEqualToString:@"开始绑定"]) {
        
        [self startApplyICCard];
        
        if (!_timer) {
            _timeInterval = 10;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
            [_timer setFireDate:[NSDate distantFuture]];
        }
        
         _isCheckICCardStatus = NO;
        
    }
}

- (void)setup {
    if (!self.acmodel) {
        [self.operatingButton setFrame:CGRectMake((SCREEN_WIDTH-160)/2, 64+SCREEN_WIDTH*0.53+50, 160, 44)];
        [self.operatingButton cornerRadius:7 color:RGB(46, 126, 224)];
        [self.operatingButton setTitle:@"绑定 IC卡" forState:UIControlStateNormal];
        [self.operatingPromptLabel setText:@"首先在房东处购买 IC 卡\n拿到 IC 卡后点击【绑定 IC 卡】"];
        [self getAcList];
    }else{
        SelectedACView* selectView = [SelectedACView selectedAcViewWith:CGRectMake(0, 64+SCREEN_WIDTH*0.53, SCREEN_WIDTH, 50) AcModel:self.acmodel];
        [self.view addSubview:selectView];
        [self.operatingButton setTitle:@"开始绑定" forState:UIControlStateNormal];
        [self.operatingPromptLabel setText:@"请在门禁读卡器旁边，准备好 IC 卡\n再点击【开始绑定】，在 10 秒内进行绑定"];
        [self.operatingButton setFrame:CGRectMake((SCREEN_WIDTH-123)/2, 64+SCREEN_WIDTH*0.53+50+20, 123, 123)];
        [self.operatingButton cornerRadius:123/2 color:RGB(46, 126, 224)];
    }
    
    [self.operatingPromptLabel setHidden:NO];
    [self.operatingButton setBackgroundColor:RGB(46, 126, 224)];
    [self.operatingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.operatingButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"绑定 IC卡"];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setup];
//    [self showLeftBarButtonItem];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)dealloc {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

-(NSMutableArray *)acModelArray{
    if (!_acModelArray) {
        _acModelArray = [NSMutableArray array];
    }
    return _acModelArray;
}

@end

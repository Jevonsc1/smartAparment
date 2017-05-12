//
//  EntrySearchViewController.h
//  SmartApartment
//
//  Created by Trudian on 17/2/13.
//  Copyright © 2017年 Trudian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDelegateDic.h"

@interface EntrySearchViewController : UIViewController
@property(nonatomic)NSObject<MyDelegateDic> *delegate;
@end

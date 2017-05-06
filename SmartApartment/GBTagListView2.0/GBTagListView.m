//
//  GBTagListView.m
//  升级版流式标签支持点击
//
//  Created by 张国兵 on 15/8/16.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTagListView.h"
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@interface GBTagListView(){
    
    CGFloat _KTagMargin;//左右tag之间的间距
    CGFloat _KBottomMargin;//上下tag之间的间距
    NSInteger _kSelectNum;//实际选中的标签数
    UIButton*_tempBtn;//临时保存对象

}
@end
@implementation GBTagListView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _kSelectNum=0;
        totalHeight=0;
        self.frame=frame;
        _tagArr=[[NSMutableArray alloc]init];
        /**默认是多选模式 */
        self.isSingleSelect=NO;

    }
    return self;
    
}
-(void)setTagWithDictionary:(NSArray *)arr andKey:(NSString *)key{
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=_signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(_canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:MainBlue forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:14*ratio];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:[obj objectForKey:key] forState:UIControlStateNormal];
        
        tagBtn.tag=KBtnTag+idx;
        tagBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [tagBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //        [tagBtn setBackgroundColor:TDRGB(236.0, 236.0, 236.0)];
        //        tagBtn.layer.cornerRadius=5;
        //        tagBtn.layer.borderColor=R_G_B_16(0x818181).CGColor;
        //        tagBtn.layer.borderWidth=0.3;
        //        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14*ratio]};
        CGSize Size_str=[[obj objectForKey:key] sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*3;
        CGRect newRect = CGRectZero;
        
        if(_KTagMargin&&_KBottomMargin){
            
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + _KTagMargin > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + _KBottomMargin);
                totalHeight +=Size_str.height + _KBottomMargin;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + _KTagMargin, previousFrame.origin.y);
                
            }
            [self setHight:self andHight:totalHeight+Size_str.height + _KBottomMargin];
            
            
        }else{
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
                totalHeight +=Size_str.height + BOTTOM_MARGIN;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                
            }
            [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        tagBtn.size = CGSizeMake(tagBtn.size.width+20, tagBtn.size.height);
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        
        UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_right_icon"]];
        
        rightIcon.centerY= tagBtn.height/2;
        [tagBtn addSubview:rightIcon];
        [rightIcon setFrame:CGRectMake(14, 7, 12, 8)];
        rightIcon.hidden =YES;
    }];
    if(_GBbackgroundColor){
        
        self.backgroundColor=_GBbackgroundColor;
        
    }else{
        
        self.backgroundColor=[UIColor whiteColor];
        
    }
}
-(void)setTagWithTagArray:(NSArray*)arr{
    
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
    
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=_signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(_canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:MainBlue forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:14*ratio];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];

        tagBtn.tag=KBtnTag+idx;
        tagBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        [tagBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     
//        [tagBtn setBackgroundColor:TDRGB(236.0, 236.0, 236.0)];
//        tagBtn.layer.cornerRadius=5;
//        tagBtn.layer.borderColor=R_G_B_16(0x818181).CGColor;
//        tagBtn.layer.borderWidth=0.3;
//        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14*ratio]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*3;
        CGRect newRect = CGRectZero;

        if(_KTagMargin&&_KBottomMargin){
            
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + _KTagMargin > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + _KBottomMargin);
                totalHeight +=Size_str.height + _KBottomMargin;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + _KTagMargin, previousFrame.origin.y);
                
            }
            [self setHight:self andHight:totalHeight+Size_str.height + _KBottomMargin];

            
        }else{
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
            
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            
        }
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        tagBtn.size = CGSizeMake(tagBtn.size.width+20, tagBtn.size.height);
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];

        UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_right_icon"]];
        
        rightIcon.centerY= tagBtn.height/2;
        [rightIcon setFrame:CGRectMake(20, 20, 12, 8)];
        
        [tagBtn addSubview:rightIcon];
        
        rightIcon.hidden =YES;
    }];
    if(_GBbackgroundColor){
        
        self.backgroundColor=_GBbackgroundColor;
        
    }else{
        
        self.backgroundColor=[UIColor whiteColor];
        
    }
    

}
-(void)setTagWithSearchType:(NSArray *)arr{
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSString*str, NSUInteger idx, BOOL *stop) {
        
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        
        if(_signalTagColor){
            //可以单一设置tag的颜色
            tagBtn.backgroundColor=_signalTagColor;
        }else{
            //tag颜色多样
            tagBtn.backgroundColor=[UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        }
        if(_canTouch){
            tagBtn.userInteractionEnabled=YES;
            
        }else{
            
            tagBtn.userInteractionEnabled=NO;
        }
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tagBtn.layer.borderWidth = 1;
        tagBtn.layer.cornerRadius = 8;
        tagBtn.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1].CGColor;
        [tagBtn setTitleColor:MainBlue forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:14*ratio];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle:str forState:UIControlStateNormal];
        
        tagBtn.tag=KBtnTag+idx;
        tagBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
//        [tagBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
        
        //        [tagBtn setBackgroundColor:TDRGB(236.0, 236.0, 236.0)];
        //        tagBtn.layer.cornerRadius=5;
        //        tagBtn.layer.borderColor=R_G_B_16(0x818181).CGColor;
        //        tagBtn.layer.borderWidth=0.3;
        //        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:14*ratio]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*3;
        CGRect newRect = CGRectZero;
        
        if(_KTagMargin&&_KBottomMargin){
            
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + _KTagMargin > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + _KBottomMargin);
                totalHeight +=Size_str.height + _KBottomMargin;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + _KTagMargin, previousFrame.origin.y);
                
            }
            [self setHight:self andHight:totalHeight+Size_str.height + _KBottomMargin];
            
            
        }else{
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
                totalHeight +=Size_str.height + BOTTOM_MARGIN;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
                
            }
            [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        tagBtn.size = CGSizeMake(tagBtn.size.width+20, tagBtn.size.height);
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
        
        UIImageView *rightIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"select_right_icon"]];
        
        rightIcon.centerY= tagBtn.height/2;
        [tagBtn addSubview:rightIcon];
        [rightIcon setFrame:CGRectMake(8, 7, 12, 8)];
        rightIcon.hidden =YES;
    }];
    
        
        self.backgroundColor=[UIColor whiteColor];
    
    
}
#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
-(void)tagBtnClick:(UIButton*)button{
    if(_isSingleSelect){
        if(button.selected){
            
            button.selected=!button.selected;
            
        }else{
            
            _tempBtn.selected=NO;
            _tempBtn.backgroundColor=[UIColor whiteColor];
             button.selected=YES;
            _tempBtn=button;
            
        }
        
    }else{
        
        button.selected=!button.selected;
    }
    
    if(button.selected==YES){
        button.backgroundColor=[UIColor orangeColor];
    }else if (button.selected==NO){
        button.backgroundColor=[UIColor whiteColor];
    }
    
    [self didSelectItems];
    
    
}

-(void)didSelectItems{

    NSMutableArray*arr=[[NSMutableArray alloc]init];
    
    for(UIView*view in self.subviews){

        if([view isKindOfClass:[UIButton class]]){

            UIButton*tempBtn=(UIButton*)view;
            tempBtn.enabled=YES;
            if (tempBtn.selected==YES) {
                [arr addObject:_tagArr[tempBtn.tag-KBtnTag]];
                _kSelectNum=arr.count;
                [tempBtn setBackgroundColor:[UIColor whiteColor]];
                tempBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 20, 0, 0);
                NSArray *subviews = tempBtn.subviews;
                
                UIImageView *rightIcon = [subviews lastObject];
                rightIcon.hidden = NO;
                tempBtn.backgroundColor = [UIColor whiteColor];
                tempBtn.layer.borderWidth = 0.5;
                tempBtn.layer.borderColor =TDRGB(46, 126, 224).CGColor;
                tempBtn.layer.cornerRadius = 2;
                [tempBtn setBackgroundImage:nil forState:UIControlStateNormal];
                 [rightIcon setFrame:CGRectMake(8, 7, 12, 8)];
//                [tempBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border"] forState:UIControlStateNormal];
//                [tempBtn setTitleColor:MainBlue forState:UIControlStateNormal];
//                [tempBtn setBackgroundColor:[UIColor whiteColor]];

            }else{
                tempBtn.titleEdgeInsets =UIEdgeInsetsMake(0, 0, 0, 0);
                NSArray *subviews = tempBtn.subviews;
                UIImageView *rightIcon = [subviews lastObject];
                rightIcon.hidden = YES;
                //出入记录的筛选
                if (self.isSearch) {
                    tempBtn.layer.borderWidth = 1;
                    tempBtn.layer.cornerRadius = 8;
                    tempBtn.layer.borderColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1].CGColor;
                    [tempBtn setBackgroundColor:[UIColor whiteColor]];
                    
                    [tempBtn setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1] forState:UIControlStateNormal];
                    
                }else{
                    tempBtn.layer.borderWidth = 0;
                    tempBtn.layer.cornerRadius = 0;
                    
                    [tempBtn setBackgroundImage:[UIImage imageNamed:@"bill_select_border2"] forState:UIControlStateNormal];
                    [tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    if(_kSelectNum==self.canTouchNum){
        
        for(UIView*view in self.subviews){

            UIButton*tempBtn=(UIButton*)view;

         if (tempBtn.selected==YES) {
             tempBtn.enabled=YES;
             
         }else{
             tempBtn.enabled=NO;
             
         }
    }
    }
    self.didselectItemBlock(arr);
}

-(void)setMarginBetweenTagLabel:(CGFloat)Margin AndBottomMargin:(CGFloat)BottomMargin{
    
    _KTagMargin=Margin;
    _KBottomMargin=BottomMargin;

}

@end

//
//  CommentViewController.m
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "CommentViewController.h"
#import "OrderInfo.h"
#import "DBOrder.h"
#import "GoodsInfo.h"
#import "DBComment.h"
#import "CommentInfo.h"
#import "UserInfo.h"
#import "Toast.h"
extern UserInfo *loginUserInfo;
@interface CommentViewController ()

{

    IBOutlet UITextView *_tvInput;
    
    IBOutlet UILabel *_lbNum;
}

- (IBAction)submitComment:(id)sender;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"评论";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    UITapGestureRecognizer *singer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    singer.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:singer];
    NSLog(@"%@",_info);
    NSLog(@"%@",_goodsInfo);

}
-(void)tapAction{
    [_tvInput resignFirstResponder];

    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text length]<=100) {
        _lbNum.textColor=[UIColor darkGrayColor];
        _lbNum.text=[NSString stringWithFormat:@"%li/100",[_tvInput.text length]+1];
    }else{
        _tvInput.text=[_tvInput.text substringToIndex:100];
        _lbNum.textColor=[UIColor redColor];
        _lbNum.text=[NSString stringWithFormat:@"%li/100",[_tvInput.text length]+1];
        
    }
    
    
    return YES;
}

- (IBAction)submitComment:(id)sender {
    NSArray *array=[_info.Order_goods componentsSeparatedByString:@"||"];
    NSMutableString *goodsStr=[NSMutableString string];
    
    for (int i=0; i<array.count; i++) {
        NSString *str=[array objectAtIndex:i];
        
        NSArray *array1=[str componentsSeparatedByString:@","];
        NSString *goodsIdStr=[array1 objectAtIndex:0];
      NSMutableString *mutStr=[NSMutableString stringWithString:str];
        if (_goodsInfo.goods_id==[goodsIdStr intValue]) {
            
           [mutStr replaceCharactersInRange:NSMakeRange(mutStr.length-1, 1) withString:@"1"];
        }
        [goodsStr appendFormat:@"%@",mutStr];
        if (i!=array.count-1) {
            [goodsStr appendString:@"||"];
        }
    }
    NSLog(@"%@",goodsStr);
    _info.Order_goods=goodsStr;
    NSLog(@"%@",_info);
    if ([[DBOrder sharedInfo] updateOrderType:_info]) {
        CommentInfo *info=[[CommentInfo alloc] init];
        NSDate *newDate=[NSDate new];
        
        NSDateFormatter *date=[NSDateFormatter new];
        [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr=[date stringFromDate:newDate];
        info.Comment_time=dateStr;
        info.Comment_id=[[NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]] intValue];
        info.Comment_text=_tvInput.text;
        info.Goods_id=_goodsInfo.goods_id;
        info.user_id=loginUserInfo.user_id;
        
        if([[DBComment sharedInfo] insertOrderInfo:info]){
             NSLog(@"增加评论成功");
            [[Toast sharedToastInfo] hideTime:1 makeText:@"评论成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
       
    }
}
@end

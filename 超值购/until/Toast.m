//
//  Toast.m
//  提示框的弹出（非单例模式）联系-714
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 zhengqing. All rights reserved.
//

#import "Toast.h"
#import "AppDelegate.h"
static Toast *singleInstance=nil;

@implementation Toast
-(void)inputText:(NSString *)text{
    _text=text;
}
+(Toast *)sharedToastInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    
    }
    
    return singleInstance;
}
-(Toast *)hideTime:(int )second makeText:(NSString *)text{
    _text=text;
    
    _duration=second;
    [self show];
    return singleInstance;
}

//-(void)time:(int)duration{
//    _duration=duration;
//}
-(void)show{
    if (!viewIsShow) {
        viewIsShow=YES;
    
      UIFont *font=[UIFont systemFontOfSize:17];
    
    CGRect rect=[_text boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    laMsg=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    laMsg.text=_text;
        laMsg.textColor=[UIColor whiteColor];
        laMsg.numberOfLines=0;
    laMsg.font=font;
    
    toastView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,rect.size.width+20, rect.size.height+20)];
    toastView.backgroundColor=[UIColor blackColor];
    toastView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        toastView.layer.cornerRadius=10.0;
        toastView.layer.borderWidth=1.0;
    [toastView addSubview:laMsg];
    laMsg.center=CGPointMake(toastView.bounds.size.width/2, toastView.bounds.size.height/2);
    AppDelegate *delegate=[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:toastView];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    }else{
        [_timer invalidate];
        UIFont *font=[UIFont systemFontOfSize:17];
        CGRect rect=[_text boundingRectWithSize:CGSizeMake(280, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        [laMsg setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        laMsg.text=_text;
        [toastView setFrame:CGRectMake(0, 0,rect.size.width+20, rect.size.height+20)];
        toastView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        laMsg.center=CGPointMake(toastView.bounds.size.width/2, toastView.bounds.size.height/2);
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hideToast) userInfo:nil repeats:NO];
    }
    
}
-(void)hideToast{
    
    viewIsShow=NO;
    [toastView removeFromSuperview];
    
}
@end

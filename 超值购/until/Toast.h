//
//  Toast.h
//  提示框的弹出（非单例模式）联系-714
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 zhengqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Toast : NSObject
{
    NSString *_text;
   int _duration;
    UIView *toastView;
    UILabel *laMsg;
    NSTimer *_timer;
    BOOL viewIsShow;
}
+(Toast *)sharedToastInfo;
//-(void)inputText:(NSString *)text;
//-(void)time:(int )duration;
//-(void)show;
-(Toast *)hideTime:(int )duration makeText:(NSString *)text;
//-(Toast *)makeText:(NSString *)text;
-(void)show;
//+(Toast *)sharedStudentInfo;
@end

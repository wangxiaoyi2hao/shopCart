//
//  CommentInfo.h
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property(nonatomic,assign)int  Comment_id;
@property(nonatomic,copy)NSString *Comment_text;

@property(nonatomic,copy)NSString *Comment_time;
@property(nonatomic,assign)int Goods_id;
@property(nonatomic,copy)NSString *user_id;

@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *user_head;

@end

//
//  UserInfo.h
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *user_pwd;
@property(nonatomic,assign)double user_balance;
@property(nonatomic,copy)NSString *user_head;
@end

//
//  OrderInfo.h
//  超值购
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property(nonatomic,assign)int  Order_id;
@property(nonatomic,copy)NSString *Order_time;
@property(nonatomic,assign)int Order_type;
@property(nonatomic,copy)NSString *Order_price;
@property(nonatomic,copy)NSString *Order_goods;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,assign)int Address_id;


@end

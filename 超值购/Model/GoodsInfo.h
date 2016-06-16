//
//  GoodsInfo.h
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsInfo : NSObject
@property(nonatomic,assign)int goods_id;
@property(nonatomic,copy)NSString *goods_name;
@property(nonatomic,assign)double goods_price;
@property(nonatomic,copy)NSString *goods_logo;
@property(nonatomic,assign)int type_id;
@property(nonatomic,assign)int Market_id;
@property(nonatomic,copy)NSString *goods_info;
@property(nonatomic,copy)NSString *Market_value;
@property(nonatomic,copy)NSString *Type_value;

@property(nonatomic,assign)int judge_type;

@property(nonatomic,assign)int goodsNum;
@property(nonatomic,assign)BOOL isSelect;
@end

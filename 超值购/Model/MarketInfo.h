//
//  MarketInfo.h
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketInfo : NSObject
@property(nonatomic,assign)int marketId;
@property(nonatomic,copy)NSString *marketName;
@property(nonatomic,strong)NSMutableArray *marketShopArray;
@end

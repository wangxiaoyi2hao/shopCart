//
//  DBShopCar.h
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class GoodsInfo;
@interface DBShopCar : NSObject
{
    sqlite3 *_datebase;
}
+(DBShopCar *)sharedInfo;
-(BOOL)AddShopCar:(int)goodsId;
-(NSString *)carCount;
-(NSMutableArray *)AllShopCar;
-(GoodsInfo *)OrderShopCar:(int )byGoodsId;
-(BOOL)AddShopCarNum:(int)goodsId isAdd:(BOOL)isadd;
-(BOOL)delete:(int )byId;
@end

//
//  DBGoodsInfo.h
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBGoodsInfo : NSObject
{
    sqlite3 *_datebase;
}
+(DBGoodsInfo *)sharedInfo;
-(NSMutableArray *)goodsDetailes:(int )goodsId;
-(NSMutableArray *)goodsImages:(int )goodsId;
-(NSMutableArray *)goodsLikeDetailes:(int )typeId goodsId:(int)byGoodsId;
@end

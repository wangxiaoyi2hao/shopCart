//
//  DBOrder.h
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class OrderInfo;
@interface DBOrder : NSObject
{
    sqlite3 *_datebase;
}
+(DBOrder *)sharedInfo;
-(BOOL)insertOrderInfo:(OrderInfo *)info;
-(NSMutableArray *)orderArray:(int )orderType user:(NSString *)byUserId;
-(BOOL)updateOrderType:(OrderInfo *)info;
-(BOOL)deleteOrderInfo:(OrderInfo *)info;
@end

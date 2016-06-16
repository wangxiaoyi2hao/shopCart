//
//  DBMarket.h
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBMarket : NSObject
{
    sqlite3 *_datebase;
}
+(DBMarket *)sharedInfo;
-(NSMutableArray *)MarketArray;
-(NSMutableArray *)MarketMore:(int )marketId order:(BOOL)orderType;
-(NSMutableArray *)TypeMore:(int )typeId order:(BOOL)orderType;
-(NSMutableArray *)SearchMore:(NSString *)searchStr order:(BOOL)orderType;
@end

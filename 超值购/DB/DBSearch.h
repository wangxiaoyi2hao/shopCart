//
//  DBSearch.h
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBSearch : NSObject
{
    sqlite3 *_datebase;
}
+(DBSearch *)sharedInfo;
-(NSMutableArray *)AllSearchHistory;
-(BOOL)InsertSearchHistory:(NSString *)searchStr;
-(BOOL)deleteSearchHistory;
-(NSString *)selectWebInfo:(int )byGoodsId;
@end

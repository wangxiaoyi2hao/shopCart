//
//  DBMarket.m
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBMarket.h"
#import "MarketInfo.h"
#import "GoodsInfo.h"
#import "MyFile.h"
static DBMarket *singleInstance;

@implementation DBMarket
+(DBMarket *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(NSMutableArray *)MarketArray{
        NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
        sqlite3_stmt *statement;
        NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_market"];
        int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
        if (sqlResult==SQLITE_OK) {
        
            NSLog(@"查询语句编译成功");
            while(sqlite3_step(statement)==SQLITE_ROW) {
                MarketInfo *marketInfo=[[MarketInfo alloc] init];
                
                int MarketId=sqlite3_column_int(statement, 0);
                marketInfo.marketId=MarketId;
                
                char *MarketValue=(char *)sqlite3_column_text(statement, 1);
                if (MarketValue) {
                    marketInfo.marketName=[NSString stringWithUTF8String:MarketValue];
                }
                
                
                sqlite3_stmt *stateGoods;
                NSString *goodsStr=[NSString stringWithFormat:@"SELECT goods_id,goods_name,goods_price,goods_logo,type_id FROM tb_goods WHERE market_id=%i",marketInfo.marketId];
                int sqlGoodsResult=sqlite3_prepare_v2(_datebase, [goodsStr UTF8String], -1, &stateGoods, nil);
                if (sqlGoodsResult==SQLITE_OK) {
                    while(sqlite3_step(stateGoods)==SQLITE_ROW) {
                        GoodsInfo *info=[[GoodsInfo alloc] init];
                        
                        int goodsId=sqlite3_column_int(stateGoods, 0);
                        info.goods_id=goodsId;
                        
                        char *goodsName=(char *)sqlite3_column_text(stateGoods, 1);
                        if (goodsName) {
                            info.goods_name=[NSString stringWithUTF8String:goodsName];
                        }
                        double goodsPrice=sqlite3_column_double(stateGoods, 2);
                        info.goods_price=goodsPrice;
                        char *goodsLogo=(char *)sqlite3_column_text(stateGoods, 3);
                        if (goodsLogo) {
                            info.goods_logo=[NSString stringWithUTF8String:goodsLogo];
                        }
                        int typeId=sqlite3_column_int(stateGoods, 4);
                        info.type_id=typeId;
                        
                        int marketId=sqlite3_column_int(stateGoods, 5);
                        info.Market_id=marketId;
                        char *goodsInfo=(char *)sqlite3_column_text(stateGoods, 6);
                        if (goodsInfo) {
                            info.goods_info=[NSString stringWithUTF8String:goodsInfo];
                        }
                        [marketInfo.marketShopArray addObject:info];
                    }
                }
                
                [mutArray addObject:marketInfo];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_datebase);
    
    
    return mutArray;
}
-(NSMutableArray *)MarketMore:(int )marketId order:(BOOL)orderType{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    NSString *orderStr=[NSString string];
    if (orderType) {
        orderStr=@"DESC";
    }else{
        orderStr=@"ASC";
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT  tb_goods.goods_name,goods_logo,goods_price,market_value,tb_market.market_id,goods_id,tb_goods.type_id FROM tb_goods INNER JOIN tb_market ON tb_goods.market_id=tb_market.market_id WHERE tb_market.market_id=%i ORDER BY goods_price %@",marketId,orderStr];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        GoodsInfo *info=[GoodsInfo new];
        //        NSString *subjectStr=[NSString string];
        char *goodsName=(char *)sqlite3_column_text(statement, 0);
        if (goodsName) {
            info.goods_name=[NSString stringWithUTF8String:goodsName];
        }
        //        int stuNOScoreId=sqlite3_column_int(statement, 2);
        //        info.subjectId=stuNOScoreId;
        char *goodsImage=(char *)sqlite3_column_text(statement, 1);
        if (goodsImage) {
            info.goods_logo=[NSString stringWithUTF8String:goodsImage];
        }
        double goodsPrice=sqlite3_column_double(statement, 2);
        info.goods_price=goodsPrice;
        
        char *marketValue=(char *)sqlite3_column_text(statement, 3);
        if (marketValue) {
            info.Market_value=[NSString stringWithUTF8String:marketValue];
        }
        int goodsId=sqlite3_column_int(statement, 5);
        info.goods_id=goodsId;
        int typeId=sqlite3_column_int(statement, 6);
        info.type_id=typeId;
        [mutArray addObject:info];
        
    }
      sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;

}
-(NSMutableArray *)TypeMore:(int )typeId order:(BOOL)orderType{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    NSString *orderStr=[NSString string];
    if (orderType) {
        orderStr=@"DESC";
    }else{
        orderStr=@"ASC";
    }

    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT  tb_goods.goods_name,goods_logo,goods_price,type_value,tb_type.type_id,goods_id FROM tb_goods INNER JOIN tb_type ON tb_goods.type_id=tb_type.type_id WHERE tb_type.type_id=%i   ORDER BY goods_price %@",typeId,orderStr];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        GoodsInfo *info=[GoodsInfo new];
        //        NSString *subjectStr=[NSString string];
        char *goodsName=(char *)sqlite3_column_text(statement, 0);
        if (goodsName) {
            info.goods_name=[NSString stringWithUTF8String:goodsName];
        }
        //        int stuNOScoreId=sqlite3_column_int(statement, 2);
        //        info.subjectId=stuNOScoreId;
        char *goodsImage=(char *)sqlite3_column_text(statement, 1);
        if (goodsImage) {
            info.goods_logo=[NSString stringWithUTF8String:goodsImage];
        }
        double goodsPrice=sqlite3_column_double(statement, 2);
        info.goods_price=goodsPrice;
        
        char *typeValue=(char *)sqlite3_column_text(statement, 3);
        if (typeValue) {
            info.Type_value=[NSString stringWithUTF8String:typeValue];
        }
        int typeId=sqlite3_column_int(statement, 4);
        info.type_id=typeId;
        int goodsId=sqlite3_column_int(statement, 5);
        info.goods_id=goodsId;
        

        [mutArray addObject:info];
        
    }
      sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
    
}
-(NSMutableArray *)SearchMore:(NSString *)searchStr order:(BOOL)orderType{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    NSString *orderStr=[NSString string];
    if (orderType) {
        orderStr=@"DESC";
    }else{
        orderStr=@"ASC";
    }
    sqlite3_stmt *statement;
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_goods WHERE goods_name LIKE '%%%@%%'  ORDER BY goods_price %@",searchStr,orderStr];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        GoodsInfo *info=[[GoodsInfo alloc] init];
        
        int goodsId=sqlite3_column_int(statement, 0);
        info.goods_id=goodsId;
        
        char *goodsName=(char *)sqlite3_column_text(statement, 1);
        if (goodsName) {
            info.goods_name=[NSString stringWithUTF8String:goodsName];
        }
        double goodsPrice=sqlite3_column_double(statement, 2);
        info.goods_price=goodsPrice;
        char *goodsLogo=(char *)sqlite3_column_text(statement, 3);
        if (goodsLogo) {
            info.goods_logo=[NSString stringWithUTF8String:goodsLogo];
        }
        int typeId=sqlite3_column_int(statement, 4);
        info.type_id=typeId;
        
        int marketId=sqlite3_column_int(statement, 5);
        info.Market_id=marketId;
        char *goodsInfo=(char *)sqlite3_column_text(statement, 6);
        if (goodsInfo) {
            info.goods_info=[NSString stringWithUTF8String:goodsInfo];
        }
        [mutArray addObject:info];
    }
      sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
}

-(BOOL)openDB{
    NSString *pathStr=[MyFile fileByDocumentPath:@"/CZG.sqlite"];
    int openNum=sqlite3_open([pathStr UTF8String], &_datebase);
    if (openNum==SQLITE_OK) {
        NSLog(@"打开数据库成功");
        return YES;
    }else{
        NSLog(@"打开数据库失败");
        return NO;
    }
}

@end

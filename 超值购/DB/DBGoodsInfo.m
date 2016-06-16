//
//  DBGoodsInfo.m
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBGoodsInfo.h"
#import "MyFile.h"
#import "GoodsInfo.h"
static DBGoodsInfo *singleInstance;
@implementation DBGoodsInfo
+(DBGoodsInfo *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(NSMutableArray *)goodsDetailes:(int )goodsId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_goods WHERE goods_id=%i",goodsId];
    
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

-(NSMutableArray *)goodsLikeDetailes:(int )typeId goodsId:(int)byGoodsId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT   goods_id,goods_name,goods_price,goods_logo,tb_goods.type_id  FROM tb_goods INNER JOIN tb_type  WHERE tb_goods.type_id=tb_type.type_id AND tb_goods.type_id=%i AND tb_goods.goods_id!=%i Limit 10",typeId,byGoodsId];
    
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
        
        [mutArray addObject:info];
    }
      sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
    
}


-(NSMutableArray *)goodsImages:(int )goodsId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_img WHERE goods_id=%i",goodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        NSString *imageStr=[NSString string];
        char *goodsImage=(char *)sqlite3_column_text(statement, 1);
        if (goodsImage) {
            imageStr=[NSString stringWithUTF8String:goodsImage];
        }
        [mutArray addObject:imageStr];
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

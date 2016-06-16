//
//  DBShopCar.m
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBShopCar.h"
#import "MyFile.h"
#import "GoodsInfo.h"
static DBShopCar *singleInstance;
@implementation DBShopCar
+(DBShopCar *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(BOOL)AddShopCar:(int)goodsId{
    if (![self openDB]) {
        return NO;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_cart WHERE goods_id=%i",goodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        int shopNum=sqlite3_column_int(statement, 2);
        shopNum++;
        
        NSString *sqlNum=[NSString stringWithFormat:@"UPDATE tb_cart SET num=%i WHERE goods_id=%i",shopNum,goodsId];
        char *error;
         int success=sqlite3_exec(_datebase, [sqlNum UTF8String], nil, nil, &error);
        if (success==SQLITE_OK) {
            NSLog(@"增加数量成功");
            sqlite3_finalize(statement);
            sqlite3_close(_datebase);
            return YES;
        }
    }else{
        NSString *sqlAddStr=[NSString stringWithFormat:@"INSERT INTO tb_cart(goods_id,num)  VALUES(%i,1)",goodsId];

        char *error;
        int success=sqlite3_exec(_datebase, [sqlAddStr UTF8String], nil, nil, &error);
        if (success!=SQLITE_OK) {
            NSLog(@"添加失败");
            NSLog(@"%s",error);
            sqlite3_finalize(statement);
            sqlite3_close(_datebase);
            return NO;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return YES;
}
-(NSString *)carCount{
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT count(*) FROM tb_cart"];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    NSString *countStr=[NSString string];
    while(sqlite3_step(statement)==SQLITE_ROW) {
        char *goodsImage=(char *)sqlite3_column_text(statement, 0);
        if (goodsImage) {
            countStr=[NSString stringWithUTF8String:goodsImage];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return countStr;
}
-(BOOL)AddShopCarNum:(int)goodsId isAdd:(BOOL)isadd{
    if (![self openDB]) {
        return NO;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_cart WHERE goods_id=%i",goodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        int shopNum=sqlite3_column_int(statement, 2);
        if (isadd) {
             shopNum++;
        }else{
             shopNum--;
        }
        NSString *sqlNum=[NSString stringWithFormat:@"UPDATE tb_cart SET num=%i WHERE goods_id=%i",shopNum,goodsId];
        char *error;
        int success=sqlite3_exec(_datebase, [sqlNum UTF8String], nil, nil, &error);
        if (success==SQLITE_OK) {
            NSLog(@"增加数量成功");
            sqlite3_finalize(statement);
            sqlite3_close(_datebase);
            return YES;
        }
    }
    return NO;
}
-(NSMutableArray *)AllShopCar{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT tb_cart.goods_id,goods_logo,goods_name,goods_price,num FROM tb_cart INNER JOIN tb_goods ON tb_goods.goods_id=tb_cart.goods_id"];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }

    while(sqlite3_step(statement)==SQLITE_ROW) {
        GoodsInfo *info=[[GoodsInfo alloc] init];
        
        int goodsId=sqlite3_column_int(statement, 0);
        info.goods_id=goodsId;
        
        char *goodsName=(char *)sqlite3_column_text(statement, 2);
        if (goodsName) {
            info.goods_name=[NSString stringWithUTF8String:goodsName];
        }
        double goodsPrice=sqlite3_column_double(statement, 3);
        info.goods_price=goodsPrice;
        char *goodsLogo=(char *)sqlite3_column_text(statement, 1);
        if (goodsLogo) {
            info.goods_logo=[NSString stringWithUTF8String:goodsLogo];
        }
        int goodsNum=sqlite3_column_int(statement, 4);
        info.goodsNum=goodsNum;
        info.isSelect=NO;
        [mutArray addObject:info];
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
}

-(GoodsInfo *)OrderShopCar:(int )byGoodsId{
    GoodsInfo *info=nil;
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_goods WHERE goods_id=%i",byGoodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        info=[[GoodsInfo alloc] init];
        
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
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return info;
}


-(BOOL)delete:(int )byId{
    if (![self openDB]) {
        return NO;
    }
    NSString *delectStr=[NSString stringWithFormat:@"DELETE FROM tb_cart WHERE goods_id=%i",byId];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"删除购物车失败");
        sqlite3_close(_datebase);
        return NO;
    }
    sqlite3_close(_datebase);
    NSLog(@"删除购物车成功");
    return YES;

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

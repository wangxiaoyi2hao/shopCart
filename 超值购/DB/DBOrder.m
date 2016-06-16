//
//  DBOrder.m
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBOrder.h"
#import "MyFile.h"
#import "OrderInfo.h"
static DBOrder *singleInstance;
@implementation DBOrder
+(DBOrder *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(BOOL)insertOrderInfo:(OrderInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_order(order_id,order_time,order_type,order_price,order_goods,user_id,address_id)  VALUES(%i,'%@',%i,'%@','%@','%@',%i)",info.Order_id,info.Order_time,info.Order_type,info.Order_price,info.Order_goods,info.user_id,info.Address_id];
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
    


}

-(BOOL)deleteOrderInfo:(OrderInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM tb_order WHERE order_id=%i",info.Order_id];
    
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"删除失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;

    
    
    
}


-(BOOL)updateOrderType:(OrderInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_order SET  order_id=%i,order_time='%@',order_type=%i,order_price='%@',order_goods='%@',user_id='%@',address_id=%i WHERE order_id=%i",info.Order_id,info.Order_time,info.Order_type,info.Order_price,info.Order_goods,info.user_id,info.Address_id,info.Order_id];
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
    
    
    
}

-(NSMutableArray *)orderArray:(int )orderType user:(NSString *)byUserId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_order WHERE order_type=%i AND user_id=%@",orderType,byUserId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        
        OrderInfo *info=[OrderInfo new];
        
        int orderId=sqlite3_column_int(statement, 0);
        info.Order_id=orderId;
        
        char *orderTime=(char *)sqlite3_column_text(statement, 1);
        if (orderTime) {
            info.Order_time=[NSString stringWithUTF8String:orderTime];
        }
        int orderType=sqlite3_column_int(statement, 2);
        info.Order_type=orderType;

        char *orderPrcie=(char *)sqlite3_column_text(statement, 3);
        if (orderPrcie) {
            info.Order_price=[NSString stringWithUTF8String:orderPrcie];
        }
        char *orderGoods=(char *)sqlite3_column_text(statement, 4);
        if (orderGoods) {
            info.Order_goods=[NSString stringWithUTF8String:orderGoods];
        }
        char *userId=(char *)sqlite3_column_text(statement, 5);
        if (userId) {
            info.user_id=[NSString stringWithUTF8String:userId];
        }
        int addressId=sqlite3_column_int(statement, 6);
        info.Address_id=addressId;
        
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

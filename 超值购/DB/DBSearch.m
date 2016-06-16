//
//  DBSearch.m
//  超值购
//
//  Created by apple on 15/8/31.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBSearch.h"
#import "MyFile.h"

static DBSearch *singleInstance;
@implementation DBSearch
+(DBSearch *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

-(BOOL)InsertSearchHistory:(NSString *)searchStr{
    if (![self openDB]) {
        return NO;
    }
    NSString *delectStr=[NSString stringWithFormat:@"DELETE  FROM tb_searchHistory WHERE history_value='%@'",searchStr];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"删除搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_searchHistory(history_value)  VALUES('%@')",searchStr];
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"添加搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
    sqlite3_close(_datebase);
    NSLog(@"添加搜索历史成功");
    return YES;
    
}
-(BOOL)deleteSearchHistory{
    if (![self openDB]) {
        return NO;
    }
    NSString *delectStr=[NSString stringWithFormat:@"DELETE  FROM tb_searchHistory "];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"删除搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
       sqlite3_close(_datebase);
    NSLog(@"删除搜索历史成功");
    return YES;
    
}

-(NSMutableArray *)AllSearchHistory{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_searchHistory ORDER BY history_id DESC"];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        NSString *searchStr=[NSString string];
        char *searchName=(char *)sqlite3_column_text(statement, 1);
        if (searchName) {
            searchStr=[NSString stringWithUTF8String:searchName];
        }
        [mutArray addObject:searchStr];
    }
    sqlite3_close(_datebase);
    return mutArray;
}
-(NSString *)selectWebInfo:(int )byGoodsId{
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT  goods_info FROM tb_goods WHERE goods_id=%i",byGoodsId];
    
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

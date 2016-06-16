//
//  DBComment.m
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBComment.h"
#import "MyFile.h"

#import "CommentInfo.h"
static DBComment *singleInstance;
@implementation DBComment
+(DBComment *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(BOOL)insertOrderInfo:(CommentInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_comment(comment_id,comment_text,user_id,goods_id,comment_time) VALUES(%i,'%@','%@',%i,'%@')",info.Comment_id,info.Comment_text,info.user_id,info.Goods_id,info.Comment_time];
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        NSLog(@"%s",error);
        return NO;
        
    }
    sqlite3_close(_datebase);
    return YES;
}
-(NSMutableArray *)CommentArray:(NSString *)byUserId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_comment WHERE user_id='%@'",byUserId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        
        CommentInfo *info=[CommentInfo new];
        
        int commentId=sqlite3_column_int(statement, 0);
        info.Comment_id=commentId;
        
        char *commentText=(char *)sqlite3_column_text(statement, 1);
        if (commentText) {
            info.Comment_text=[NSString stringWithUTF8String:commentText];
        }
        char *userId=(char *)sqlite3_column_text(statement, 2);
        if (userId) {
            info.user_id=[NSString stringWithUTF8String:userId];
        }
        int goodsId=sqlite3_column_int(statement, 3);
        info.Goods_id=goodsId;
    
        char *commentTime=(char *)sqlite3_column_text(statement, 4);
        if (commentTime) {
            info.Comment_time=[NSString stringWithUTF8String:commentTime];
        }
        [mutArray addObject:info];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;

}

-(NSMutableArray *)goodsCommentArray:(int)byGoodsId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT tb_user.user_id,user_name,user_head,tb_comment.comment_time,  tb_comment.comment_text  FROM tb_comment INNER JOIN tb_user  WHERE tb_comment.user_id=tb_user.user_id AND goods_id=%i",byGoodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        
        CommentInfo *info=[CommentInfo new];
        
        
        char *userId=(char *)sqlite3_column_text(statement, 0);
        if (userId) {
            info.user_id=[NSString stringWithUTF8String:userId];
        }
        
        char *userName=(char *)sqlite3_column_text(statement, 1);
        if (userName) {
            info.user_name=[NSString stringWithUTF8String:userName];
        }

        char *userHead=(char *)sqlite3_column_text(statement, 2);
        if (userHead) {
            info.user_head=[NSString stringWithUTF8String:userHead];
        }

        
        char *commentTime=(char *)sqlite3_column_text(statement, 3);
        if (commentTime) {
            info.Comment_time=[NSString stringWithUTF8String:commentTime];
        }
        
        char *commentText=(char *)sqlite3_column_text(statement, 4);
        if (commentText) {
            info.Comment_text=[NSString stringWithUTF8String:commentText];
        }
        
        [mutArray addObject:info];
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
    
}
-(NSString *)countComment:(int)byGoodsId{
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT count(*) FROM tb_comment where goods_id=%i",byGoodsId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    NSString *countStr=[NSString string];
    while(sqlite3_step(statement)==SQLITE_ROW) {
        int commetnNum=sqlite3_column_double(statement, 0);
        countStr=[NSString stringWithFormat:@"%i",commetnNum];
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

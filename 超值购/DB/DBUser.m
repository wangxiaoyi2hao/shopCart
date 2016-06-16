//
//  DBUser.m
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBUser.h"
#import "MyFile.h"
#import "UserInfo.h"
static DBUser *singleInstance;

@implementation DBUser
+(DBUser *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(BOOL)InsertUser:(UserInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"select *from tb_user WHERE user_name='%@'",info.user_name];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return NO;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        sqlite3_finalize(statement);
         sqlite3_close(_datebase);
        NSLog(@"用户名重复");
        return NO;
    }

    
    NSString *delectStr=[NSString stringWithFormat:@"INSERT INTO tb_user  VALUES('%@','%@','%@',%f,'%@')",info.user_id,info.user_name,info.user_pwd,info.user_balance,info.user_head];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"添加用户信息失败");
        NSLog(@"%s",error);
        sqlite3_close(_datebase);
        return NO;
    }
    sqlite3_close(_datebase);
    NSLog(@"添加用户信息成功");
    return YES;

}

-(UserInfo *)loginUser:(NSString *)userName pwd:(NSString *)userPwd{
    UserInfo *info=nil;
    
    if (![self openDB]) {
        return nil;
    }
    
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"select *from tb_user WHERE user_name='%@' And user_pwd='%@'",userName,userPwd];;
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        info=[[UserInfo alloc] init];
        char *userId=(char *)sqlite3_column_text(statement, 0);
        if (userId) {
            info.user_id=[NSString stringWithUTF8String:userId];
        }
        char *userName=(char *)sqlite3_column_text(statement, 1);
        
        if (userName) {
            info.user_name=[NSString stringWithUTF8String:userName];
        }
        
        char *userPwd=(char *)sqlite3_column_text(statement, 2);
        if (userPwd) {
            info.user_pwd=[NSString stringWithUTF8String:userPwd];
        }
        
        double userBalance=sqlite3_column_double(statement, 3);
        info.user_balance=userBalance;
        
        char *userHead=(char *)sqlite3_column_text(statement, 4);
        if (userHead) {
            info.user_head=[NSString stringWithUTF8String:userHead];
        }
        
    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    NSLog(@"获取用户信息成功");
    return info;
    
}
-(BOOL)changePwd:(UserInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_user SET user_id='%@',user_name='%@',user_pwd='%@',user_balance=%f,user_head='%@' WHERE user_id='%@'",info.user_id,info.user_name,info.user_pwd,info.user_balance,info.user_head,info.user_id];
    
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
}
-(BOOL)changeBanlance:(UserInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_user SET user_id='%@',user_name='%@',user_pwd='%@',user_balance=%f,user_head='%@' WHERE user_id='%@'",info.user_id,info.user_name,info.user_pwd,info.user_balance,info.user_head,info.user_id];
    
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
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

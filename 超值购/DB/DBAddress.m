//
//  DBAddress.m
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "DBAddress.h"
#import "MyFile.h"
#import "AddressInfo.h"
#import "AddressIndex.h"
static DBAddress *singleInstance;


@implementation DBAddress
+(DBAddress *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(NSMutableArray *)AddressArray:(NSString* )byUserId{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_address where user_id=%@",byUserId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        AddressInfo *info=[[AddressInfo alloc] init];
        
        int addressId=sqlite3_column_int(statement, 0);
        info.Address_id=addressId;
        
        char *addressName=(char *)sqlite3_column_text(statement, 1);
        if (addressName) {
            info.Address_name=[NSString stringWithUTF8String:addressName];
        }
        char *addressPhone=(char *)sqlite3_column_text(statement, 2);
        if (addressPhone) {
            info.Address_phone=[NSString stringWithUTF8String:addressPhone];
        }
        char *addressProvince=(char *)sqlite3_column_text(statement, 3);
        if (addressProvince) {
            info.Address_province=[NSString stringWithUTF8String:addressProvince];
        }
        char *addressStreet=(char *)sqlite3_column_text(statement, 4);
        if (addressStreet) {
            info.Address_street=[NSString stringWithUTF8String:addressStreet];
        }
        char *addressUserId=(char *)sqlite3_column_text(statement, 5);
        if (addressUserId) {
            info.Address_userid=[NSString stringWithUTF8String:addressUserId];
        }
        int addressIsDefault=sqlite3_column_int(statement, 6);
        info.AddressIsdefault=addressIsDefault;
        
        char *addressCity=(char *)sqlite3_column_text(statement, 7);
        if (addressCity) {
            info.Address_city=[NSString stringWithUTF8String:addressCity];
        }
        char *addressDistrict=(char *)sqlite3_column_text(statement, 8);
        if (addressDistrict) {
            info.Address_district=[NSString stringWithUTF8String:addressDistrict];
        }
        [mutArray addObject:info];
    }
        sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return mutArray;
    }

-(AddressInfo *)getAddressIndex:(int )byAddressId userId:(NSString *)ByUserId{
    AddressInfo *indexInfo=nil;
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"select province_index,city_index,count_index from tb_address WHERE address_id=%i AND user_id=%@",byAddressId,ByUserId];
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        indexInfo=[[AddressInfo alloc] init];

        int province=sqlite3_column_int(statement, 0);
        indexInfo.province=province;
        int city=sqlite3_column_int(statement, 1);
        indexInfo.city=city;
        int county=sqlite3_column_int(statement, 2);
        indexInfo.county=county;

    }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return indexInfo;
    
}
-(BOOL)updateAddressIndex:(AddressInfo *)info AddressIndex:(int )byAddressId{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_address set province_index=%i,city_index=%i,count_index=%i WHERE address_id=%i ",info.province,info.city,info.county,byAddressId];
    
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
    
}
-(AddressInfo *)AddressInfoArray:(NSString* )byUserId addressId:(int )byAddressId{
    AddressInfo *info=nil;
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_address where address_id=%i AND user_id=%@",byAddressId,byUserId];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    if(sqlite3_step(statement)==SQLITE_ROW) {
        info=[[AddressInfo alloc] init];
        
        int addressId=sqlite3_column_int(statement, 0);
        info.Address_id=addressId;
        
        char *addressName=(char *)sqlite3_column_text(statement, 1);
        if (addressName) {
            info.Address_name=[NSString stringWithUTF8String:addressName];
        }
        char *addressPhone=(char *)sqlite3_column_text(statement, 2);
        if (addressPhone) {
            info.Address_phone=[NSString stringWithUTF8String:addressPhone];
        }
        char *addressProvince=(char *)sqlite3_column_text(statement, 3);
        if (addressProvince) {
            info.Address_province=[NSString stringWithUTF8String:addressProvince];
        }
        char *addressStreet=(char *)sqlite3_column_text(statement, 4);
        if (addressStreet) {
            info.Address_street=[NSString stringWithUTF8String:addressStreet];
        }
        char *addressUserId=(char *)sqlite3_column_text(statement, 5);
        if (addressUserId) {
            info.Address_userid=[NSString stringWithUTF8String:addressUserId];
        }
        int addressIsDefault=sqlite3_column_int(statement, 6);
        info.AddressIsdefault=addressIsDefault;
        
        char *addressCity=(char *)sqlite3_column_text(statement, 7);
        if (addressCity) {
            info.Address_city=[NSString stringWithUTF8String:addressCity];
        }
        char *addressDistrict=(char *)sqlite3_column_text(statement, 8);
        if (addressDistrict) {
            info.Address_district=[NSString stringWithUTF8String:addressDistrict];
        }
           }
    sqlite3_finalize(statement);
    sqlite3_close(_datebase);
    return info;
}



-(BOOL)changeIsDufault:(AddressInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_address SET isdefault=%i WHERE address_id=%i",info.AddressIsdefault,info.Address_id];

    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
    
}
-(BOOL)insertInfo:(AddressInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_address(name,phone,province,street,user_id,isdefault,city,district,province_index,city_index,count_index)  VALUES('%@','%@','%@','%@','%@',%i,'%@','%@',%i,%i,%i)",info.Address_name,info.Address_phone,info.Address_province,info.Address_street,info.Address_userid,info.AddressIsdefault,info.Address_city,info.Address_district,info.province,info.city,info.county];
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
   
    sqlite3_close(_datebase);
    return YES;
    
}
-(BOOL)insertAddressIndex:(AddressInfo *)info insertIndex:(int )byAddressId userId:(NSString *)ByUserId{//插入地址对应的下表
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"insert into tb_address(address_id,province_index,city_index,count_index,user_id) VALUES(%i,%i,%i,%i,'%@')",byAddressId,info.province,info.city,info.county,ByUserId];
    char *error;
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"修改密码信息失败");
        return NO;
    }
    sqlite3_close(_datebase);
    return YES;
    
}

-(BOOL)changeAddressInfo:(AddressInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"update tb_address SET name='%@',phone='%@',province='%@',street='%@',user_id='%@',isdefault=%i,city='%@',district='%@',province_index=%i,city_index=%i,count_index=%i WHERE address_id=%i",info.Address_name,info.Address_phone,info.Address_province,info.Address_street,info.Address_userid,info.AddressIsdefault,info.Address_city,info.Address_district,info.province,info.city,info.county,info.Address_id];
    
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
-(BOOL)DeleteAddressInfo:(AddressInfo *)info{
    if (![self openDB]) {
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"DELETE FROM tb_address WHERE address_id=%i",info.Address_id];
    
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

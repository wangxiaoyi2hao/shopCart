//
//  DBAddress.h
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class AddressInfo;
@class AddressIndex;
@interface DBAddress : NSObject
{
    sqlite3 *_datebase;
}
+(DBAddress *)sharedInfo;
-(NSMutableArray *)AddressArray:(NSString* )byUserId;
-(BOOL)changeIsDufault:(AddressInfo *)info;
-(BOOL)changeAddressInfo:(AddressInfo *)info;
-(BOOL)DeleteAddressInfo:(AddressInfo *)info;
-(BOOL)insertInfo:(AddressInfo *)info;


-(BOOL)insertAddressIndex:(AddressInfo *)info insertIndex:(int )byAddressId userId:(NSString *)ByUserId;
-(AddressInfo *)getAddressIndex:(int )byAddressId userId:(NSString *)ByUserId;
-(BOOL)updateAddressIndex:(AddressInfo *)info AddressIndex:(int )byAddressId;

-(AddressInfo *)AddressInfoArray:(NSString* )byUserId addressId:(int )byAddressId;


@end

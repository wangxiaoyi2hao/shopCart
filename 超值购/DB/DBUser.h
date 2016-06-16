//
//  DBUser.h
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class UserInfo;
@interface DBUser : NSObject
{
    sqlite3 *_datebase;
}
+(DBUser *)sharedInfo;
-(BOOL)InsertUser:(UserInfo *)info;
-(UserInfo *)loginUser:(NSString *)userName pwd:(NSString *)userPwd;
-(BOOL)changePwd:(UserInfo *)info;
-(BOOL)changeBanlance:(UserInfo *)info;
@end

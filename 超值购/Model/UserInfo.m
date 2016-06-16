//
//  UserInfo.m
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_user_name forKey:@"_user_name"];
    [aCoder encodeObject:_user_pwd forKey:@"_user_pwd"];
    [aCoder encodeObject:_user_id forKey:@"_user_id"];
    [aCoder encodeDouble:_user_balance forKey:@"_user_balance"];
    [aCoder encodeObject:_user_head forKey:@"_user_head"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _user_name=[aDecoder decodeObjectForKey:@"_user_name"];
        _user_pwd=[aDecoder decodeObjectForKey:@"_user_pwd"];
        _user_id=[aDecoder decodeObjectForKey:@"_user_id"];
        _user_balance=[aDecoder decodeDoubleForKey:@"_user_balance"];
        _user_head=[aDecoder decodeObjectForKey:@"_user_head"];
        
        
    }
    
    return self;
}

@end

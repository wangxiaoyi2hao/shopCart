//
//  AddressIndex.m
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "AddressIndex.h"
//static AddressIndex *singleInstance;
@implementation AddressIndex
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInt:_province forKey:@"address_province"];
       [aCoder encodeInt:_city forKey:@"address_city"];
        [aCoder encodeInt:_county forKey:@"address_county"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _province=[aDecoder decodeIntForKey:@"address_province"];
        _city=[aDecoder decodeIntForKey:@"address_city"];
        _county=[aDecoder decodeIntForKey:@"address_county"];
               
    }
    
    return self;
}


@end

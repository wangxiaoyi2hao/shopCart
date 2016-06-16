//
//  AddressInfo.h
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject
@property(nonatomic,assign)int  Address_id;
@property(nonatomic,copy)NSString *Address_name;
@property(nonatomic,copy)NSString *Address_phone;
@property(nonatomic,copy)NSString *Address_province;
@property(nonatomic,copy)NSString *Address_street;
@property(nonatomic,copy)NSString *Address_userid;
@property(nonatomic,assign)BOOL AddressIsdefault;
@property(nonatomic,copy)NSString *Address_city;
@property(nonatomic,copy)NSString *Address_district;

@property(nonatomic,assign)int province;
@property(nonatomic,assign)int city;
@property(nonatomic,assign)int county;


@end

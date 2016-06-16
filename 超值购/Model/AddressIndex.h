//
//  AddressIndex.h
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressIndex : NSObject<NSCoding>
//+(AddressIndex *)sharedInfo;


@property(nonatomic,assign)int province;
@property(nonatomic,assign)int city;
@property(nonatomic,assign)int county;


@end

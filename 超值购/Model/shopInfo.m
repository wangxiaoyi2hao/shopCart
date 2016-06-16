//
//  shopInfo.m
//  tableView购物车联系-722
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 zhengqing. All rights reserved.
//

#import "shopInfo.h"

@implementation shopInfo
-(id)initWithData:(BOOL)imageChoose imgTitle:(NSString *)imageTitle lbCount:(NSString *)lableCount lbPrice:(float)lablePrice{
    if (self=[super init]) {
        _imageChoose=imageChoose;
        _imageTitle=imageTitle;
        _lableCount=lableCount;
        _lablePrice=lablePrice;
    }
    return self;
}
@end

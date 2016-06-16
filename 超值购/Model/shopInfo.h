//
//  shopInfo.h
//  tableView购物车联系-722
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 zhengqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shopInfo : NSObject
@property (nonatomic,assign)BOOL imageChoose;
@property(nonatomic,strong)NSString *imageTitle;
@property(nonatomic,strong)NSString *lableCount;
@property(nonatomic,assign)float lablePrice;
@property(nonatomic,assign)int lableNum;
-(id)initWithData:(BOOL)imageChoose imgTitle:(NSString *)imageTitle lbCount:(NSString *)lableCount lbPrice:(float)lablePrice;



@end

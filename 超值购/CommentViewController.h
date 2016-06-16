//
//  CommentViewController.h
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderInfo;
@class GoodsInfo;
@interface CommentViewController : UIViewController
@property(nonatomic,strong)OrderInfo *info;
@property(nonatomic,strong)GoodsInfo *goodsInfo;
@end

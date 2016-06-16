//
//  OrderDetailsViewController.h
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderInfo;
@interface OrderDetailsViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSMutableArray *orderArray;
@property(nonatomic,assign)float generalPrice;
@property(nonatomic,strong)OrderInfo *info;
@property(nonatomic,copy)NSString *judgeTypeStr;
@end

//
//  ShopInfoViewController.h
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchViewController.h"
@interface ShopInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SearchDelegate>
@property(nonatomic,assign)int MarketId;
@property(nonatomic,assign)int TypeId;
@property(nonatomic,copy)NSString *LikeStr;
@end

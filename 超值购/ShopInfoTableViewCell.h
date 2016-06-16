//
//  ShopInfoTableViewCell.h
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopInfoTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UIImageView *goodsInfoImage;
@property(nonatomic,strong)IBOutlet UILabel *goodsInfoName;
@property(nonatomic,strong)IBOutlet UILabel *goodsInfoPrice;
@end

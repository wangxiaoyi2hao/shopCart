//
//  OrderTableViewCell.h
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lbOrderId;
@property(nonatomic,weak)IBOutlet UILabel *lbOrderPrice;
@property(nonatomic,weak)IBOutlet UILabel *lbOrderTime;
@property(nonatomic,weak)IBOutlet UILabel *lbOrderType;
@property(nonatomic,weak)IBOutlet UIButton *btnOrder;
@property(nonatomic,weak)IBOutlet UIButton *btnJudge;
@property(nonatomic,weak)IBOutlet UIImageView *imgJudge;
@end

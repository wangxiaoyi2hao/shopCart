//
//  addTableViewCell.h
//  tableView购物车-721
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 zhengqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UIImageView *viewChoose;
@property(nonatomic,strong)IBOutlet UIImageView *viewTitle;
@property(nonatomic,strong)IBOutlet UILabel *lbCount;
@property(nonatomic,strong)IBOutlet UILabel *lbNum;
@property(nonatomic,strong)IBOutlet UILabel *lbPrice;
@property(nonatomic,strong)IBOutlet UIButton *btnJia;
@property(nonatomic,strong)IBOutlet UIButton *btnJian;
@property(nonatomic,strong)IBOutlet UIButton *btnChoose;
@end

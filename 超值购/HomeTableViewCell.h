//
//  HomeTableViewCell.h
//  超值购-项目
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property(nonatomic,strong)IBOutlet UILabel *lbPrice;
@property(nonatomic,strong)IBOutlet UILabel *lbInfo;
@property(nonatomic,strong)IBOutlet UIImageView *imageInfo;
@property(nonatomic,strong)IBOutlet UILabel *lbPrice1;
@property(nonatomic,strong)IBOutlet UILabel *lbInfo1;
@property(nonatomic,strong)IBOutlet UIImageView *imageInfo1;
@property(nonatomic,strong)IBOutlet UILabel *lbHideen;
@property(nonatomic,strong)IBOutlet UILabel *lbHideen1;
@property(nonatomic,strong)IBOutlet UIButton *btnDetails;
@property(nonatomic,strong)IBOutlet UIButton *btnDetails1;
@end

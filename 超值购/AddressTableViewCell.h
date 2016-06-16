//
//  AddressTableViewCell.h
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell

@property(nonatomic,strong)IBOutlet UILabel *lbName;
@property(nonatomic,strong)IBOutlet UILabel *lbPhone;
@property(nonatomic,strong)IBOutlet UILabel *lbAddress;
@property(nonatomic,strong)IBOutlet UIImageView *IsImage;
@property(nonatomic,strong)IBOutlet UIButton *btnDelete;
@property(nonatomic,strong)IBOutlet UIButton *btnEdit;
@end

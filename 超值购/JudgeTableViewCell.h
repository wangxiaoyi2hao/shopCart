//
//  JudgeTableViewCell.h
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JudgeTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView *imageTitle;
@property(nonatomic,weak)IBOutlet UILabel *lbName;
@property(nonatomic,weak)IBOutlet UILabel *lbcontent;
@property(nonatomic,weak)IBOutlet UILabel *lbTime;

@end

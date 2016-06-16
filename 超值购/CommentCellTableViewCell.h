//
//  CommentCellTableViewCell.h
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCellTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *lbCommentContent;
@property(nonatomic,weak)IBOutlet UILabel *lbGoodsPrice;
@property(nonatomic,weak)IBOutlet UILabel *lbCommentTime;
@property(nonatomic,weak)IBOutlet UILabel *lbGoodsInfo;
@property(nonatomic,weak)IBOutlet UIImageView *lbImgageTitle;
@end

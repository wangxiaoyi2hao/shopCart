//
//  DBComment.h
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class CommentInfo;
@interface DBComment : NSObject
{
    sqlite3 *_datebase;
}
+(DBComment *)sharedInfo;
-(BOOL)insertOrderInfo:(CommentInfo *)info;
-(NSMutableArray *)CommentArray:(NSString *)byUserId;
-(NSMutableArray *)goodsCommentArray:(int)byGoodsId;
-(NSString *)countComment:(int)byGoodsId;
@end

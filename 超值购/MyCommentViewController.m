//
//  MyCommentViewController.m
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "MyCommentViewController.h"
#import "DBComment.h"
#import "CommentInfo.h"
#import "UserInfo.h"
#import "CommentCellTableViewCell.h"
#import "DBGoodsInfo.h"
#import "GoodsInfo.h"
extern UserInfo *loginUserInfo;
@interface MyCommentViewController ()
{
    NSMutableArray *commentArray;
}
@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    commentArray=[[DBComment sharedInfo] CommentArray:loginUserInfo.user_id];
    self.title=@"我的评论";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 131;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    CommentCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"CommentCellTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    CommentInfo *info=[commentArray objectAtIndex:indexPath.row];
    cell.lbCommentContent.text=info.Comment_text;
    cell.lbCommentTime.text=info.Comment_time;
    NSMutableArray *goodsInfo=[[DBGoodsInfo sharedInfo] goodsDetailes:info.Goods_id];
    GoodsInfo *goods=[goodsInfo objectAtIndex:0];
    cell.lbImgageTitle.image=[UIImage imageNamed:goods.goods_logo];
    cell.lbGoodsInfo.text=goods.goods_name;
    cell.lbGoodsPrice.text=[NSString stringWithFormat:@"%.2f",goods.goods_price];
    
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

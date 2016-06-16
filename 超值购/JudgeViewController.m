//
//  JudgeViewController.m
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "JudgeViewController.h"
#import "JudgeTableViewCell.h"
#import "DBComment.h"
#import "CommentInfo.h"
#import "UserInfo.h"
#import "MyFile.h"
extern UserInfo *loginUserInfo;
@interface JudgeViewController ()
{

    NSMutableArray *commentArray;
}
@end

@implementation JudgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"评论列表";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    
    NSDate *newDate=[NSDate new];
//    NSString *newStr=[NSString stringWithFormat:@"%.2f",[newDate timeIntervalSince1970]];
    NSDateFormatter *date=[NSDateFormatter new];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr=[date stringFromDate:newDate];
    
    NSLog(@"===%@",dateStr);
    commentArray=[[DBComment sharedInfo] goodsCommentArray:_goodsId];
    
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 89;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    JudgeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"JudgeTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    CommentInfo *info=[commentArray objectAtIndex:indexPath.row];
    cell.lbcontent.text=info.Comment_text;
    cell.lbName.text=info.user_name;
    cell.lbTime.text=info.Comment_time;
    NSString *imagePath=[MyFile fileByDocumentPath:[NSString stringWithFormat:@"/UserHead/%@",info.user_head]];
    if ([info.user_head isEqualToString:@""]) {
        imagePath=@"headImg";
    }
    cell.imageTitle.image=[UIImage imageNamed:imagePath];

  
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

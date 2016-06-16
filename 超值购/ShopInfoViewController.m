//
//  ShopInfoViewController.m
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopInfoTableViewCell.h"
#import "ShopDetailsViewController.h"
#import "DBMarket.h"
#import "GoodsInfo.h"
@interface ShopInfoViewController ()
{

    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_lbMarket;
    
    IBOutlet UILabel *_lbMarketNum;
    IBOutlet UIView *_viewHead;
    NSMutableArray *marketArray;
    BOOL isOrder;
    IBOutlet UIButton *btnOrder;
}
- (IBAction)btnOrderAction:(id)sender;

@end

@implementation ShopInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    }
-(void)viewWillAppear:(BOOL)animated{
    if (_MarketId!=0) {
        marketArray=[[DBMarket sharedInfo] MarketMore:_MarketId order:isOrder];
        GoodsInfo *goods=[marketArray objectAtIndex:0];
        self.title=[NSString stringWithFormat:@"%@",goods.Market_value];
        _lbMarket.text=[NSString stringWithFormat:@"\"%@\"",goods.Market_value];
        _lbMarketNum.text=[NSString stringWithFormat:@"共%li条记录",marketArray.count];
    }
    if (_TypeId!=0) {
        marketArray=[[DBMarket sharedInfo] TypeMore:_TypeId order:isOrder];
        GoodsInfo *goods=[marketArray objectAtIndex:0];
        self.title=[NSString stringWithFormat:@"%@",goods.Type_value];
        _lbMarket.text=[NSString stringWithFormat:@"\"%@\"",goods.Type_value];
        _lbMarketNum.text=[NSString stringWithFormat:@"共%li条记录",marketArray.count];
    }
    if (_LikeStr!=nil) {
        marketArray=[[DBMarket sharedInfo] SearchMore:_LikeStr order:isOrder];
        //        GoodsInfo *goods=[marketArray objectAtIndex:0];
        self.title=[NSString stringWithFormat:@"%@",_LikeStr];
        _lbMarket.text=[NSString stringWithFormat:@"\"%@\"",_LikeStr];
        _lbMarketNum.text=[NSString stringWithFormat:@"共%li条记录",marketArray.count];
    }
    [_tableView reloadData];
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _viewHead;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 116;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return marketArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    ShopInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"ShopInfoTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    GoodsInfo *info=[marketArray objectAtIndex:indexPath.row];
    cell.goodsInfoImage.image=[UIImage imageNamed:info.goods_logo];
    cell.goodsInfoName.text=info.goods_name;
    cell.goodsInfoPrice.text=[NSString stringWithFormat:@"%.2f",info.goods_price];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsInfo *info=[marketArray objectAtIndex:indexPath.row];
    ShopDetailsViewController *controller=[[ShopDetailsViewController alloc] init];
    controller.info=info;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)btnOrderAction:(id)sender {
    
    if (!isOrder) {
        isOrder=YES;
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"icon_sort1"] forState:UIControlStateNormal];
    }else{
        isOrder=NO;
        [btnOrder setBackgroundImage:[UIImage imageNamed:@"icon_sort2"] forState:UIControlStateNormal];
    }
    if (_MarketId!=0) {
        marketArray=[[DBMarket sharedInfo] MarketMore:_MarketId order:isOrder];
    }
    if (_TypeId!=0) {
        marketArray=[[DBMarket sharedInfo] TypeMore:_TypeId order:isOrder];
    }
    if (_LikeStr!=nil) {
        marketArray=[[DBMarket sharedInfo] SearchMore:_LikeStr order:isOrder];
    }
    [_tableView reloadData];
}
@end

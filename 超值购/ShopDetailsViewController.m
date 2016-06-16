//
//  ShopDetailsViewController.m
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "ShopDetailsViewController.h"
#import "ShopInfoTableViewCell.h"
#import "ShopInfoWebViewController.h"
#import "JudgeViewController.h"
#import "DBGoodsInfo.h"
#import "GoodsInfo.h"
#import "DBShopCar.h"
#import "ShopViewController.h"
#import "Toast.h"
#import "ShopViewController1.h"
#import "DBComment.h"
#define SCREEN_WIHTE [UIScreen mainScreen].bounds.size.width
@interface ShopDetailsViewController ()
{
    IBOutlet UIScrollView *_scrollView;

    
    IBOutlet UITableView *_tableView;
    IBOutlet UILabel *_lbGoodsInfo;
    
    IBOutlet UILabel *_lbGoodsPrice;
    IBOutlet UIImageView *_imageBox3;
    
    IBOutlet UIImageView *_imageBox2;
    IBOutlet UILabel *_lbNum;
    IBOutlet UIView *_viewHead;
    NSMutableArray *GoodsImageArray;
    NSMutableArray *GoodsLikeArray;
    NSMutableArray *GoodsShowLike;
    UIImageView *imageView;
    UILabel *lb;
    
    IBOutlet UIImageView *_imageBox1;
    IBOutlet UILabel *_lbCommentNum;
    
}
- (IBAction)AddShopCar:(id)sender;

- (IBAction)shopInfoWebAction:(id)sender;
- (IBAction)JudgeAction:(id)sender;


@end

@implementation ShopDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"商品详情";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 26, 22)];
    [rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_cart_bg"] forState:UIControlStateNormal];
    rightBtn.showsTouchWhenHighlighted = YES;
    imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, -2, 14, 14)];
    imageView.image=[UIImage imageNamed:@"nav_cart_num"];
    lb=[[UILabel alloc] initWithFrame:CGRectMake(4, 2, 10, 10)];
    NSString *numCar=[[DBShopCar sharedInfo] carCount];
    if (![numCar isEqualToString:@"0"]) {
        lb.text=numCar;
        lb.font=[UIFont systemFontOfSize:10];
        lb.textColor=[UIColor whiteColor];
      
    }else{
        imageView.hidden=YES;
    }
    [imageView addSubview:lb];
    [rightBtn addSubview:imageView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    GoodsImageArray=[[DBGoodsInfo sharedInfo] goodsImages:_info.goods_id];
    int page=(int)GoodsImageArray.count;
    _scrollView.contentSize=CGSizeMake(SCREEN_WIHTE*page, 320);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    for (int i=0; i<page; i++) {
        NSString *imageStr=[GoodsImageArray objectAtIndex:i];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageStr]];
        [image setFrame:CGRectMake(SCREEN_WIHTE*i, 0, SCREEN_WIHTE, 320)];
        [_scrollView addSubview:image];
    }
    
    _lbCommentNum.text=[NSString stringWithFormat:@"以有%@人评价",[[DBComment sharedInfo] countComment:_info.goods_id]];
    _lbGoodsInfo.text=_info.goods_name;
    _lbGoodsPrice.text=[NSString stringWithFormat:@"￥%.2f",_info.goods_price];
    
    _lbNum.text=[NSString stringWithFormat:@"1/%li",GoodsImageArray.count];
    [self loadLikeArray];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextClick{

    ShopViewController1 *controller=[[ShopViewController1 alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)loadLikeArray{
    NSLog(@"%i,%i",_info.type_id,_info.goods_id);
    GoodsLikeArray=[[DBGoodsInfo sharedInfo] goodsLikeDetailes:_info.type_id goodsId:_info.goods_id];
    int like1=arc4random()%GoodsLikeArray.count;
    GoodsInfo *info1=[GoodsLikeArray objectAtIndex:like1];
    GoodsShowLike=[NSMutableArray array];
    [GoodsShowLike addObject:info1];
    [GoodsLikeArray removeObjectAtIndex:like1];
    
    int like2=arc4random()%GoodsLikeArray.count;
    GoodsInfo *info2=[GoodsLikeArray objectAtIndex:like2];
    [GoodsShowLike addObject:info2];
    [GoodsLikeArray removeObjectAtIndex:like2];
    
    int like3=arc4random()%GoodsLikeArray.count;
    GoodsInfo *info3=[GoodsLikeArray objectAtIndex:like3];
    [GoodsShowLike addObject:info3];
    [GoodsLikeArray removeObjectAtIndex:like3];
    for (int i=0; i<GoodsShowLike.count; i++) {
        GoodsInfo *info=[GoodsShowLike objectAtIndex:i];
        if (i==0) {
            UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageBox1.bounds.size.width-2, _imageBox1.bounds.size.height-2)];
            image1.image=[UIImage imageNamed:info.goods_logo];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(_imageBox1.frame.origin.x, 528, 80, 80)];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            
            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox1.frame.origin.x, 613, 82, 36)];
            label1.text=info.goods_name;
            label1.font=[UIFont systemFontOfSize:12];
            label1.numberOfLines=0;
            label1.textColor=[UIColor darkGrayColor];
            
            UILabel *labelPrice1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox1.frame.origin.x, 650, 82, 19)];
            labelPrice1.text=[NSString stringWithFormat:@"%.2f",info.goods_price];
            labelPrice1.font=[UIFont systemFontOfSize:13];
            labelPrice1.textColor=[UIColor redColor];
            [_imageBox1 addSubview:image1];
            [_viewHead addSubview:label1];
            [_viewHead addSubview:labelPrice1];
            [_viewHead addSubview:btn];

        }
        if (i==1) {
            UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageBox2.bounds.size.width-2, _imageBox2.bounds.size.height-2)];
            image1.image=[UIImage imageNamed:info.goods_logo];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(_imageBox2.frame.origin.x, 528, 80, 80)];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            
            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox2.frame.origin.x, 613, 82, 36)];
            label1.text=info.goods_name;
            label1.font=[UIFont systemFontOfSize:12];
            label1.numberOfLines=0;
            label1.textColor=[UIColor darkGrayColor];
            
            UILabel *labelPrice1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox2.frame.origin.x, 650, 82, 19)];
            labelPrice1.text=[NSString stringWithFormat:@"%.2f",info.goods_price];
            labelPrice1.font=[UIFont systemFontOfSize:13];
            labelPrice1.textColor=[UIColor redColor];
            [_imageBox2 addSubview:image1];
            [_viewHead addSubview:label1];
            [_viewHead addSubview:labelPrice1];
            [_viewHead addSubview:btn];
            
        }
        if (i==2) {
            UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageBox3.bounds.size.width-2, _imageBox3.bounds.size.height-2)];
            image1.image=[UIImage imageNamed:info.goods_logo];
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(_imageBox3.frame.origin.x, 528, 80, 80)];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            
            UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox3.frame.origin.x, 613, 82, 36)];
            label1.text=info.goods_name;
            label1.font=[UIFont systemFontOfSize:12];
            label1.numberOfLines=0;
            label1.textColor=[UIColor darkGrayColor];
            
            UILabel *labelPrice1=[[UILabel alloc] initWithFrame:CGRectMake(_imageBox3.frame.origin.x, 650, 82, 19)];
            labelPrice1.text=[NSString stringWithFormat:@"%.2f",info.goods_price];
            labelPrice1.font=[UIFont systemFontOfSize:13];
            labelPrice1.textColor=[UIColor redColor];
            [_imageBox3 addSubview:image1];
            [_viewHead addSubview:label1];
            [_viewHead addSubview:labelPrice1];
            [_viewHead addSubview:btn];
            
        }

        
    }
}
-(void)clickAction:(UIButton *)sender{
        GoodsInfo *info=[GoodsShowLike objectAtIndex:sender.tag];
        ShopDetailsViewController *controller=[[ShopDetailsViewController alloc] init];
        controller.info=info;
        [self.navigationController pushViewController:controller animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 755;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _viewHead;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    ShopInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"ShopInfoTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int a=scrollView.contentOffset.x/SCREEN_WIHTE;
    _lbNum.text=[NSString stringWithFormat:@"%i/%li",a+1,GoodsImageArray.count];
}


- (IBAction)AddShopCar:(id)sender {
    [[DBShopCar sharedInfo] AddShopCar:_info.goods_id];
    NSString *numCar=[[DBShopCar sharedInfo] carCount];
    lb.text=numCar;
    lb.font=[UIFont systemFontOfSize:10];
    lb.textColor=[UIColor whiteColor];

    imageView.hidden=NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAction" object:nil];

    
    [[Toast sharedToastInfo] hideTime:1 makeText:@"添加购物车成功"];
}

- (IBAction)shopInfoWebAction:(id)sender {
    ShopInfoWebViewController *controller=[[ShopInfoWebViewController alloc] init];
    controller.goodsId=_info.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)JudgeAction:(id)sender {
    JudgeViewController *controller=[[JudgeViewController alloc] init];
    controller.goodsId=_info.goods_id;
    [self.navigationController pushViewController:controller animated:YES];
}
@end

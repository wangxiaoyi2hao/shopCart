//
//  HomeViewController.m
//  超值购-项目
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "SearchViewController.h"
#import "ShopInfoViewController.h"
#import "DBMarket.h"
#import "MarketInfo.h"
#import "GoodsInfo.h"
#import "ShopDetailsViewController.h"
#define SCREEN_WIHTE [UIScreen mainScreen].bounds.size.width
@interface HomeViewController ()<SearchDelegate>
{
    NSMutableArray *_HomeArray;
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIView *_viewRowHead2;
    IBOutlet UIView *_veiwRowHead1;
    IBOutlet UIView *_viewRowhead;
    IBOutlet UIView *_viewhead;
}
- (IBAction)searchAction:(id)sender;
- (IBAction)typeAction:(id)sender;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    int page=3;
    _scrollView.contentSize=CGSizeMake(SCREEN_WIHTE*page, 136);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    for (int i=0; i<page; i++) {
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_test%i.png",i+1]]];
        [image setFrame:CGRectMake(SCREEN_WIHTE*i, 0, SCREEN_WIHTE, 136)];
        [_scrollView addSubview:image];
    }
    _HomeArray=[[DBMarket sharedInfo] MarketArray];
    
}
-(void)NextAction:(NSNotification *)sender{
//    NSLog(@"%@",sender.object);
    
//    ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
//    controller.LikeStr=sender.object;
//    [self.navigationController pushViewController:controller animated:NO];
    //从通知那边传一个参数，一个ID给controller，传过去，就可以获取对应的列表
}

-(void)JumpViewController:(NSString *)searchStr{
    
    NSLog(@"进入代理");
    ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
        controller.LikeStr=searchStr;
    [self.navigationController pushViewController:controller animated:NO];

}
-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.title=@"首页";
    self.tabBarController.navigationItem.rightBarButtonItem=nil;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _HomeArray.count+1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        MarketInfo *info=[_HomeArray objectAtIndex:section-1];
        if (info.marketShopArray.count%2==0) {
            int a=(int)info.marketShopArray.count/2;
//            NSLog(@"==%li,--%i",section,a);
            return a;
        }else{
            int a=(int)info.marketShopArray.count/2+1;
//              NSLog(@"--%li,--%i",section,a);
            return a;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 0;
    }else{
        return 219;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section!=0) {
        return 35;
    }
    
        return 324;
    

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return _viewhead;
    }else{
        MarketInfo *info=[_HomeArray objectAtIndex:section-1];
        
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIHTE, 35)];
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIHTE, 35)];
        imageView.image=[UIImage imageNamed:@"search_hd_bar_02.png"];
        [view addSubview:imageView];
        
        UILabel *lbView=[[UILabel alloc] initWithFrame:CGRectMake(8, 7, 105, 21)];
        lbView.text=info.marketName;
        lbView.textColor=[UIColor whiteColor];
        [view addSubview:lbView];
        
        UILabel *lbMore=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIHTE-47, 7, 42, 21)];
        lbMore.text=@"更多";
        lbMore.textColor=[UIColor whiteColor];
        [view addSubview:lbMore];
        
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(SCREEN_WIHTE-62, 3, 61, 30)];
        [btn setBackgroundColor:[UIColor clearColor]];
        btn.tag=info.marketId;
        [btn addTarget:self action:@selector(typeMoreAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }
}
-(void)typeMoreAction:(UIButton *)sender{
    int tag=(int)sender.tag;
    ShopInfoViewController *controller=[ShopInfoViewController new];
    controller.MarketId=tag;
    [self.navigationController pushViewController:controller animated:YES];
    
    
    NSLog(@"%i",tag);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    HomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    if (indexPath.section!=0) {
        MarketInfo *info=[_HomeArray objectAtIndex:indexPath.section-1];
        NSMutableArray *goodsArray=info.marketShopArray;
        GoodsInfo *goodsInfo;
        GoodsInfo *goodsInfo1;
        if (goodsArray.count>2*indexPath.row) {
           goodsInfo=[goodsArray objectAtIndex:2*indexPath.row];
        }
        if (goodsArray.count>2*indexPath.row+1) {
            goodsInfo1=[goodsArray objectAtIndex:2*indexPath.row+1];
            cell.lbHideen1.hidden=YES;
            
        }
        cell.lbHideen.hidden=YES;
        cell.lbInfo.text=goodsInfo.goods_name;
        cell.lbPrice.text=[NSString stringWithFormat:@"%.2f",goodsInfo.goods_price];
        cell.imageInfo.image=[UIImage imageNamed:goodsInfo.goods_logo];
        cell.btnDetails.tag=[[NSString stringWithFormat:@"%li000%li",indexPath.section,indexPath.row*2] integerValue];
        [cell.btnDetails addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lbInfo1.text=goodsInfo1.goods_name;
        cell.lbPrice1.text=[NSString stringWithFormat:@"%.2f",goodsInfo1.goods_price];
        cell.imageInfo1.image=[UIImage imageNamed:goodsInfo1.goods_logo];
        cell.btnDetails1.tag=[[NSString stringWithFormat:@"%li000%li",indexPath.section,indexPath.row*2+1] integerValue];
        [cell.btnDetails1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];

    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];

}
-(void)clickBtn:(UIButton *)sender{
    int tag=(int)[sender tag];
    NSArray *numIdArray=[[NSString stringWithFormat:@"%i",tag] componentsSeparatedByString:@"000"];
    int numID=[[numIdArray objectAtIndex:0] intValue];
    MarketInfo *info=[_HomeArray objectAtIndex:numID-1];
    GoodsInfo *goods=[info.marketShopArray objectAtIndex:[[numIdArray objectAtIndex:1] intValue]];
    ShopDetailsViewController *controller=[ShopDetailsViewController new];
    controller.info=goods;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchAction:(id)sender {
    SearchViewController *controller=[[SearchViewController alloc] init];
    controller.delegate=self;
    [self presentViewController:controller animated:NO completion:nil];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)typeAction:(id)sender {
    int tag=(int)[sender tag];
    ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
    
    controller.TypeId=tag;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}
@end

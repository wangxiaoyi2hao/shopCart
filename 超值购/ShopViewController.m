//
//  ShopViewController.m
//  超值购-项目
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "ShopViewController.h"
#import "addTableViewCell.h"
#import "shopInfo.h"
#import "Toast.h"
#import "DBShopCar.h"
#import "GoodsInfo.h"
#import "SettleViewController.h"
#import "UserInfo.h"
#import "LoginViewController.h"
extern UserInfo *loginUserInfo;
@interface ShopViewController ()
{
    NSMutableArray *shopArray;
    
    IBOutlet UILabel *_settleNum;
    int settleNum;
    IBOutlet UITableView *_tableView;
    float count;
    IBOutlet UILabel *lbAccounts;
    float countPrice;

    IBOutlet UIView *SureShop;
}
- (IBAction)settleAction:(id)sender;
@end

@implementation ShopViewController

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
    
  shopArray=[[DBShopCar sharedInfo] AllShopCar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:@"refreshAction" object:nil];
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title=@"购物车";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 23, 25)];
    [rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"cart_delete.png"] forState:UIControlStateNormal];
    rightBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.tabBarController.navigationItem.rightBarButtonItem=rightItem;
   shopArray=[[DBShopCar sharedInfo] AllShopCar];
      count=0;
   lbAccounts.text=[NSString stringWithFormat:@"结算￥%.2f",count];
    settleNum=0;
    _settleNum.text=[NSString stringWithFormat:@"结算(%i)",settleNum];
    [_tableView reloadData];
}
-(void)refreshTableView:(NSNotification *)sender{
    
     shopArray=[[DBShopCar sharedInfo] AllShopCar];
    [_tableView reloadData];

}
-(void)nextClick{
    for (int i=0; i<shopArray.count; i++) {
         GoodsInfo *info=[shopArray objectAtIndex:i];
        if (info.isSelect) {
            [[DBShopCar sharedInfo] delete:info.goods_id];
        }
    }
    shopArray=[[DBShopCar sharedInfo] AllShopCar];
    [_tableView reloadData]; shopArray=[[DBShopCar sharedInfo] AllShopCar];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return shopArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    addTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"addTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    GoodsInfo *shop=[shopArray objectAtIndex:indexPath.row];
    cell.viewTitle.image=[UIImage imageNamed:shop.goods_logo];
    cell.lbCount.text=shop.goods_name;
    cell.lbNum.text=[NSString stringWithFormat:@"%i",shop.goodsNum];
    cell.lbPrice.text=[NSString stringWithFormat:@"%.2f",shop.goods_price*shop.goodsNum];
    if (shop.isSelect) {
        cell.viewChoose.image=[UIImage imageNamed:@"cart_selected1.png"];
    }else{
        cell.viewChoose.image=[UIImage imageNamed:@"cart_selected0.png"];
    }
    [cell.btnJia addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnJia.tag=indexPath.row;
    [cell.btnJian addTarget:self action:@selector(reduceAtion:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnJian.tag=indexPath.row;
    [cell.btnChoose addTarget:self action:@selector(chooseAtion:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnChoose.tag=indexPath.row;
    

    return cell;
}
-(void)addAction:(UIButton *)sender{
    int tag=(int)[sender tag];
    GoodsInfo *info=[shopArray objectAtIndex:tag];
    
    
    if (info.isSelect) {
        count+=info.goods_price;
        lbAccounts.text=[NSString stringWithFormat:@"结算￥%.2f",count];
        
    }
       info.goodsNum++;
    [[DBShopCar sharedInfo] AddShopCarNum:info.goods_id isAdd:YES];
    [_tableView reloadData];
    
}
-(void)reduceAtion:(UIButton *)sender{
    int tag=(int)[sender tag];
    GoodsInfo *info=[shopArray objectAtIndex:tag];
    if (info.isSelect) {
        count-=info.goods_price;
        lbAccounts.text=[NSString stringWithFormat:@"结算￥%.2f",count];
    }
    
    if (info.goodsNum>1) {
        
        info.goodsNum--;
        
        
    }else{
        [[Toast sharedToastInfo] hideTime:1 makeText:@"不能再少了"];
    }
      [[DBShopCar sharedInfo] AddShopCarNum:info.goods_id isAdd:NO];
    
    [_tableView reloadData];
}

-(void)chooseAtion:(UIButton *)sender{
    int tag=(int)[sender tag];
    GoodsInfo *info=[shopArray objectAtIndex:tag];
    if (info.isSelect) {
        info.isSelect=NO;
        count-=info.goods_price*info.goodsNum;
        settleNum--;
        _settleNum.text=[NSString stringWithFormat:@"结算(%i)",settleNum];
        lbAccounts.text=[NSString stringWithFormat:@"结算￥%.2f",count];
    }else{
        info.isSelect=YES;
        settleNum++;
        _settleNum.text=[NSString stringWithFormat:@"结算(%i)",settleNum];
        count+=info.goods_price*info.goodsNum;
        lbAccounts.text=[NSString stringWithFormat:@"结算￥%.2f",count];
        
    }
    [_tableView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
      [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settleAction:(id)sender {
    if (loginUserInfo!=nil) {
        
    NSMutableArray *orderArray=[NSMutableArray array];
    for (int i=0; i<shopArray.count; i++) {
          GoodsInfo *info=[shopArray objectAtIndex:i];
        if (info.isSelect) {
            [orderArray addObject:info];
            }
        }
            if (orderArray.count==0) {
            [[Toast sharedToastInfo] hideTime:1 makeText:@"请选择商品"];
            }else{
                        SettleViewController *controller=[[SettleViewController alloc] init];
                        controller.orderArray=orderArray;
                        controller.generalPrice=count;
                        [self.navigationController pushViewController:controller animated:YES];
                        NSLog(@"====%li",orderArray.count);
        }
    }else{
        LoginViewController *controller=[LoginViewController alloc];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:controller];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"newsTopBg_new"] forBarMetrics:UIBarMetricsDefault];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self presentViewController:nav animated:YES completion:nil];

        
        [[Toast sharedToastInfo] hideTime:1 makeText:@"你还没登陆"];
    }
}
@end

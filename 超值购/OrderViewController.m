//
//  OrderViewController.m
//  超值购
//
//  Created by apple on 15/9/5.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "HelperUtil.h"
#import "DBOrder.h"
#import "OrderInfo.h"
#import "Toast.h"
#import "UserInfo.h"
#import "DBShopCar.h"
#import "SettleViewController.h"
#import "GoodsInfo.h"
#import "DBGoodsInfo.h"
#import "OrderDetailsViewController.h"
#import "MyFile.h"
#import "DBUser.h"
#import "AppDelegate.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
extern UserInfo *loginUserInfo;
@interface OrderViewController ()
{
    
    IBOutlet UIButton *_btnPay;

    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_btnDone;
    IBOutlet UIButton *_btnGain;
    NSMutableArray *orderArray;
    NSMutableArray *shopArray;
}
- (IBAction)payClick:(id)sender;


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"订单信息";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    self.view.backgroundColor=[HelperUtil colorWithHexString:@"#f8f8f8"];
    
    [_btnPay setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_btnGain setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
    [_btnGain setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [_btnDone setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
    [_btnDone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    orderArray=[[DBOrder sharedInfo] orderArray:0 user:loginUserInfo.user_id];
  

}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return orderArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    
    OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    OrderInfo *info=[orderArray objectAtIndex:indexPath.row];
    cell.lbOrderId.text=[NSString stringWithFormat:@"%i",info.Order_id];
    cell.lbOrderPrice.text=info.Order_price;
    cell.lbOrderTime.text=info.Order_time;
    if (info.Order_type==0) {
        cell.lbOrderType.text=@"待付款";
        [cell.btnOrder setTitle:@"付款" forState:UIControlStateNormal];
        [cell.btnOrder addTarget:self action:@selector(settleAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOrder.tag=indexPath.row;
        cell.btnJudge.hidden=YES;
        cell.imgJudge.hidden=YES;
    }else if (info.Order_type==1){
     cell.lbOrderType.text=@"待收货";
        [cell.btnOrder setTitle:@"确认收货" forState:UIControlStateNormal];
        [cell.btnOrder addTarget:self action:@selector(GetAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnOrder.tag=indexPath.row;
        cell.btnJudge.hidden=YES;
        cell.imgJudge.hidden=YES;
    }else if (info.Order_type==2){
        cell.lbOrderType.text=@"以完成";
        
        
        cell.btnOrder.hidden=YES;
        cell.btnJudge.hidden=NO;
        NSLog(@"%@",info.Order_goods);
        NSArray *array=[info.Order_goods componentsSeparatedByString:@"||"];
        NSLog(@"%--li",array.count);
        for (int i=0; i<array.count; i++) {
            NSString *goodsStr=[array objectAtIndex:i];
            NSArray *judgeTypeArray=[goodsStr componentsSeparatedByString:@","];
            NSString *judgeTypeStr=[judgeTypeArray lastObject];
            if ([judgeTypeStr isEqualToString:@"0"]) {
                NSLog(@"未评价");
                 cell.imgJudge.hidden=NO;
                break;
            }else{
                NSLog(@"以评价");
                cell.imgJudge.hidden=YES;
            }
            
        }
        [cell.btnJudge addTarget:self action:@selector(DoneAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnJudge.tag=indexPath.row;

    }
    return cell;
}
-(void)settleAction:(UIButton *)sender{
     OrderInfo *info=[orderArray objectAtIndex:sender.tag];
    info.Order_price=@"0.01";
    NSString *partner = alipay_partner;
    NSString *seller = alipay_seller;
    NSString *privateKey =alipay_privateKey;
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%i",info.Order_id]; //订单ID（由商家自行制定）
    order.productName = @"MacPro"; //商品标题
//    order.productDescription = product.body; //商品描述
    order.amount = [NSString stringWithFormat:@"%@", info.Order_price]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"chaozhigou";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

    
    
//        UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alter setAlertViewStyle:UIAlertViewStyleSecureTextInput];
//        alter.tag=[sender tag];
//        [alter show];
//        
    
    
    
}
-(void)GetAction:(UIButton *)sender{
    OrderInfo *orderInfo=[orderArray objectAtIndex:sender.tag];
    orderInfo.Order_type=2;
    if ([[DBOrder sharedInfo] updateOrderType:orderInfo]) {
        NSLog(@"添加至待已完成订单成功");
        orderArray=[[DBOrder sharedInfo] orderArray:1 user:loginUserInfo.user_id];
        [_tableView reloadData];
    }

}
-(void)DoneAction:(UIButton *)sender{
    OrderInfo *info=[orderArray objectAtIndex:sender.tag];
    NSArray *array=[info.Order_goods componentsSeparatedByString:@"||"];
    NSMutableString *goodsStr=[NSMutableString string];
    
    for (int i=0; i<array.count; i++) {
        NSString *str=[array objectAtIndex:i];
        NSMutableString *mutStr=[NSMutableString stringWithString:str];
//          NSLog(@"----%@",str);
//          NSLog(@"----==%li",str.length);
        [mutStr replaceCharactersInRange:NSMakeRange(mutStr.length-1, 1) withString:@"1"];

//        NSLog(@"=====%@",mutStr);
        [goodsStr appendFormat:@"%@",mutStr];
        if (i!=array.count-1) {
             [goodsStr appendString:@"||"];
        }
    }
    info.Order_goods=goodsStr;
    if ([[DBOrder sharedInfo] updateOrderType:info]) {
        NSLog(@"增加评论成功");
        orderArray=[[DBOrder sharedInfo] orderArray:2 user:loginUserInfo.user_id];
        [_tableView reloadData];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        if (buttonIndex==0) {
            NSLog(@"你点击了取消");
        }else{
            UITextField *filed=[alertView textFieldAtIndex:0];
             OrderInfo *orderInfo=[orderArray objectAtIndex:alertView.tag];
            
            if (![filed.text isEqualToString:loginUserInfo.user_pwd]) {
                [[Toast sharedToastInfo] hideTime:1 makeText:@"密码错误"];
            }else  if (loginUserInfo.user_balance<[orderInfo.Order_price doubleValue]) {
                [[Toast sharedToastInfo] hideTime:1 makeText:@"账户余额不足，请充值"];
            }else{
                //0-未付款，1，待收货，2，已完成
                orderInfo.Order_type=1;
                if ([[DBOrder sharedInfo] updateOrderType:orderInfo]) {
                    NSLog(@"添加至待收货订单成功");
                     orderArray=[[DBOrder sharedInfo] orderArray:0 user:loginUserInfo.user_id];
                    [_tableView reloadData];
                }
                loginUserInfo.user_balance-=[orderInfo.Order_price doubleValue];
                
                [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
                 [[DBUser sharedInfo] changeBanlance:loginUserInfo];

            }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderInfo *info=[orderArray objectAtIndex:indexPath.row];
    NSArray *array=[info.Order_goods componentsSeparatedByString:@"||"];
      shopArray=[NSMutableArray array];
    NSString *judgeTypeStr=[NSString string];
    
    for (int i=0; i<array.count; i++) {
        NSString *goodsStr=[array objectAtIndex:i];
        NSArray *judgeTypeArray=[goodsStr componentsSeparatedByString:@","];
        NSString *goodsIdStr=[judgeTypeArray objectAtIndex:0];
         NSString *goodsNumStr=[judgeTypeArray objectAtIndex:1];
        int num=[goodsIdStr intValue];
        NSLog(@"--%i",num);
         GoodsInfo *info=[[DBShopCar sharedInfo] OrderShopCar:num];
        judgeTypeStr=[judgeTypeArray lastObject];
        if ([judgeTypeStr isEqualToString:@"0"]) {
            info.judge_type=0;//0未评论
        }else{
            info.judge_type=1;
        }
       
        info.goodsNum=[goodsNumStr intValue];
        [shopArray addObject:info];
        
    }

    OrderDetailsViewController *controller=[[OrderDetailsViewController alloc] init];
    controller.orderArray=shopArray;
    controller.generalPrice=[info.Order_price floatValue];
    controller.info=info;
    controller.judgeTypeStr=judgeTypeStr;
    
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (IBAction)payClick:(id)sender {
    if ([sender tag]==0) {
        [_btnPay setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
        [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      
        [_btnGain setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnGain setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [_btnDone setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnDone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
         orderArray=[[DBOrder sharedInfo] orderArray:0 user:loginUserInfo.user_id];
        [_tableView reloadData];
    }
    if ([sender tag]==1) {
        [_btnPay setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
       [_btnPay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_btnGain setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
        [_btnGain setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnDone setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
         [_btnDone setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        orderArray=[[DBOrder sharedInfo] orderArray:1 user:loginUserInfo.user_id];
        [_tableView reloadData];
    }
    if ([sender tag]==2) {
        [_btnPay setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
       [_btnPay setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [_btnGain setBackgroundColor:[HelperUtil colorWithHexString:@"#333333"]];
        [_btnGain setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [_btnDone setBackgroundColor:[HelperUtil colorWithHexString:@"#1B1B1B"]];
          [_btnDone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        orderArray=[[DBOrder sharedInfo] orderArray:2 user:loginUserInfo.user_id];
        [_tableView reloadData];
    }
}

@end

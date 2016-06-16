//
//  SettleViewController.m
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "SettleViewController.h"
#import "CarTableViewCell.h"
#import "GoodsInfo.h"
#import "AddressViewController.h"
#import "DBAddress.h"
#import "UserInfo.h"
#import "AddressInfo.h"
#import "Toast.h"
#import "DBUser.h"
#import "MyFile.h"
#import "DBShopCar.h"
#import "OrderInfo.h"
#import "DBOrder.h"
extern UserInfo *loginUserInfo;
@interface SettleViewController ()
{

    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_viewHead;
    
    IBOutlet UILabel *_lbGeneral;
    IBOutlet UIView *_viewHeadRow;
    BOOL isDefaultAddress;
    IBOutlet UILabel *_lbName;
    IBOutlet UILabel *_lbPhone;
    IBOutlet UILabel *_lbCity;
    NSMutableArray *addressArray;
    int addressIndex;
}
- (IBAction)HandSettle:(id)sender;
- (IBAction)changeAddress:(id)sender;
@end

@implementation SettleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"商品结算";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    _lbGeneral.text=[NSString stringWithFormat:@"%.2f",_generalPrice];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    addressArray=[[DBAddress sharedInfo] AddressArray:loginUserInfo.user_id];
    for (int i=0; i<addressArray.count; i++) {
        AddressInfo *info=[addressArray objectAtIndex:i];
        if (info.AddressIsdefault) {
            NSLog(@"默认%@",info.Address_name);
            _lbName.text=info.Address_name;
            _lbPhone.text=info.Address_phone;
            _lbCity.text=[NSString stringWithFormat:@"%@%@%@%@",info.Address_province,info.Address_city,info.Address_district,info.Address_street];
            isDefaultAddress=YES;
            addressIndex=i;
            break;
        }else{
            _lbName.text=@"";
            _lbPhone.text=@"";
            _lbCity.text=@"";
            
            isDefaultAddress=NO;
        }
    }

      _lbGeneral.text=[NSString stringWithFormat:@"%.2f",_generalPrice];
    [_tableView reloadData];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 127;
    }else{
        return 39;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return _viewHead;
    }else{
        return _viewHeadRow;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @"选中商品";
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return _orderArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    CarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"CarTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
    if (indexPath.section==1) {
        
        GoodsInfo *info=[_orderArray objectAtIndex:indexPath.row];
        cell.viewTitle.image=[UIImage imageNamed:info.goods_logo];
        cell.lbCount.text=info.goods_name;
        cell.lbNum.text=[NSString stringWithFormat:@"X%i",info.goodsNum];
        cell.lbPrice.text=[NSString stringWithFormat:@"￥%.2f",info.goods_price];
        cell.btnJudge.hidden=YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)HandSettle:(id)sender {
    if ([_lbCity.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请填写收货地址"];
    }else{
//        UserInfo *info=[[DBUser sharedInfo] loginUser:loginUserInfo.user_name pwd:loginUserInfo.user_pwd];
        if (loginUserInfo.user_balance<_generalPrice) {
            [[Toast sharedToastInfo] hideTime:1 makeText:@"账户余额不足，请充值"];
        }else{
            UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alterView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
            alterView.tag=10;
            [alterView show];
        }
        
    }
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        if (buttonIndex==0) {
            UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:nil message:@"确认取消付款？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alterView.tag=20;
            [alterView show];
        }else{
            UITextField *filed=[alertView textFieldAtIndex:0];
            if (![filed.text isEqualToString:loginUserInfo.user_pwd]) {
                [[Toast sharedToastInfo] hideTime:1 makeText:@"密码错误"];
            }else{
                //0-未付款，1，待收货，2，已完成
                [[Toast sharedToastInfo] hideTime:1 makeText:@"付款成功"];
                OrderInfo *info=[OrderInfo new];
                NSDate *newDate=[NSDate new];

                NSDateFormatter *date=[NSDateFormatter new];
                [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *dateStr=[date stringFromDate:newDate];
                info.Order_time=dateStr;
                info.Order_id=[[NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]] intValue];
                info.Order_type=1;
                info.Order_price=[NSString stringWithFormat:@"%.2f",_generalPrice];
                info.user_id=loginUserInfo.user_id;
                
                
                 AddressInfo *addressId=[addressArray objectAtIndex:addressIndex];
                info.Address_id=addressId.Address_id;
                NSMutableString *goodsStr=[NSMutableString string];
                for (int i=0; i<_orderArray.count; i++) {
                    GoodsInfo *goods=[_orderArray objectAtIndex:i];
                    [goodsStr appendFormat:@"%i,%i,%i",goods.goods_id,goods.goodsNum,0];
                    if (i!=_orderArray.count-1) {
                        [goodsStr appendString:@"||"];
                    }
                }
                info.Order_goods=goodsStr;
                
                if ([[DBOrder sharedInfo] insertOrderInfo:info]) {
                    NSLog(@"添加至订单成功");
                }
                
                loginUserInfo.user_balance-=_generalPrice;
                
                [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
                
                for (int i=0; i<_orderArray.count; i++) {
                    GoodsInfo *info=[_orderArray objectAtIndex:i];
                    [[DBShopCar sharedInfo] delete:info.goods_id];
                }
                [[DBUser sharedInfo] changeBanlance:loginUserInfo];
                _orderArray=[NSMutableArray array];
                [_tableView reloadData];
            }
        
        }
    }
    if (alertView.tag==20) {
        if (buttonIndex==0) {
            UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alterView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
             UITextField *filed=[alertView textFieldAtIndex:0];
            [filed setPlaceholder:@"请输入密码"];
            alterView.tag=10;
            [alterView show];
        }else{
            OrderInfo *info=[OrderInfo new];
            NSDate *newDate=[NSDate new];
            
            NSDateFormatter *date=[NSDateFormatter new];
            [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateStr=[date stringFromDate:newDate];
            info.Order_time=dateStr;
            info.Order_id=[[NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]] intValue];
            info.Order_type=0;
            info.Order_price=[NSString stringWithFormat:@"%.2f",_generalPrice];
            info.user_id=loginUserInfo.user_id;
            
            
            AddressInfo *addressId=[addressArray objectAtIndex:addressIndex];
            info.Address_id=addressId.Address_id;
            NSMutableString *goodsStr=[NSMutableString string];
            for (int i=0; i<_orderArray.count; i++) {
                GoodsInfo *goods=[_orderArray objectAtIndex:i];
                [goodsStr appendFormat:@"%i,%i,%i",goods.goods_id,goods.goodsNum,0];
                if (i!=_orderArray.count-1) {
                    [goodsStr appendString:@"||"];
                }
            }
            info.Order_goods=goodsStr;
            
            if ([[DBOrder sharedInfo] insertOrderInfo:info]) {
                NSLog(@"添加至订单成功");
            }
            for (int i=0; i<_orderArray.count; i++) {
                GoodsInfo *info=[_orderArray objectAtIndex:i];
                [[DBShopCar sharedInfo] delete:info.goods_id];
            }

            _orderArray=[NSMutableArray array];
            [_tableView reloadData];
            
            [[Toast sharedToastInfo] hideTime:1 makeText:@"以添加至代付款订单中"];
        }
    }

}

- (IBAction)changeAddress:(id)sender {
    AddressViewController *controller=[[AddressViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
@end

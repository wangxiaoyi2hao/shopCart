//
//  OrderDetailsViewController.m
//  超值购
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "CarTableViewCell.h"
#import "GoodsInfo.h"
#import "OrderInfo.h"
#import "DBAddress.h"
#import "AddressInfo.h"
#import "UserInfo.h"
#import "CommentViewController.h"
#import "DBOrder.h"
#import "Toast.h"
#import "MyFile.h"
#import "DBUser.h"
extern UserInfo *loginUserInfo;
@interface OrderDetailsViewController ()
{

    IBOutlet UIView *_viewHead;
    IBOutlet UIView *_viewRowHead;
    
    IBOutlet UILabel *_lbPhone;
    IBOutlet UILabel *_lbGetPeople;
    
    IBOutlet UIButton *_btnPay;
    IBOutlet UILabel *_lbPay;
    
    
    IBOutlet UIView *bottomView;
   
    
    IBOutlet UILabel *_orderPirce;
    IBOutlet UILabel *_orderNum;
    IBOutlet UILabel *_orderType;
    IBOutlet UILabel *_lbAddress;
    NSMutableArray *addressArray;
    
    IBOutlet UILabel *_lbPayType;
    
}
- (IBAction)deleteAction:(id)sender;

- (IBAction)payAction:(id)sender;


@end

@implementation OrderDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"订单详情";
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    
    UIButton *btnDelete=[UIButton buttonWithType:UIButtonTypeCustom];
      [btnDelete setTitle:@"删除订单" forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [btnDelete setBackgroundImage:[UIImage imageNamed:@"order_btn2"] forState:UIControlStateNormal];
   
    [btnDelete setFrame:CGRectMake(89, 18, 92, 27)];
    [btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
   
    [bottomView addSubview:btnDelete];
    _orderPirce.text=[NSString stringWithFormat:@"%.2f",[_info.Order_price floatValue]];
    _orderNum.text=[NSString stringWithFormat:@"%i",_info.Order_id];
    if (_info.Order_type==0) {
        _orderType.text=@"待付款";
        _lbPayType.text=@"付款";
    }else if (_info.Order_type==1){
         _orderType.text=@"待收货";
         _lbPayType.text=@"确认收货";
    }else{
         _orderType.text=@"以完成";
         _lbPayType.text=@"评论";
        _btnPay.hidden=YES;
        
        [btnDelete setFrame:CGRectMake(200, 18, 92, 27)];
    }
    
    AddressInfo *info2=[[DBAddress sharedInfo] AddressInfoArray:loginUserInfo.user_id addressId:_info.Address_id];
    NSLog(@"默认%@",info2.Address_name);
    _lbGetPeople.text=info2.Address_name;
    _lbPhone.text=info2.Address_phone;
    _lbAddress.text=[NSString stringWithFormat:@"%@%@%@%@",info2.Address_province,info2.Address_city,info2.Address_district,info2.Address_street];
    
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 191;
    }else{
        return 39;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return _viewHead;
    }else{
        return _viewRowHead;
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
        if (_info.Order_type==2) {
            if (info.judge_type==0) {
                cell.btnJudge.hidden=NO;
                [cell.btnJudge addTarget:self action:@selector(judgeAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnJudge.tag=indexPath.row;
                
            }else{
                cell.btnJudge.hidden=YES;
            }
        }else{
            cell.btnJudge.hidden=YES;
        }
        
    }
    return cell;
}
-(void)judgeAction:(UIButton *)sender{

     GoodsInfo *goodsInfo=[_orderArray objectAtIndex:[sender tag]];
    CommentViewController *controller=[[CommentViewController alloc] init];
    controller.info=_info;
    controller.goodsInfo=goodsInfo;
    
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)deleteAction:(id)sender {
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定删除订单？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    sheet.tag=10;
    
    [sheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==10) {
        if (buttonIndex==0) {
            if ([[DBOrder sharedInfo] deleteOrderInfo:_info]) {
                [[Toast sharedToastInfo] hideTime:1 makeText:@"删除订单成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }

        }else{
            NSLog(@"你点击了取消");
        }
    }
    
    if (actionSheet.tag==20) {
        if (buttonIndex==0) {
            _info.Order_type=2;
            if ([[DBOrder sharedInfo] updateOrderType:_info]) {
                NSLog(@"添加至已完成订单成功");
                [[Toast sharedToastInfo] hideTime:1 makeText:@"确认收货成功"];
                 [self.navigationController popToRootViewControllerAnimated:YES];

            }
        }else{
            NSLog(@"你点击了取消");
        }
    }

}
- (IBAction)payAction:(id)sender {
    if (_info.Order_type==0) {
        UIAlertView *alterView=[[UIAlertView alloc] initWithTitle:@"请输入密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
        alterView.tag=10;
        [alterView show];

        
    }else if (_info.Order_type==1){
        
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定收货？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        sheet.tag=20;
        
        [sheet showInView:self.view];

        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSLog(@"你点击了取消");
    }else{
        UITextField *filed=[alertView textFieldAtIndex:0];
        if (![filed.text isEqualToString:loginUserInfo.user_pwd]) {
            [[Toast sharedToastInfo] hideTime:1 makeText:@"密码错误"];
        }else{
            //0-未付款，1，待收货，2，已完成
           
            _info.Order_type=1;
            if ([[DBOrder sharedInfo] updateOrderType:_info]) {
                  [[Toast sharedToastInfo] hideTime:1 makeText:@"付款成功"];
                NSLog(@"添加至待收货订单成功");
            }
            loginUserInfo.user_balance-=[filed.text doubleValue];
            
            [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
            [[DBUser sharedInfo] changeBanlance:loginUserInfo];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end

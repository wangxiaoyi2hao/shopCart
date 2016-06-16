//
//  AddressViewController.m
//  超值购
//
//  Created by apple on 15/9/3.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "AddressViewController.h"
#import "DBAddress.h"
#import "AddressInfo.h"
#import "UserInfo.h"
#import "AddressTableViewCell.h"
#import "EditViewController.h"
#import "Toast.h"
extern UserInfo *loginUserInfo;
@interface AddressViewController ()
{
    NSMutableArray *addressArray;
    
    IBOutlet UITableView *_tableView;
}
@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.title=@"地址管理";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"add_normal"] forState:UIControlStateNormal];
    rightBtn.showsTouchWhenHighlighted = YES;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)viewWillAppear:(BOOL)animated{
     addressArray=[[DBAddress sharedInfo] AddressArray:loginUserInfo.user_id];
    [_tableView reloadData];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextClick{
    EditViewController *controller=[[EditViewController alloc] init];
    
    [self.navigationController pushViewController:controller animated:YES];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return addressArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    
    AddressTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    AddressInfo *shop=[addressArray objectAtIndex:indexPath.row];
    cell.lbName.text=shop.Address_name;
    cell.lbPhone.text=shop.Address_phone;
    cell.lbAddress.text=[NSString stringWithFormat:@"%@%@%@%@",shop.Address_province,shop.Address_city,shop.Address_district,shop.Address_street];
    if (shop.AddressIsdefault) {
        cell.IsImage.image=[UIImage imageNamed:@"address_list_selected"];
    }else{
        cell.IsImage.image=[UIImage imageNamed:@"information_box1"];
    }
    [cell.btnDelete addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnDelete.tag=indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(editingAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnEdit.tag=indexPath.row;
    return cell;

}
-(void)deleteAction:(UIButton *)sender{
      UIAlertView *alter=[[UIAlertView alloc] initWithTitle:@"确定要删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag=sender.tag;
    [alter show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AddressInfo *shop=[addressArray objectAtIndex:alertView.tag];
    if ([[DBAddress sharedInfo] DeleteAddressInfo:shop]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"删除成功"];
        addressArray=[[DBAddress sharedInfo] AddressArray:loginUserInfo.user_id];
        [_tableView reloadData];
    }
}
-(void)editingAction:(UIButton *)sender{
    AddressInfo *shop=[addressArray objectAtIndex:sender.tag];
    EditViewController *controller=[[EditViewController alloc] init];
    controller.info=shop;
    [self.navigationController pushViewController:controller animated:YES];


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressInfo *info=[addressArray objectAtIndex:indexPath.row];
    info.AddressIsdefault=YES;
    [[DBAddress sharedInfo] changeIsDufault:info];
    for (int i=0; i<addressArray.count; i++) {
         AddressInfo *info1=[addressArray objectAtIndex:i];
        if (info1.Address_id!=info.Address_id) {
            info1.AddressIsdefault=NO;
            [[DBAddress sharedInfo] changeIsDufault:info1];
        }
    }
    addressArray=[[DBAddress sharedInfo] AddressArray:loginUserInfo.user_id];

    [_tableView reloadData];
}
@end

//
//  balanceViewController.m
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "balanceViewController.h"
#import "Toast.h"
#import "UserInfo.h"
#import "DBUser.h"
#import "MyFile.h"
extern UserInfo *loginUserInfo;
@interface balanceViewController ()
{

    IBOutlet UITextField *_tfBalance;
}
- (IBAction)sureBalance:(id)sender;
@end

@implementation balanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"充值金额";
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    UITapGestureRecognizer *singer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    singer.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:singer];

    
}
-(void)tapAction{
    [_tfBalance resignFirstResponder];

    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureBalance:(id)sender {
    if ([_tfBalance.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入充值的金额"];
    }else{
        loginUserInfo.user_balance+=[_tfBalance.text doubleValue];
        
        if ([[DBUser sharedInfo] changeBanlance:loginUserInfo]) {
            
            [[Toast sharedToastInfo] hideTime:1 makeText:@"充值成功"];
            
            [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }

    
}
@end

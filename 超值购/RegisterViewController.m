//
//  RegisterViewController.m
//  超值购
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "RegisterViewController.h"
#import "Toast.h"
#import "DBUser.h"
#import "UserInfo.h"
#import "MyFile.h"
@interface RegisterViewController ()
{
    
    IBOutlet UITextField *_tfAccount;

    IBOutlet UITextField *_tfSurePwd;
    IBOutlet UITextField *_tfPwd;
}
- (IBAction)sureAction:(id)sender;
@end

@implementation RegisterViewController

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
    
    UITapGestureRecognizer *singer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    singer.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:singer];
}
-(void)tapAction{
    [_tfAccount resignFirstResponder];
    [_tfPwd resignFirstResponder];
    [_tfSurePwd resignFirstResponder];
    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_tfAccount]) {
        [self.view setFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    }else if([textField isEqual:_tfPwd]){
        [self.view setFrame:CGRectMake(0, -40, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    }else if([textField isEqual:_tfSurePwd]){
        [self.view setFrame:CGRectMake(0, -60, self.view.bounds.size.width, self.view.bounds.size.height)];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureAction:(id)sender {
    if ([_tfAccount.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入账号"];
    }else if ([_tfPwd.text isEqualToString:@""]) {
        
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入密码"];
    }else if([_tfSurePwd.text isEqualToString:@""]){
        
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入确认密码"];
    }else if(![_tfPwd.text isEqualToString:_tfSurePwd.text]){
        
        [[Toast sharedToastInfo] hideTime:1 makeText:@"两次密码不一致"];
    }else{
        
        UserInfo *info=[[UserInfo alloc] init];
        info.user_name=_tfAccount.text;
        info.user_pwd=_tfPwd.text;
        info.user_balance=0.0;
        info.user_head=@"";
        info.user_id=[NSString stringWithFormat:@"%.0f",[[NSDate new] timeIntervalSince1970]];
        
        if ([[DBUser sharedInfo] InsertUser:info]) {
            
             [[Toast sharedToastInfo] hideTime:1 makeText:@"注册成功"];
            
            [NSKeyedArchiver archiveRootObject:info toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
            [self dismissViewControllerAnimated:YES completion:nil];

        }else{
            
             [[Toast sharedToastInfo] hideTime:1 makeText:@"用户名重复"];
        }
       
    }

}
@end

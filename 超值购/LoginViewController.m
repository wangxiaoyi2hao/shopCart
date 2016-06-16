//
//  LoginViewController.m
//  超值购
//
//  Created by apple on 15/9/1.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Toast.h"
#import "DBUser.h"
#import "UserInfo.h"
#import "MyFile.h"
extern UserInfo *loginUserInfo;
@interface LoginViewController ()
{
    
    IBOutlet UITextField *_tfAccount;

    IBOutlet UITextField *_tfPwd;
}

- (IBAction)loginAction:(id)sender;

- (IBAction)registerAction:(id)sender;
@end

@implementation LoginViewController

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
    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}
-(void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:_tfAccount]) {
        [self.view setFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height)];

    }else if([textField isEqual:_tfPwd]){
          [self.view setFrame:CGRectMake(0, -40, self.view.bounds.size.width, self.view.bounds.size.height)];
     
    }

}
- (IBAction)loginAction:(id)sender {
    if ([_tfAccount.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入账号"];
    }else if ([_tfPwd.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入密码"];
    }else{
        UserInfo *info=[[DBUser sharedInfo] loginUser:_tfAccount.text pwd:_tfPwd.text];
        if (info!=nil) {
            NSLog(@"登录成功");
            loginUserInfo=info;
        [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
        [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [[Toast sharedToastInfo] hideTime:1 makeText:@"登录失败"];

            NSLog(@"登录失败");

        }
    }
}

- (IBAction)registerAction:(id)sender {
        RegisterViewController *controller=[RegisterViewController new];
    [self.navigationController pushViewController:controller animated:YES];
    
}
@end

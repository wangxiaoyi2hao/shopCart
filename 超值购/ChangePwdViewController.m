//
//  ChangePwdViewController.m
//  超值购
//
//  Created by apple on 15/9/2.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "UserInfo.h"
#import "Toast.h"
#import "DBUser.h"
#import "MyFile.h"
extern UserInfo *loginUserInfo;
@interface ChangePwdViewController ()
{
    IBOutlet UITextField *_tfBeforePwd;

    IBOutlet UITextField *_tfSurePwd;
    IBOutlet UITextField *_tfNewPwd;
    
}
- (IBAction)SureChange:(id)sender;
@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"修改密码";
    UITapGestureRecognizer *singer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    singer.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:singer];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;

}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tapAction{
    [_tfBeforePwd resignFirstResponder];
    [_tfSurePwd resignFirstResponder];
    [_tfNewPwd resignFirstResponder];
    [self.view setFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SureChange:(id)sender {
    if ([_tfBeforePwd.text isEqualToString:@""]) {
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入原来的密码"];
    }else if ([_tfNewPwd.text isEqualToString:@""]){
      [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入新密码"];
    }else if ([_tfSurePwd.text isEqualToString:@""]){
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请确认新密码"];
    }else if(![_tfNewPwd.text isEqualToString:_tfSurePwd.text]){
        [[Toast sharedToastInfo] hideTime:1 makeText:@"两次输入的密码不一致"];
        
    }else if(![_tfBeforePwd.text isEqualToString:loginUserInfo.user_pwd]){
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入正确的旧密码"];

    }else{
        loginUserInfo.user_pwd=_tfNewPwd.text;
        if ([[DBUser sharedInfo] changePwd:loginUserInfo]) {
            
            [[Toast sharedToastInfo] hideTime:1 makeText:@"修改密码成功"];
            
            [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];

        }else{
         [[Toast sharedToastInfo] hideTime:1 makeText:@"修改密码失败"];
        }
        
        
    }
    
}
@end

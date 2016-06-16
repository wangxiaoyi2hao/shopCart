//
//  UserViewController.m
//  超值购-项目
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "UserViewController.h"
#import "UserInfo.h"
#import "MyFile.h"
#import "LoginViewController.h"
#import "ChangePwdViewController.h"
#import "balanceViewController.h"
#import "DBUser.h"
#import "AddressViewController.h"
#import "OrderViewController.h"
#import "MyCommentViewController.h"
extern UserInfo *loginUserInfo;
@interface UserViewController ()
{

    IBOutlet UITableView *_tableView;
}
@end

@implementation UserViewController

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
   
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.title=@"用户中心";
      self.tabBarController.navigationItem.rightBarButtonItem=nil;
//     loginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
    [_tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 66;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else if(section==1){
        return 3;
    }else if (section==2){
        return 2;
    }else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:celled];
    }
    if (indexPath.section==0) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celled];
        NSString *imagePath=[MyFile fileByDocumentPath:[NSString stringWithFormat:@"/UserHead/%@",loginUserInfo.user_head]];
        if ([loginUserInfo.user_head isEqualToString:@""]) {
            imagePath=@"headImg";
        }
        cell.imageView.image=[UIImage imageNamed:imagePath];
        cell.textLabel.text=loginUserInfo.user_name;
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f",loginUserInfo.user_balance];
        cell.detailTextLabel.textColor=[UIColor darkGrayColor];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:15];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"我的订单";
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"我的评论";
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"地址管理";
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text=@"修改密码";
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row==1) {
            cell.textLabel.text=@"余额充值";
             cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section==3) {
        cell.textLabel.text=@"退出登录";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==3) {
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        sheet.tag=10;
        sheet.delegate=self;
        [sheet showInView:self.view];
        
    }
    if (indexPath.section==0) {
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"修改头像？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选择" otherButtonTitles:@"拍照", nil];
        sheet.tag=20;
        sheet.delegate=self;
        [sheet showInView:self.view];
        
    }

    if (indexPath.section==2) {
        if (indexPath.row==0) {
            ChangePwdViewController *controller=[[ChangePwdViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==1) {
            balanceViewController *controller=[[balanceViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }

    }
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            OrderViewController *controller=[[OrderViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==1) {
            MyCommentViewController *controller=[[MyCommentViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
        if (indexPath.row==2) {
            AddressViewController *controller=[[AddressViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==10) {
        if (buttonIndex==0) {
            NSLog(@"点击了确定");
            UserInfo *info=nil;
            [NSKeyedArchiver archiveRootObject:info toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
            self.tabBarController.selectedIndex=0;
        }
    }
    if (actionSheet.tag==20) {
        if (buttonIndex==0) {
            NSLog(@"从相册选择");
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
            imagePicker.delegate=self;
            imagePicker.allowsEditing=YES;
            imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        if (buttonIndex==1) {
            NSLog(@"拍照");
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
            imagePicker.delegate=self;
            imagePicker.allowsEditing=YES;//设置是否可编辑。
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置以哪种方式取照片，是从本地相册取，还是从相机拍照取。
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *imageData=UIImagePNGRepresentation(image);//取出相册中的照片数据
    NSString *imgNameStr=[NSString stringWithFormat:@"%.0f.png",[[NSDate date] timeIntervalSince1970]];//运用时间戳给照片取名字。
   BOOL success= [imageData writeToFile:[MyFile fileByDocumentPath:[NSString stringWithFormat:@"/UserHead/%@",imgNameStr]] atomically:YES];//将数据写入沙盒目录中。
    if (success) {

        loginUserInfo.user_head=imgNameStr;//如果写入成功，将照片名字给info对象。
        
        [NSKeyedArchiver archiveRootObject:loginUserInfo toFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];//将这个对象，对象归档在此目录下，
        [[DBUser sharedInfo] changeBanlance:loginUserInfo];//改变数据库的值
        [_tableView reloadData];
         
    }
    [picker dismissViewControllerAnimated:YES completion:nil];//因为 UIImagePickerController为模态跳转而来，所以，用模态跳转，返回。
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

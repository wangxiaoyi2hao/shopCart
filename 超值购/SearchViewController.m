//
//  SearchViewController.m
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "SearchViewController.h"
#import "ShopInfoViewController.h"
#import "SearchCellTableViewCell.h"
#import "DBMarket.h"
#import "GoodsInfo.h"
#import "DBSearch.h"
#import "Toast.h"
#import "ShopInfoViewController.h"
@interface SearchViewController ()
{

    IBOutlet UITableView *_tableView;
    NSMutableArray *searchArray;
    IBOutlet UIView *_viewFoot;
    
    IBOutlet UITextField *_searchText;
}
- (IBAction)closeAction:(id)sender;
- (IBAction)clearAction:(id)sender;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    
}
-(void)viewWillAppear:(BOOL)animated{
 [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    searchArray=[[DBSearch sharedInfo] AllSearchHistory];
}
-(void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return @"历史搜索";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 53;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _viewFoot;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    SearchCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SearchCellTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }
//    GoodsInfo *info=[searchArray objectAtIndex:indexPath.row];
//    cell.labelName.text=info.;
    cell.labelName.text=[searchArray objectAtIndex:indexPath.row];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row==0) {
//        ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
//        UINavigatiooundImage:[UIImage imageNamed:@"newsTopBg_new"] forBarMetrics:UIBarMetricsDefault];
//        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        NSString *searchStr=[searchArray objectAtIndex:indexPath.row];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchInfoNext" object:searchStr];
        
//        ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
//        controller.LikeStr=searchStr;
        [_delegate JumpViewController:searchStr];
        [self dismissViewControllerAnimated:YES completion:nil];
//    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (![textField.text isEqualToString:@""]) {
        [[DBSearch sharedInfo] InsertSearchHistory:textField.text];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchInfoNext" object:textField.text];
        
//         ShopInfoViewController *controller=[[ShopInfoViewController alloc] init];
//         controller.LikeStr=textField.text;
        [_delegate JumpViewController:textField.text];
        [self dismissViewControllerAnimated:YES completion:nil];
        return YES;
    }else{
        [[Toast sharedToastInfo] hideTime:1 makeText:@"请输入搜索内容"];
        return NO;
    }
    
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clearAction:(id)sender {
    [[DBSearch sharedInfo] deleteSearchHistory];
     searchArray=[[DBSearch sharedInfo] AllSearchHistory];
    [[Toast sharedToastInfo] hideTime:1 makeText:@"清空历史记录成功"];
    [_tableView reloadData];
}
@end

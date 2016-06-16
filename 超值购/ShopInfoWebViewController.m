//
//  ShopInfoWebViewController.m
//  超值购
//
//  Created by apple on 15/8/29.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "ShopInfoWebViewController.h"
#import "DBSearch.h"
#import "HelperUtil.h"
@interface ShopInfoWebViewController ()
{

    IBOutlet UIWebView *_webView;
}
@end

@implementation ShopInfoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 28, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    leftBtn.showsTouchWhenHighlighted=YES;
    [leftBtn addTarget:self action:@selector(PotoAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=item;
    self.title=@"具体参数";

    NSString *pathStr=[[NSBundle mainBundle] pathForResource:@"info-detail" ofType:@"html"];
    NSURL *url=[NSURL fileURLWithPath:pathStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
   NSString *webStr=[[DBSearch sharedInfo] selectWebInfo:_goodsId];
    
   NSString *webStr1=[HelperUtil htmlShuangyinhao:webStr];
    
//    NSLog(@"%@",webStr1);
    
    
   NSString *titleStr=[NSString stringWithFormat:@"document.getElementById('content').innerHTML=\"%@\";",webStr1];
    
    [_webView stringByEvaluatingJavaScriptFromString:titleStr];
    
    
//    NSString *titleStr1=[NSString stringWithFormat:@"document.getElementById('author').innerHTML='%@'",_info.lbCount];
//   [webView stringByEvaluatingJavaScriptFromString:titleStr1];
//    NSString *titleStr2=[NSString stringWithFormat:@"document.getElementById('time').innerHTML='%@'",_info.lbTitle];
//    [webView stringByEvaluatingJavaScriptFromString:titleStr2];

}

-(void)PotoAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

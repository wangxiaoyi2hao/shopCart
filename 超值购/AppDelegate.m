//
//  AppDelegate.m
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ShopViewController.h"
#import "UserViewController.h"
#import "HelperUtil.h"
#import "MyFile.h"
#import "LoginViewController.h"
#import "UserInfo.h"
#import <AlipaySDK/AlipaySDK.h>
UserInfo *loginUserInfo;
@interface AppDelegate ()
{

    UITabBarController *tabBar;
    int _tabIndex;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    NSString *pathStr=[[NSBundle mainBundle] pathForResource:@"CZG" ofType:@"sqlite"];
    
    NSString *document=[MyFile fileByDocumentPath:@"/CZG.sqlite"];
    ;
    
//    NSString *isExist=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFile fileByDocumentPath:@"/isExist.archive"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[MyFile fileByDocumentPath:@"/CZG.sqlite"]]) {
        NSLog(@"还没复制过");
        [[NSFileManager defaultManager] copyItemAtPath:pathStr toPath:document error:nil];
//        [NSKeyedArchiver archiveRootObject:@"sureExtst" toFile:[MyFile fileByDocumentPath:@"/isExist.archive"]];
        [[NSFileManager defaultManager] createDirectoryAtPath:[MyFile fileByDocumentPath:@"/UserHead"] withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        
        NSLog(@"已经复制过");
    }

    HomeViewController *controller=[[HomeViewController alloc] init];
    controller.tabBarItem.title=@"首页";
    controller.tabBarItem.image=[UIImage imageNamed:@"icon_home"];
    ShopViewController *controller1=[[ShopViewController alloc] init];
    controller1.tabBarItem.title=@"购物车";
    controller1.tabBarItem.image=[UIImage imageNamed:@"icon_cart"];
    UserViewController *controller2=[[UserViewController alloc] init];
    controller2.tabBarItem.title=@"用户中心";
    controller2.tabBarItem.image=[UIImage imageNamed:@"icon_user"];
    
    tabBar=[[UITabBarController alloc] init];
    tabBar.delegate=self;
    tabBar.viewControllers=@[controller,controller1,controller2];
    [tabBar.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];
    //    [tabBar.tabBar setTintColor:[UIColor redColor]];
    tabBar.tabBar.tintColor=[HelperUtil colorWithHexString:@"#e50012"];
    UINavigationController *controll=[[UINavigationController alloc] initWithRootViewController:tabBar];
    [controll.navigationBar setBackgroundImage:[UIImage imageNamed:@"newsTopBg_new"] forBarMetrics:UIBarMetricsDefault];
    [controll.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    NSLog(@"%@",NSHomeDirectory());
    
    
    
    [self.window setRootViewController:controll];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    int index=(int)tabBarController.selectedIndex;
    loginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFile fileByDocumentPath:@"/isLoginUser.archive"]];
    if (loginUserInfo==nil) {
        if (index==2) {
            LoginViewController *controller=[LoginViewController alloc];
            UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:controller];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"newsTopBg_new"] forBarMetrics:UIBarMetricsDefault];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
            
            [tabBarController presentViewController:nav animated:YES completion:nil];
            tabBarController.selectedIndex=_tabIndex;
        }else{
            _tabIndex=(int)tabBarController.selectedIndex;
        }

        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
    }];
    
    return YES;
}

@end

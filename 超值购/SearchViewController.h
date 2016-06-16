//
//  SearchViewController.h
//  超值购
//
//  Created by apple on 15/8/28.
//  Copyright (c) 2015年 Flipped. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

-(void)JumpViewController:(NSString *)searchStr;

@end

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,assign)id<SearchDelegate>delegate;

@end

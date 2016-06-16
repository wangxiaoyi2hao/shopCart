//
//  MyFile.m
//  属性列表练习（备忘录）
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MyFile.h"

@implementation MyFile

+(NSString *)fileByDocumentPath:(NSString *)filename{
    //取出Document路径
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr=[array objectAtIndex:0];
    
    return [pathStr stringByAppendingString:filename];
}

@end

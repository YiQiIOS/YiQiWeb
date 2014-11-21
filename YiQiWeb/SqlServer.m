//
//  SqlServer.m
//  SqliteDemo
//
//  Created by Wendy on 14-10-14.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import "SqlServer.h"

#define DBNAME      @"yiQiCollection.sqlite"


@implementation SqlServer

@synthesize db;

static SqlServer *sharedInstance = nil;

+ (SqlServer*)sharedInstance
{
    static dispatch_once_t oneToken = 0;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[super allocWithZone: NULL] init];
    });
    return sharedInstance;
}

//重写几个方法，防止创建单例对象时出现错误
-(id) init{
    if(self = [super init])
    {
        //初始化单例对象的各种属性
    }
    return self;
}

+(id)allocWithZone: (struct _NSZone *) zone{
    return [self sharedInstance];
}

//这是单例对象遵循<nscopying>协议时需要实现的方法
-(id) copyWithZone: (struct _NSZone *)zone{
    return self;
}

//获取document目录并返回数据库目录
- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [paths firstObject];
    NSLog(@"=======%@",document);
    NSString *database_path = [document stringByAppendingPathComponent:DBNAME];
    return database_path;
}


-(BOOL) openDB{
    //获取数据库路径
    NSString *path = [self dataFilePath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断数据库是否存在
    BOOL isExists = [fileManager fileExistsAtPath:path];
    
    if (isExists) {
        if(sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
            
            //如果打开数据库失败则关闭数据库
            sqlite3_close(db);
            NSLog(@"Error: open database file.");
            return NO;
        }
        return YES;
    }
    
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
        return YES;
    }else{
        sqlite3_close(db);
        NSLog(@"数据库打开失败！");
        return NO;
    }
    return NO;
}

-(void) closeDB{
    sqlite3_close(db);
}

-(void)exec:(NSString *)sql{
    if ([self openDB]) {
        char *err;
        if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"数据库操作数据失败!");
            NSLog(@"%@",sql);
        }else{
            NSLog(@"数据库操作数据成功!");
        }
        sqlite3_close(db);
    }
}

@end

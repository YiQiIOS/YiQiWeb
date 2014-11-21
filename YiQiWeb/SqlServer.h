//
//  SqlServer.h
//  SqliteDemo
//
//  Created by Wendy on 14-10-14.
//  Copyright (c) 2014年 Wendy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqlServer : NSObject{
    sqlite3 *db;
}

@property (nonatomic) sqlite3 *db;

+(SqlServer *) sharedInstance;
-(BOOL) openDB;
-(void) closeDB;

-(void) exec:(NSString *) sql;
@end

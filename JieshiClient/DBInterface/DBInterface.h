//
//  DBInterface.h
//  BeautyAdvisor
//
//  Created by zsf1937 on 13-11-11.
//  Copyright (c) 2013年 Arcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@protocol DBInterfaceDelegate <NSObject>

@optional
- (void)queryResult:(NSArray *)result withFlag:(int)flag;
- (void)queryResult:(NSArray *)result withFlag:(int)flag fromPageIndex:(int)pageIndex andPageSize:(int)pageSize;

@end

@interface DBInterface : NSObject

+ (id)sharedInstance;

- (int)initDB;
- (void)cleanDBData;

#pragma mark- Database Operation for no thread safe
- (BOOL)tableExists:(Class)tableClass inDB:(FMDatabase *)db;
- (BOOL)createTable:(Class)tableClass inDB:(FMDatabase *)db;
- (BOOL)createIndexOfTable:(Class)tableClass onColumn:(NSString *)columnName inDB:(FMDatabase *)db;
- (NSArray *)queryTable:(Class)tableClass withWhereString:(NSString *)whereString inDB:(FMDatabase *)db;
- (NSArray *)queryTable:(Class)tableClass withWhereString:(NSString *)whereString fromPageIndex:(int)pageIndex andPageSize:(int)pageSize inDB:(FMDatabase *)db;
- (NSArray *)queryString:(NSString *)sqlString inDB:(FMDatabase *)db;
- (int)insertTable:(Class)tableClass withTableObjs:(NSArray *)objs inDB:(FMDatabase *)db;
- (int)updateTableWithTableObjs:(NSArray *)objs inDB:(FMDatabase *)db;
- (int)deleteTableWithTableObjs:(NSArray *)objs inDB:(FMDatabase *)db;
- (int)insertOrUpdateTable:(Class)tableClass withTableObjs:(NSArray *)objs inDB:(FMDatabase *)db;
- (int)executeUpdate:(NSString *)sqlString withArrayOfArguments:(NSArray *)arrayArgvs inDB:(FMDatabase *)db;
- (int)insertOrUpdateDetailTable:(BOOL)bDetail withObjs:(NSArray *)objs inDB:(FMDatabase *)db;
- (BOOL)cleanTable:(Class)tableClass inDB:(FMDatabase *)db;

#pragma mark- Database Operation for thread safe
- (int)queryTable:(Class)tableClass withWhereString:(NSString *)whereString delegate:(id<DBInterfaceDelegate>)delegate;
- (int)queryTable:(Class)tableClass withWhereString:(NSString *)whereString fromPageIndex:(int)pageIndex andPageSize:(int)pageSize delegate:(id<DBInterfaceDelegate>)delegate;
- (int)queryString:(NSString *)sqlString delegate:(id<DBInterfaceDelegate>)delegate;
- (void)insertTable:(Class)tableClass withTableObjs:(NSArray *)objs;
- (void)updateTableWithTableObjs:(NSArray *)objs;
- (void)deleteTableWithTableObjs:(NSArray *)objs;
- (void)insertOrUpdateTable:(Class)tableClass withTableObjs:(NSArray *)objs doAsync:(BOOL)bAsync;
- (void)insertOrUpdateTableObjsInTransaction:(NSArray *)arrayOfObjs;
- (void)executeUpdate:(NSString *)sqlString withArrayOfArguments:(NSArray *)arrayArgvs doAsync:(BOOL)bAsync;
- (void)executeUpdate:(NSArray *)sqlStrings withArraysOfArguments:(NSArray *)arraysArgvs rollbackIfError:(BOOL)bRollback;
- (void)insertOrUpdateDetailTable:(BOOL)bDetail withObjs:(NSArray *)objs;
- (void)insertOrUpdateDetailTableInTransaction:(BOOL)bDetail withArrayOfObjs:(NSArray *)arrayOfObjs;
- (void)cleanTable:(Class)tableClass;
- (void)resetTable:(Class)tableClass withTableObjs:(NSArray *)objs;

@end

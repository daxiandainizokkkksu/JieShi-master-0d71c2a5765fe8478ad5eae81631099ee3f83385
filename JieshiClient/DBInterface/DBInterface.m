//
//  DBInterface.m
//  BeautyAdvisor
//
//  Created by zsf1937 on 13-11-11.
//  Copyright (c) 2013年 Arcsoft. All rights reserved.
//

#import "DBInterface.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "QDataModel.h"

#define DB_FILENAME         @"data.db"

@implementation DBInterface {
    FMDatabaseQueue *dbQueue;
}

+ (id)sharedInstance {
    static DBInterface *instance;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[DBInterface alloc] init];
    });
    return instance;
}

- (int)initDB {
    int nRet = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:DB_FILENAME];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    do {
        if (![db open]) {
            nRet = -1;
            break;
        }
        if ([self tableExists:[QVersionModel class] inDB:db]) {
            nRet = [self checkVersionUpdate:db];
            if (nRet < 0)
                break;
        }
        else {
            //对每个版本新增加的表，对老版本增加对应的表
            //create DBTableVersion
            if ([self createTable:[QVersionModel class] inDB:db]) {
                NSString *dbVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"DBVersion"];
                QVersionModel *obj = [[QVersionModel alloc] init];
                obj.version = dbVersion;
                [self insertTable:[QVersionModel class] withTableObjs:[[NSArray alloc] initWithObjects:obj, nil] inDB:db];
            }
            else {
                debug_NSLog(@"!!!!!     DBTableVersion create table failed!");
                nRet = -2;
                break;
            }
            //version 1.0
            if (![self createTable:[QVillageModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QVillageModel create table failed!");
                nRet = -3;
                break;
            }
            
            if (![self createTable:[QWatershedModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QWatershedModel create table failed!");
                nRet = -4;
                break;
            }
            if (![self createTable:[QStationModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QStationModel create table failed!");
                nRet = -5;
                break;
            }
            else if (![self createTable:[QWorkWaterModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QWorkWaterModel create table failed!");
                nRet = -6;
                break;
            }
            else if (![self createTable:[QWorkDikeModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QWorkDikeModel create table failed!");
                nRet = -7;
                break;
            }
            else if (![self createTable:[QWorkRiverModel class] inDB:db]) {
                debug_NSLog(@"!!!!!     QWorkRiverModel create table failed!");
                nRet = -8;
                break;
            }
            
        }
    } while (0);
    
    [db close];
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    return nRet;
}

- (int)checkVersionUpdate:(FMDatabase *)db {
    int nRet = 0;
    if (db) {
        do {
            NSDictionary *infoList = [[NSBundle mainBundle] infoDictionary];
            NSString *dbVersion = [infoList objectForKey:@"DBVersion"];
            NSString *dbPreVersion;
            NSArray *result = [self queryTable:[QVersionModel class] withWhereString:nil inDB:db];
            for (QVersionModel *tbVersion in result) {
                dbPreVersion = tbVersion.version;
            }
            if (dbPreVersion != nil && [dbVersion compare:dbPreVersion options:NSNumericSearch] == NSOrderedDescending) {
                debug_NSLog(@"DB Version Update");
                //对每个版本新增加的表，对老版本增加对应的表
                if ([dbPreVersion compare:@"1.1" options:NSNumericSearch] == NSOrderedAscending)
                {
                    if (![self tableExists:[QWorkDikeModel class] inDB:db]
                        || [self deleteTable:[QWorkDikeModel class] inDB:db])
                    {
                        if (![self createTable:[QWorkDikeModel class] inDB:db]) {
                            debug_NSLog(@"!!!!!     QWorkRiverModel create table failed!");
                            nRet = -8;
                            break;
                        }
                    }
                    
                    if (![self tableExists:[QWorkRiverModel class] inDB:db]
                        || [self deleteTable:[QWorkRiverModel class] inDB:db])
                    {
                        if (![self createTable:[QWorkRiverModel class] inDB:db]) {
                            debug_NSLog(@"!!!!!     QWorkRiverModel create table failed!");
                            nRet = -8;
                            break;
                        }
                    }
                }
                
                QVersionModel *tbVersion = [[QVersionModel alloc] init];
                tbVersion.version = dbVersion;
                result = [[NSArray alloc] initWithObjects:tbVersion, nil];
                [self updateTableWithTableObjs:result inDB:db];
            }
        } while (0);
    }
    return nRet;
}

- (void)cleanDBData {
    debug_NSLog(@"cleanDBData");
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inDatabase:^(FMDatabase *db) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf cleanTable:[QVillageModel class] inDB:db];
            [strongSelf cleanTable:[QWatershedModel class] inDB:db];
            [strongSelf cleanTable:[QStationModel class] inDB:db];
            [strongSelf cleanTable:[QWorkWaterModel class] inDB:db];
            [strongSelf cleanTable:[QWorkDikeModel class] inDB:db];
            [strongSelf cleanTable:[QWorkRiverModel class] inDB:db];
        }
    }];
}


#pragma mark- Database Operation for no thread safe
- (BOOL)tableExists:(Class)tableClass inDB:(FMDatabase *)db {
    NSString *tableName = [tableClass tableName];
    return [db tableExists:tableName];
}

- (BOOL)createTable:(Class)tableClass inDB:(FMDatabase *)db {
    NSString *sqlString = [tableClass createSQLString];
    if (!sqlString)
        return NO;
    return [db executeUpdate:sqlString];
}

// 删除表
- (BOOL) deleteTable:(Class)tableClass inDB:(FMDatabase *)db
{
    NSString *tableName = [tableClass tableName];
    NSString *sqlString = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    return [db executeUpdate:sqlString];
}

- (BOOL)createIndexOfTable:(Class)tableClass onColumn:(NSString *)columnName inDB:(FMDatabase *)db {
    NSString *sqlString = [tableClass createIndexStringOfColumn:columnName];
    if (!sqlString)
        return NO;
    return [db executeUpdate:sqlString];
}

- (NSArray *)queryTable:(Class)tableClass withWhereString:(NSString *)whereString inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------1、Thread: %@", [NSThread currentThread]);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *sqlString = [tableClass querySQLStringWithWhereString:whereString];
    FMResultSet *rs = [db executeQuery:sqlString];
    while ([rs next]) {
        id r = [[tableClass alloc] initFromFMResultSet:rs];
        [result addObject:r];
    }
    [rs close];
    return result;
}

- (NSArray *)queryTable:(Class)tableClass withWhereString:(NSString *)whereString fromPageIndex:(int)pageIndex andPageSize:(int)pageSize inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------2、Thread: %@", [NSThread currentThread]);
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSString *sqlString = [[tableClass querySQLStringWithWhereString:whereString] stringByAppendingFormat:@" Limit %d Offset %d", pageSize, pageSize*(pageIndex-1)];
    FMResultSet *rs = [db executeQuery:sqlString];
    while ([rs next]) {
        id r = [[tableClass alloc] initFromFMResultSet:rs];
        [result addObject:r];
    }
    [rs close];
    return result;
}

- (NSArray *)queryString:(NSString *)sqlString inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------3、Thread: %@", [NSThread currentThread]);
    NSMutableArray *result = [NSMutableArray array];
    FMResultSet *rs = [db executeQuery:sqlString];
    while ([rs next]) {
        NSDictionary *r = [rs resultDictionary];
        [result addObject:r];
    }
    [rs close];
    return result;
}

- (int)insertTable:(Class)tableClass withTableObjs:(NSArray *)objs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------4、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    NSString *sqlString = [tableClass insertSQLString];
    if (!sqlString)
        return -1;;
    for (id obj in objs) {
        if ([obj class] != tableClass)
            continue;
        NSArray *argv = [obj convertPropertyValueToNSArray];
        if (!argv)
            continue;
        if (![db executeUpdate:sqlString withArgumentsInArray:argv])
            nError++;
    }
    return nError;
}

- (int)updateTableWithTableObjs:(NSArray *)objs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------5、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    for (id obj in objs) {
        NSString *sqlString = [obj updateSQLString];
        if (!sqlString)
            continue;
        NSArray *argv = [obj getArrayValuesForUpdate];
        if (!argv)
            continue;
        if (![db executeUpdate:sqlString withArgumentsInArray:argv])
            nError++;
    }
    return nError;
}

- (int)deleteTableWithTableObjs:(NSArray *)objs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------6、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    for (id obj in objs) {
        NSString *sqlString = [obj deleteSQLString];
        if (!sqlString)
            continue;
        NSArray *argv = [obj getArrayValuesForDelete];
        if (![db executeUpdate:sqlString withArgumentsInArray:argv])
            nError++;
    }
    return nError;
}

- (int)insertOrUpdateTable:(Class)tableClass withTableObjs:(NSArray *)objs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------7、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    NSString *sqlString = [tableClass insertOrUpdateSQLString];
    if (!sqlString)
        return -1;
    for (id obj in objs) {
        if ([obj class] != tableClass)
            continue;
        NSArray *argv = [obj convertPropertyValueToNSArray];
        if (!argv)
            continue;
        if (![db executeUpdate:sqlString withArgumentsInArray:argv])
            nError++;
    }
    return nError;
}

- (int)executeUpdate:(NSString *)sqlString withArrayOfArguments:(NSArray *)arrayArgvs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------8、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    if (!sqlString)
        return -1;
    for (id argvs in arrayArgvs) {
        if (![db executeUpdate:sqlString withArgumentsInArray:argvs])
            nError++;
    }
    return nError;
}

- (int)insertOrUpdateDetailTable:(BOOL)bDetail withObjs:(NSArray *)objs inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------9、Thread: %@", [NSThread currentThread]);
    int nError = 0;
    for (id obj in objs) {
        BOOL bExist = NO;
        NSString *existSQLString = [obj queryExistSQLString];
        FMResultSet *rs = [db executeQuery:existSQLString];
        while ([rs next]) {
            bExist = YES;
            break;
        }
        [rs close];
        Class tableClass = [obj class];
        NSString *sqlString;
        NSArray *argvs;
        if (bExist) {
            sqlString = [tableClass updateSQLString:bDetail];
            argvs = [obj getArrayValuesForUpdate:bDetail];
        }
        else {
            sqlString = [tableClass insertSQLString];
            argvs = [obj convertPropertyValueToNSArray];
        }
        if (![db executeUpdate:sqlString withArgumentsInArray:argvs])
            nError++;
    }
    return nError;
}

- (BOOL)cleanTable:(Class)tableClass inDB:(FMDatabase *)db {
    debug_NSLog(@"------------------10、Thread: %@", [NSThread currentThread]);
    NSString *cleanSQLString = [NSString stringWithFormat:@"delete from %@", [tableClass tableName]];
    return [db executeUpdate:cleanSQLString];
}

#pragma mark- Database Operation for thread safe
- (int)getQueryFlag {
    static int s_Flag = 1;
    @synchronized(self) {
        return s_Flag++;
    }
}

- (int)queryTable:(Class)tableClass withWhereString:(NSString *)whereString delegate:(id<DBInterfaceDelegate>)delegate {
    if (!dbQueue)
        return -1;
    
    int flag = [self getQueryFlag];
    __weak id weakSelf = self;
    __weak id<DBInterfaceDelegate> weakDelegate = delegate;
    [dbQueue inDatabase:^(FMDatabase *db) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            NSArray *result = [strongSelf queryTable:tableClass withWhereString:whereString inDB:db];
            id<DBInterfaceDelegate> strongDelegate = weakDelegate;
            if (strongDelegate && [strongDelegate respondsToSelector:@selector(queryResult:withFlag:)]) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongDelegate queryResult:result withFlag:flag];
                });
            }
        }
    }];
    return flag;
}

- (int)queryTable:(Class)tableClass withWhereString:(NSString *)whereString fromPageIndex:(int)pageIndex andPageSize:(int)pageSize delegate:(id<DBInterfaceDelegate>)delegate {
    if (!dbQueue)
        return -1;
    
    int flag = [self getQueryFlag];
    __weak id weakSelf = self;
    __weak id<DBInterfaceDelegate> weakDelegate = delegate;
    [dbQueue inDatabase:^(FMDatabase *db) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            NSArray *result = [strongSelf queryTable:tableClass withWhereString:whereString fromPageIndex:pageIndex andPageSize:pageSize inDB:db];
            id<DBInterfaceDelegate> strongDelegate = weakDelegate;
            if (strongDelegate && [strongDelegate respondsToSelector:@selector(queryResult:withFlag:fromPageIndex:andPageSize:)]) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongDelegate queryResult:result withFlag:flag fromPageIndex:pageIndex andPageSize:pageSize];
                });
            }
        }
    }];
    return flag;
}

- (int)queryString:(NSString *)sqlString delegate:(id<DBInterfaceDelegate>)delegate {
    if (!dbQueue)
        return -1;
    
    int flag = [self getQueryFlag];
    __weak id weakSelf = self;
    __weak id<DBInterfaceDelegate> weakDelegate = delegate;
    [dbQueue inDatabase:^(FMDatabase *db) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            NSArray *result = [strongSelf queryString:sqlString inDB:db];
            id<DBInterfaceDelegate> strongDelegate = weakDelegate;
            if (strongDelegate && [strongDelegate respondsToSelector:@selector(queryResult:withFlag:)]) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [strongDelegate queryResult:result withFlag:flag];
                });
            }
        }
    }];
    return flag;
}

- (void)insertTable:(Class)tableClass withTableObjs:(NSArray *)objs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf insertTable:tableClass withTableObjs:objs inDB:db];
        }
    }];
}

- (void)updateTableWithTableObjs:(NSArray *)objs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf updateTableWithTableObjs:objs inDB:db];
        }
    }];
}

- (void)deleteTableWithTableObjs:(NSArray *)objs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf deleteTableWithTableObjs:objs inDB:db];
        }
    }];
}

- (void)insertOrUpdateTable:(Class)tableClass withTableObjs:(NSArray *)objs doAsync:(BOOL)bAsync {
    if (!dbQueue)
        return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf insertOrUpdateTable:tableClass withTableObjs:objs inDB:db];
        }
        if (!bAsync)
            dispatch_semaphore_signal(sema);
    }];
    if (!bAsync) {
        dispatch_semaphore_wait(sema, 3.0f * NSEC_PER_SEC);
    }
    FMDBDispatchQueueRelease(sema);
}

- (void)insertOrUpdateTableObjsInTransaction:(NSArray *)arrayOfObjs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            for (NSArray *objs in arrayOfObjs) {
                if ([objs count] <= 0)
                    continue;
                Class tableClass = [objs[0] class];
                if ([strongSelf insertOrUpdateTable:tableClass withTableObjs:objs inDB:db] != 0) {
                    *rollback = YES;
                    return;
                }
            }
        }
    }];
}

- (void)executeUpdate:(NSString *)sqlString withArrayOfArguments:(NSArray *)arrayArgvs doAsync:(BOOL)bAsync {
    if (!dbQueue)
        return;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf executeUpdate:sqlString withArrayOfArguments:arrayArgvs inDB:db];
        }
        if (!bAsync)
            dispatch_semaphore_signal(sema);
    }];
    if (!bAsync) {
        dispatch_semaphore_wait(sema, 3.0f * NSEC_PER_SEC);
    }
    FMDBDispatchQueueRelease(sema);
}

- (void)executeUpdate:(NSArray *)sqlStrings withArraysOfArguments:(NSArray *)arraysArgvs rollbackIfError:(BOOL)bRollback {
    if (!dbQueue || [sqlStrings count] != [arraysArgvs count])
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            NSUInteger nCount = [sqlStrings count];
            for (int i=0; i<nCount; i++) {
                NSString *sqlString = sqlStrings[i];
                NSArray *arrayArgvs = arraysArgvs[i];
                if ([strongSelf executeUpdate:sqlString withArrayOfArguments:arrayArgvs inDB:db] != 0 && bRollback) {
                    *rollback = YES;
                    return;
                }
            }
        }
    }];
}

- (void)insertOrUpdateDetailTable:(BOOL)bDetail withObjs:(NSArray *)objs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf insertOrUpdateDetailTable:bDetail withObjs:objs inDB:db];
        }
    }];
}

- (void)insertOrUpdateDetailTableInTransaction:(BOOL)bDetail withArrayOfObjs:(NSArray *)arrayOfObjs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            for (NSArray *objs in arrayOfObjs) {
                if ([objs count] <= 0)
                    continue;
                Class tableClass = [objs[0] class];
                if ([strongSelf insertOrUpdateTable:tableClass withTableObjs:objs inDB:db] != 0) {
                    *rollback = YES;
                    return;
                }
            }
        }
    }];
}

- (void)cleanTable:(Class)tableClass {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf cleanTable:tableClass inDB:db];
        }
    }];
}

- (void)resetTable:(Class)tableClass withTableObjs:(NSArray *)objs {
    if (!dbQueue)
        return;
    
    __weak id weakSelf = self;
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf cleanTable:tableClass inDB:db];
            [strongSelf insertOrUpdateTable:tableClass withTableObjs:objs inDB:db];
        }
    }];
}

@end

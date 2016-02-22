//
//  ASUserDefaults.m
//  HRClient
//
//  Created by amy.fu on 15-3-8.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "ASUserDefaults.h"

@implementation ASUserDefaults

+ (id)objectForKey:(NSString*)akey
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:akey];
}

+ (void)removeObjectForKey:(NSString*)akey
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:akey];
}

+ (void)setObject:(id)anObject forKey:(id)akey
{
    [[NSUserDefaults standardUserDefaults] setObject:anObject forKey:akey];
}

+ (NSString *)stringForKey:(NSString *)akey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:akey];
}

+ (BOOL)boolForKey:(NSString*)akey defaultValue:(BOOL)defaultValue
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:akey];
    if (num) {
        return [num boolValue];
    }
    return defaultValue;
}

+ (void)setBool:(BOOL)value forKey:(NSString *)aKey
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:aKey];
}

+ (int)intForKey:(NSString*)akey defaultValue:(int)defaultValue
{
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:akey];
    if (num) {
        return [num intValue];
    }
    return defaultValue;
}

+ (void)setInt:(int)value forKey:(NSString *)aKey
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:value] forKey:aKey];
}

+ (BOOL)synchronize
{
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setSearchHistoryData:(NSString*)searchKey andItem:(NSString*)item
{
    NSMutableArray *data = [ASUserDefaults objectForKey:searchKey];
    if (data)
    {
        NSMutableArray *array = [NSMutableArray arrayWithArray:data];
        BOOL add = YES;
        for (NSString *x in data)
        {
            if ([x isEqualToString:item])
            {
                add = NO;
                break;
            }
        }
        if (add)
        {
            [array insertObject:item atIndex:1];
        }
        if (array.count > (MaxSearchDataCount + 1))
        {
            for (int i = 0; i < (array.count - (MaxSearchDataCount + 1)); i++)
            {
                [array removeObjectAtIndex:i + MaxSearchDataCount + 1];
            }
        }
        
        [ASUserDefaults setObject:array forKey:searchKey];
    }
    else
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithObjects:item, nil];
        [ASUserDefaults setObject:dataArray forKey:searchKey];
    }
}

+ (NSArray*)getSearchHistoryData:(NSString*)searchKey
{
    return [ASUserDefaults objectForKey:searchKey];
}

@end

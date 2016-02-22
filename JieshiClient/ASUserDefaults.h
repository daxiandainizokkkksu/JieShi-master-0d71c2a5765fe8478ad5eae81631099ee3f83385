//
//  ASUserDefaults.h
//  HRClient
//
//  Created by amy.fu on 15-3-8.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GuideViewVersion            @"GuideViewVersion"
#define AppCurrentLocation          @"AppCurrentLocation"   
#define LoginUserName               @"LoginUserName"
#define LoginUserPassword           @"LoginUserPassword"
#define LoginIsRememberPwd          @"LoginIsRememberPwd"
#define LoginIsAuto                 @"LoginIsAuto"

@interface ASUserDefaults : NSObject

+ (id)objectForKey:(NSString*)akey;
+ (NSString *)stringForKey:(NSString*)akey;
+ (BOOL)boolForKey:(NSString*)akey defaultValue:(BOOL)defaultValue;
+ (int)intForKey:(NSString*)akey defaultValue:(int)defaultValue;
+ (BOOL)synchronize;
+ (void)setObject:(id)anObject forKey:(id)akey;
+ (void)setBool:(BOOL)value forKey:(NSString *)aKey;
+ (void)setInt:(int)value forKey:(NSString *)aKey;


//搜索相关
#define MaxSearchDataCount          5
+ (void)setSearchHistoryData:(NSString*)searchKey andItem:(NSString*)item;
+ (NSArray*)getSearchHistoryData:(NSString*)searchKey;

@end

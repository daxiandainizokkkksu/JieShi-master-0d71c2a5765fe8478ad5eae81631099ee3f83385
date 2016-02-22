//
//  ASUtils.h
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIColor+ASColor.h"
#import "NSDictionary+Helper.h"

#ifdef DEBUG
#define debug_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_NSLog(format, ...)
#endif

#define NSString_No_Nil(x) x ? x : @""

#define SCREEN_SIZE_WIDTH     ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_SIZE_HEIGHT    ([[UIScreen mainScreen] bounds].size.height)
#define ScreenWidth            ([[UIScreen mainScreen] bounds].size.width)
#define ScreenHeight            ([[UIScreen mainScreen] bounds].size.height)



@interface ASUtils : NSObject

+ (NSDateFormatter *)sharedHttpDateFormatter;


+ (NSString *)md5:(NSData *)data;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIColor *)getColor:(NSString *)hexColor;

+ (NSString*)stringfromDate:(NSDate*)date andDay:(BOOL)isDay;
+ (NSString*)stringfromDate:(NSDate*)date;
+ (NSDate*)datefromString:(NSString*)string;

+ (NSString*)guidString;

+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height;

@end

//
//  ASUtils.m
//  YDSHClient
//
//  Created by amy.fu on 15/3/25.
//  Copyright (c) 2015年 amy.fu. All rights reserved.
//

#import "ASUtils.h"
#import <CommonCrypto/CommonDigest.h>


static NSDateFormatter *sharedHttpDateFormatter = nil;

@implementation ASUtils

+ (NSDateFormatter *)sharedHttpDateFormatter {
    @synchronized(self) {
        if (sharedHttpDateFormatter == nil) {
            sharedHttpDateFormatter = [[NSDateFormatter alloc] init];
            [sharedHttpDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        }
    }
    return sharedHttpDateFormatter;
}


+ (NSString *)md5:(NSData *)data {
    NSString *result = nil;
    do {
        if (!data) {
            break;
        }
        unsigned char tmp[CC_MD5_DIGEST_LENGTH] = {0};
        CC_MD5(data.bytes, data.length, tmp);
        result = [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X", tmp[0], tmp[1], tmp[2], tmp[3], tmp[4], tmp[5], tmp[6], tmp[7], tmp[8], tmp[9], tmp[10], tmp[11], tmp[12], tmp[13], tmp[14], tmp[15]] lowercaseString];
    } while (NO);
    return result;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

+ (NSString*)stringfromDate:(NSDate*)date andDay:(BOOL)isDay
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    
    return [[dateFormatter stringFromDate:[calendar dateFromComponents:comps]] stringByAppendingString:@"时"];
}

+ (NSString*)stringfromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    return [[dateFormatter stringFromDate:date] stringByAppendingString:@"时"];
}

+ (NSDate*)datefromString:(NSString*)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH时"];
    
    return [dateFormatter dateFromString:string];
}

+ (NSString*)guidString
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidString = CFUUIDCreateString(NULL, uuid);
    NSString * ret = [NSString stringWithString:(__bridge NSString *)uuidString];
    CFRelease(uuidString);
    CFRelease(uuid);
    return ret;
}

+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height
{
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(CGSizeMake(width, height));  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end

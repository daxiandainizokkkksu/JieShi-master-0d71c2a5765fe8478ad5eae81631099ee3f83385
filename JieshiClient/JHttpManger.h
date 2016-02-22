//
//  JHttpManger.h
//  JieshiClient
//
//  Created by amy.fu on 15/10/21.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define BaseUrl             @"http://demo1.dayuteam.cn"
#define CheckDevice         @"/jieshi/apiAuth/checkDevice"
#define Login               @"/jieshi/apiAuth/login"
#define LogOut              @"/jieshi/apiAuth/logout"

@interface JHttpManger : NSObject

+ (JHttpManger *)sharedHttpManager;

- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;
- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail;

@end

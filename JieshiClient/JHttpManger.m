//
//  JHttpManger.m
//  JieshiClient
//
//  Created by amy.fu on 15/10/21.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "JHttpManger.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface JHttpManger ()
{
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *getRequestOperationManger;
@property (nonatomic, strong) AFHTTPRequestOperationManager *postRequestOperationManger;

@end


static JHttpManger *httpManager = nil;

@implementation JHttpManger

+ (JHttpManger *)sharedHttpManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpManager = [[super allocWithZone:NULL] init];
    });
    return httpManager;
}

- (id)init
{
    if (self = [super init]) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];//状态栏菊花
    }
    return self;
}

- (AFHTTPRequestOperationManager*)getRequestOperationManger
{
    if (!_getRequestOperationManger) {
        _getRequestOperationManger = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    }
    return _getRequestOperationManger;
}

- (AFHTTPRequestOperationManager*)postRequestOperationManger
{
    if (!_postRequestOperationManger) {
        _postRequestOperationManger = [[AFHTTPRequestOperationManager manager] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
        // 设置请求格式
//        _postRequestOperationManger.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置返回格式
//        _postRequestOperationManger.responseSerializer = [AFHTTPResponseSerializer serializer];
        _postRequestOperationManger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
    return _postRequestOperationManger;
}

#pragma mark - Methods

- (void)GET:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    [self.getRequestOperationManger GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

- (void)POST:(NSString *)url parameters:(id)parameters success:(void (^)(id responseObject))success fail:(void (^)(NSError *error))fail
{
    [self.postRequestOperationManger POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        if (fail) {
            fail(error);
        }
    }];
}

@end

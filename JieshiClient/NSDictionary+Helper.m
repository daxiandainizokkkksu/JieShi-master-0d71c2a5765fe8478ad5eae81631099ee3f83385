//
//  NSDictionary+Helper.m
//  JieshiClient
//
//  Created by amy.fu on 15/10/21.
//  Copyright (c) 2015年 dayu. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

- (id)safeObjectForKey:(id)key {
	id value = [self valueForKey:key];
	if (value == [NSNull null]) {
		return nil;
	}
	return value;
}

@end
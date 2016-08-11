//
//  twtSecretKeys.h
//  WePeiYang
//
//  Created by 秦昱博 on 14-7-15.
//  Copyright (c) 2014年 Qin Yubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface twtSecretKeys : NSObject

+ (NSString *)getSecretKey;
//+ (NSString *)getRavenKey;
+ (NSString *)getDevKey;
//+ (NSString *)getFIRKey;
+ (NSString *)getWechatAppId;
+ (NSString *)getTWTAppKey;
+ (NSString *)getTWTAppSecret;
/*
+ (NSString *)getShareSDKAppKey;
+ (NSString *)getWeiboAppKey;
+ (NSString *)getWeiboAppSecret;
+ (NSString *)getTencentWeiboAppKey;
+ (NSString *)getTencentWeiboAppSecret;
+ (NSString *)getQZoneAppKey;
+ (NSString *)getQZoneAppSecret;
+ (NSString *)getRenrenAppKey;
+ (NSString *)getRenrenAppSecret;
+ (NSString *)getFacebookAppKey;
+ (NSString *)getFacebookAppSecret;
+ (NSString *)getTwitterConsumerKey;
+ (NSString *)getTwitterConsumerSecret;
+ (NSString *)getQQWithQZoneAppKey;
 */

@end

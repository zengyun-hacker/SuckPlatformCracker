//
//  OauthClient.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "AFHTTPClient.h"
#import "BlockTypeDefine.h"

typedef NS_ENUM(NSInteger, OauthFailType)
{
    kOauthFailUserCancel = 100,
    kOauthFailWebviewFail = 101,
    kOauthFailAccessTokenFail = 102,
    kOauthFailOthers = 110,
};

@interface OauthClient : AFHTTPClient

///access token
@property (nonatomic,copy) NSString *accessToken;
///过期时间
@property (nonatomic) NSTimeInterval expireTime;
///是否登录
@property (nonatomic) BOOL isLogin;
///是否过期
@property (nonatomic) BOOL isExpired;
///覆盖只读的baseURL
@property (readwrite, nonatomic, strong) NSURL *baseURL;

- (void)startOauthAuthorization:(ZYBlock)success failure:(OauthFailureBlock)failure;

/*
 Oauth授权方法
 param 授权地址
 return 授权成功将access token,expire time赋值给自己
 */
- (void)startOauthAuthorization:(NSString *)oauthUrl success:(ZYBlock)success failure:(OauthFailureBlock)failure;

/*
 向服务器发送请求，获取access token。需要被子类重写
 */
- (void)retrieveAccessToken:(NSString *)authorizationCode success:(ZYBlock)success failure:(OauthFailureBlock)failure;

/*
 判断用户是否取消了授权，需要子类重写
 */
- (BOOL)authorizationCanceled:(NSString *)returnURL;

/*
 获取authorization code
 */
- (NSString *)getAuthorizationCode:(NSString *)oauthUrl;

/*
 退出登录
 */
- (void)logout;

@end

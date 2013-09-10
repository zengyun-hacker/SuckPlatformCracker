//
//  WeiboOauthClient.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-10.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "WeiboOauthClient.h"
#import "Constants.h"
#import <AFNetworking.h>
#import "GVUserDefaults+WeiboOauth.h"
#import <JSONKit.h>

static NSString * const WEIBO_OAUTH_URL = @"https://api.weibo.com/oauth2/authorize";
static NSString * const WEIBO_TOKEN_BASE_URL = @"https://api.weibo.com";
static NSString * const WEIBO_TOKEN_PATH = @"/oauth2/access_token";
static NSString * const WEIBO_POST_PATH = @"/2/statuses/update.json";

@implementation WeiboOauthClient

SINGLETON_GCD(WeiboOauthClient)

- (WeiboOauthClient *)init {
    NSURL *baseURL = [NSURL URLWithString:WEIBO_TOKEN_BASE_URL];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    }
    
    return self;
}

- (NSString *)authorizationCodeURL {
    return [NSString stringWithFormat:@"%@?display=mobile&client_id=%@&response_type=code&redirect_uri=%@",WEIBO_OAUTH_URL,WEIBO_APP_KEY,REDIRECT_URL];
}

- (BOOL)isLogin {
    return (self.accessToken && !self.isExpired);
}

- (BOOL)isExpired {
    NSTimeInterval nowTimeInterval = [[NSDate date] timeIntervalSince1970];
    if (nowTimeInterval < self.expireTime) {
        return NO;
    }
    
    return YES;
}

- (NSString *)accessToken {
    return USER_DEFAULTS.weiboAccessToken;
}

- (NSTimeInterval)expireTime {
    return USER_DEFAULTS.weiboExpireTime;
}

- (void)setAccessToken:(NSString *)accessToken {
    USER_DEFAULTS.weiboAccessToken = accessToken;
}

- (void)setExpireTime:(NSTimeInterval)expireTime {
    USER_DEFAULTS.weiboExpireTime = expireTime;
}

- (void)logout {
    self.accessToken = nil;
    self.expireTime = 0;
}

- (void)startOauthAuthorization:(ZYBlock)success failure:(OauthFailureBlock)failure {
    [self startOauthAuthorization:[self authorizationCodeURL] success:^{
        success();
    } failure:^(NSInteger failureCode) {
        failure(failureCode);
    }];
}

///新浪sso授权
- (void)weiboSsoAuthorization:(ZYBlock)success failure:(ZYBlock)failure {
    NSDictionary *param = @{@"client_id": WEIBO_APP_KEY,@"code":WEIBO_APP_SECRET,}
}

- (NSString *)getAuthorizationCode:(NSString *)oauthUrl {
    if ([oauthUrl rangeOfString:@"code="].location != NSNotFound && [oauthUrl rangeOfString:REDIRECT_URL].location != NSNotFound) {
        //如果是redirect url且返回格式正确
        NSRange codeRange = [oauthUrl rangeOfString:@"code="];
        //定位到code的起始处
        codeRange.location += codeRange.length;
        //长度为code起始处到整个文本的结尾处
        codeRange.length = oauthUrl.length - codeRange.location;
        return [oauthUrl substringWithRange:codeRange];
    }
    return nil;
}

- (void)retrieveAccessToken:(NSString *)authorizationCode success:(ZYBlock)success failure:(OauthFailureBlock)failure {
    NSDictionary *param = @{@"client_id": WEIBO_APP_KEY,@"client_secret":WEIBO_APP_SECRET,@"grant_type":@"authorization_code",@"redirect_uri":REDIRECT_URL,@"code":authorizationCode};
    [self postPath:WEIBO_TOKEN_PATH parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.accessToken = responseObject[@"access_token"];
        self.expireTime = [responseObject[@"expires_in"] doubleValue] + [[NSDate date] timeIntervalSince1970];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(kOauthFailAccessTokenFail);
    }];
}

- (void)sendPost:(NSString *)postText success:(ZYBlock)success failure:(ZYBlock)failure{
    ZYBlock postBlock = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.accessToken forKey:@"access_token"];
        if (postText) {
            [param setObject:postText forKey:@"status"];
        }
        [self postPath:WEIBO_POST_PATH parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
        }];
    };
    
    if (self.isLogin) {
        postBlock();
    }
    else {
        [self startOauthAuthorization:^{
            postBlock();
        } failure:^(NSInteger failureCode) {
            failure();
        }];
    }
}

@end

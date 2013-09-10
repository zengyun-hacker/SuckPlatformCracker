//
//  DoubanOauthClient.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "DoubanOauthClient.h"
#import "Constants.h"
#import <AFNetworking.h>
#import "GVUserDefaults+DoubanOauth.h"

//获取authorization code的链接
static NSString * const DOUBAN_OAUTH_URL = @"https://www.douban.com/service/auth2/auth";
//获取access token的链接
static NSString * const DOUBAN_TOKEN_BASE_URL = @"https://www.douban.com";
static NSString * const DOUBAN_API_BASE_URL = @"https://api.douban.com";
static NSString * const DOUBAN_TOKEN_PATH = @"/service/auth2/token";
static NSString * const DOUBAN_SHUOSHUO_PATH = @"shuo/v2/statuses/";

@implementation DoubanOauthClient

//单例化
SINGLETON_GCD(DoubanOauthClient);

- (BOOL)isLogin {
    if (self.accessToken && self.userID && !self.isExpired) {
        return YES;
    }
    return NO;
}

- (BOOL)isExpired {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    if (interval < self.expireTime) {
        return NO;
    }
    
    return YES;
}

- (NSString *)refreshToken {
    return USER_DEFAULTS.doubanRefreshToken;
}

- (NSNumber *)userID {
    return USER_DEFAULTS.doubanUserID;
}

- (NSString *)accessToken {
    return USER_DEFAULTS.doubanAccessToken;
}

- (NSTimeInterval)expireTime {
    return USER_DEFAULTS.doubanExpireTime;
}

- (void)setRefreshToken:(NSString *)refreshToken {
    USER_DEFAULTS.doubanRefreshToken = refreshToken;
}

- (void)setAccessToken:(NSString *)accessToken {
    USER_DEFAULTS.doubanAccessToken = accessToken;
}

- (void)setUserID:(NSNumber *)userID {
    USER_DEFAULTS.doubanUserID = userID;
}

- (void)setExpireTime:(NSTimeInterval)expireTime {
    USER_DEFAULTS.doubanExpireTime = expireTime;
}

- (NSString *)authorizationCodeURL {
    return [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code",DOUBAN_OAUTH_URL,DOUBAN_API_KEY,REDIRECT_URL];
}

- (DoubanOauthClient *)init {
    NSURL *baseURL = [NSURL URLWithString:DOUBAN_TOKEN_BASE_URL];
    self = [super initWithBaseURL:baseURL];
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    return self;
}

- (void)startOauthAuthorization:(ZYBlock)success failure:(OauthFailureBlock)failure {
    [self startOauthAuthorization:[self authorizationCodeURL] success:^{
        success();
    } failure:^(NSInteger failureCode) {
        failure(failureCode);
    }];
}


///因为授权的头信息格式不一样，所以要重写父类方法
- (void)setAuthorizationHeaderWithToken:(NSString *)token {
    [self setDefaultHeader:@"Authorization" value:[NSString stringWithFormat:@"Bearer %@",token]];
}

- (BOOL)authorizationCanceled:(NSString *)returnURL {
    if ([returnURL rangeOfString:@"error=access_denied"].location != NSNotFound) {
        //如果链接中有用户取消，则确定为用户取消了授权
        return YES;
    }
    return NO;
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
    NSDictionary *param = @{@"client_id": DOUBAN_API_KEY,@"client_secret":DOUBAN_APP_SECRET,@"redirect_uri":REDIRECT_URL,@"grant_type":@"authorization_code",@"code":authorizationCode};
    self.baseURL = [NSURL URLWithString:DOUBAN_TOKEN_BASE_URL];
    [self postPath:DOUBAN_TOKEN_PATH parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.accessToken = responseObject[@"access_token"];
        self.expireTime = [responseObject[@"expires_in"] doubleValue] + [[NSDate date] timeIntervalSince1970];
        self.refreshToken = responseObject[@"refresh_token"];
        self.userID = responseObject[@"douban_user_id"];
        success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(kOauthFailAccessTokenFail);
    }];
}

- (void)logout {
    self.accessToken = nil;
    self.refreshToken = nil;
    self.userID = nil;
    self.expireTime = 0;
}

- (void)sendPost:(NSString *)postText withImage:(UIImage *)postImage withRecTitle:(NSString *)recTitle withRecUrl:(NSString *)recUrl withRecDes:(NSString *)recDesc withRecImageUrl:(NSString *)recImageUrl success:(ZYBlock)success failure:(ZYBlock)failure{
    ZYBlock postBlock = ^{
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:DOUBAN_API_KEY forKey:@"source"];
        
        if (postText) {
            [param setObject:postText forKey:@"text"];
        }
        
        if (postImage) {
            [param setObject:postImage forKey:@"image"];
        }
        
        if (recTitle) {
            [param setObject:recTitle forKey:@"rec_title"];
        }
        
        if (recUrl) {
            [param setObject:recUrl forKey:@"rec_url"];
        }
        
        if (recDesc) {
            [param setObject:recDesc forKey:@"rec_desc"];
        }
        
        if (recImageUrl) {
            [param setObject:recImageUrl forKey:@"rec_image"];
        }
        
        self.baseURL = [NSURL URLWithString:DOUBAN_API_BASE_URL];
        [self setAuthorizationHeaderWithToken:self.accessToken];
        [self postPath:DOUBAN_SHUOSHUO_PATH parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            success();
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure();
        }];
        
        [self clearAuthorizationHeader];
    };
    
    if (self.isLogin) {
        //如果已经授权，则直接发送文字
        postBlock();
    }
    else {
        //如果未授权，则先跳转到授权界面
        [self startOauthAuthorization:^{
            postBlock();
        } failure:^(NSInteger failureCode) {
            failure();
        }];
    }

}

@end

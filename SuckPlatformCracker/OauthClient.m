//
//  OauthClient.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "OauthClient.h"
#import "AuthorizationControl.h"

@interface OauthClient ()

@property (nonatomic,strong) AuthorizationControl *authorizationController;

@end

@implementation OauthClient

- (AuthorizationControl *)authorizationController {
    if (!_authorizationController) {
        _authorizationController = [[AuthorizationControl alloc] init];
    }
    return _authorizationController;
}

- (void)startOauthAuthorization:(ZYBlock)success failure:(OauthFailureBlock)failure{
    
}

- (void)retrieveAccessToken:(NSString *)authorizationCode success:(ZYBlock)success failure:(OauthFailureBlock)failure{
    
}

- (BOOL)authorizationCanceled:(NSString *)returnURL {
    
}

- (NSString *)getAuthorizationCode:(NSString *)oauthUrl {
    
}

- (void)logout {
    
}

- (void)startOauthAuthorization:(NSString *)oauthUrl success:(ZYBlock)success failure:(OauthFailureBlock)failure {
    //跳转到授权界面
    [self loadOauthURL:oauthUrl finish:^(NSString *finishUrl) {
        if ([self webViewLoadFailed:finishUrl]) {
            //若网页载入失败，直接跳转到失败
            [self.authorizationController hide];
            failure(kOauthFailWebviewFail);
            return;
        }
        if ([self authorizationCanceled:finishUrl]) {
            //若用户取消授权，直接跳转到失败
            [self.authorizationController hide];
            failure(kOauthFailUserCancel);
            return;
        }
        //获取authorization code
        NSString *authorizationCode = [self getAuthorizationCode:finishUrl];
        //获取access token
        if (authorizationCode) {
            [self retrieveAccessToken:authorizationCode success:^{
                [self.authorizationController hide];
                success();
            } failure:^(NSInteger failureCode) {
                [self.authorizationController hide];
                failure(failureCode);
            }];
        }
    }];
    
}

- (BOOL)webViewLoadFailed:(NSString *)errorDescription{
    if ([errorDescription hasPrefix:@"http"] ){
        return NO;
    }
    return YES;
}

- (void)loadOauthURL:(NSString *)oauthURL finish:(AuthorizationFinishBlock)finish {
    [self.authorizationController showWithOauthUrl:oauthURL];
    self.authorizationController.finishBlock = ^(NSString *finsihUrl) {
        finish(finsihUrl);
    };
}

@end

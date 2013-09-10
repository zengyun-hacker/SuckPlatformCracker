//
//  WeiboOauthClient.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-10.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "OauthClient.h"

@interface WeiboOauthClient : OauthClient

+ (WeiboOauthClient *)sharedWeiboOauthClient;

- (void)sendPost:(NSString *)postText success:(ZYBlock)success failure:(ZYBlock)failure;

@end

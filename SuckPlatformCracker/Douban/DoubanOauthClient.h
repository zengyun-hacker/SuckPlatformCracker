//
//  DoubanOauthClient.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "AFHTTPClient.h"
#import "OauthClient.h"

@interface DoubanOauthClient : OauthClient

@property (nonatomic,strong) NSString *refreshToken;
@property (nonatomic,strong) NSNumber *userID;

+ (DoubanOauthClient *)sharedDoubanOauthClient;

- (void)sendPost:(NSString *)postText withImage:(UIImage *)postImage withRecTitle:(NSString *)recTitle withRecUrl:(NSString *)recUrl withRecDes:(NSString *)recDesc withRecImageUrl:(NSString *)recImageUrl success:(ZYBlock)success failure:(ZYBlock)failure;

@end

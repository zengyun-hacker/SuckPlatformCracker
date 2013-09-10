//
//  GVUserDefaults+DoubanOauth.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-9.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (DoubanOauth)

@property (nonatomic,weak) NSString *doubanAccessToken;
@property (nonatomic) NSTimeInterval doubanExpireTime;
@property (nonatomic,weak) NSNumber *doubanUserID;
@property (nonatomic,weak) NSString *doubanRefreshToken;

@end

//
//  GVUserDefaults+WeiboOauth.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-10.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (WeiboOauth)

@property (nonatomic,weak) NSString *weiboAccessToken;
@property (nonatomic) NSTimeInterval weiboExpireTime;

@end

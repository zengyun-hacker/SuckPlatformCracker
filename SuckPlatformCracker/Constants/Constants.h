//
//  Constants.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-5.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

//跳转链接
static NSString * const REDIRECT_URL = @"http://gezbox.com/public/oauth_hub.html";

///豆瓣Oauth相关常量
static NSString * const DOUBAN_API_KEY = @"0c183af4c0928a4d2448b0de41b79ee7";
static NSString * const DOUBAN_APP_SECRET = @"4f46b142c32b1d76";



//常用宏定义
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define USER_DEFAULTS [GVUserDefaults standardUserDefaults]

#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
\
+ (classname *)shared##classname {                      \
\
static dispatch_once_t pred;                        \
__strong static classname * shared##classname = nil;\
dispatch_once( &pred, ^{                            \
shared##classname = [[self alloc] init]; });    \
return shared##classname;                           \
}
#endif



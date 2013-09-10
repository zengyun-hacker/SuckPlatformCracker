//
//  AuthorizationViewController.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-5.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTypeDefine.h"

@interface AuthorizationViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,copy) NSString *targetURL;
@property (nonatomic,copy) AuthorizationFinishBlock finishBlock;

- (void)analyseURL:(NSString *)url;
- (NSString *)authorizationCode;

@end

//
//  AuthorizationControl.h
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-7.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTypeDefine.h"

@interface AuthorizationControl : UIControl <UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,copy) AuthorizationFinishBlock finishBlock;

/*
 显示control
 */
- (void)showWithOauthUrl:(NSString *)oauthUrl;

/*
 隐藏control
 */
- (void)hide;

@end

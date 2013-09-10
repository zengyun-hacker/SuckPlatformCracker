//
//  AuthorizationControl.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-7.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "AuthorizationControl.h"
#import "Constants.h"

static NSTimeInterval const AUTHORIZATION_CONTROL_SHOW_HIDE_DURATION = 0.5;

@implementation AuthorizationControl

- (AuthorizationControl *)init {
    self = [[NSBundle mainBundle] loadNibNamed:@"AuthorizationControl" owner:nil options:nil][0];
    if (self) {
        //放到界面底部
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UIWebView delegate 

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.finishBlock) {
        self.finishBlock(webView.request.URL.absoluteString);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (self.finishBlock) {
        self.finishBlock(error.description);
    }
}

#pragma mark - show and hide control 

- (void)showWithOauthUrl:(NSString *)oauthUrl {
    //加入到当前view
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //显示一个由下往上弹出的动画
    [UIView animateWithDuration:AUTHORIZATION_CONTROL_SHOW_HIDE_DURATION animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oauthUrl]]];
    }];
}

- (void)hide {
    [UIView animateWithDuration:AUTHORIZATION_CONTROL_SHOW_HIDE_DURATION animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)backButtonTapped:(UIButton *)sender {
    [self hide];
}

@end

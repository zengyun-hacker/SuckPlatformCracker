//
//  AuthorizationViewController.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-5.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "AuthorizationViewController.h"

@interface AuthorizationViewController ()

@end

@implementation AuthorizationViewController

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

- (NSString *)targetURL {
    if (!_targetURL) {
        _targetURL = @"http://www.zengyun.info";
    }
    
    return _targetURL;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.targetURL]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

///用于提取token等信息
- (void)analyseURL:(NSString *)url{
    
}

#pragma mark - UIWebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.finishBlock) {
        self.finishBlock(webView.request.URL.absoluteString);
    }
}

@end

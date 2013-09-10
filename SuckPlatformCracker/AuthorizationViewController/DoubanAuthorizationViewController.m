//
//  DoubanAuthorizationViewController.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-9-5.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "DoubanAuthorizationViewController.h"
#import "Constants.h"

//获取authorization_code的链接
static NSString * const DOUBAN_CODE_URL = @"https://www.douban.com/service/auth2/auth";
static NSString * const DOUBAN_TOKEN_URL = @"https://www.douban.com/service/auth2/token";

@interface DoubanAuthorizationViewController ()

@property (nonatomic,copy) NSString *authorizationCode;

@end

@implementation DoubanAuthorizationViewController

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
    self.targetURL = [self authorizationCodeURL];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)authorizationCodeURL {
    return [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code",DOUBAN_CODE_URL,DOUBAN_API_KEY,REDIRECT_URL];
}

- (NSString *)accessTokenURL {
    return [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code&code=%@",DOUBAN_TOKEN_URL,DOUBAN_API_KEY,DOUBAN_APP_SECRET,REDIRECT_URL,self.authorizationCode];
}

- (void)analyseURL:(NSString *)url {
    //获取code阶段
    //1.判断是否被拒绝
    [self authorizationDenied:url];
    //2.提取出authorization_code
    [self getAuthorizationCode:url];
}

- (BOOL)authorizationDenied:(NSString *)url {
    
}

- (BOOL)getAuthorizationCode:(NSString *)url {
    
}

//获取acesss token
- (void)retrieveAccesToken {
    
}

@end

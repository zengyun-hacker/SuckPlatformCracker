//
//  ViewController.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-7-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "ViewController.h"
#import "DoubanOauthClient.h"
#import "WeiboOauthClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)postText:(NSString *)platformName {
    return [NSString stringWithFormat:@"SuckPlatformCracker%@测试~",platformName];
}

- (IBAction)sendShuoShuoTapped:(UIButton *)sender {
    [[DoubanOauthClient sharedDoubanOauthClient] sendPost:[self postText:@"豆瓣广播"] withImage:nil withRecTitle:nil withRecUrl:nil withRecDes:nil withRecImageUrl:nil success:^{
        NSLog(@"豆瓣广播发送成功");
    } failure:^{
        NSLog(@"豆瓣广播发送失败");
    }];
}

- (IBAction)sendWeiboTapped:(UIButton *)sender {
    [[WeiboOauthClient sharedWeiboOauthClient] sendPost:[self postText:@"微博"] success:^{
        NSLog(@"微博发送成功");
    } failure:^{
        NSLog(@"微博发送失败");
    }];
}


@end

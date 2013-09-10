//
//  ViewController.m
//  SuckPlatformCrackerSample
//
//  Created by dreamer on 13-7-6.
//  Copyright (c) 2013年 ZengYun. All rights reserved.
//

#import "ViewController.h"
#import "DoubanOauthClient.h"

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

- (IBAction)sendShuoShuoTapped:(UIButton *)sender {
    [[DoubanOauthClient sharedDoubanOauthClient] sendPost:@"SuckPlatformCracker说说测试" withImage:nil withRecTitle:nil withRecUrl:nil withRecDes:nil withRecImageUrl:nil success:^{
        NSLog(@"说说发送成功");
    } failure:^{
        NSLog(@"说说发送失败");
    }];
}

@end

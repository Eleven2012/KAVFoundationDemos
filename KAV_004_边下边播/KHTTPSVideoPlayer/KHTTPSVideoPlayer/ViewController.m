//
//  ViewController.m
//  KHTTPSVideoPlayer
//
//  Created by 孔雨露 on 2020/2/14.
//  Copyright © 2020 Apple. All rights reserved.
//

#import "ViewController.h"
#import "KPlayerTestVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void) setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
       button.frame = CGRectMake(100, 100, 100, 100);
       button.center = self.view.center;
       [button setTitle:@"播放" forState:UIControlStateNormal];
       button.backgroundColor = [UIColor darkGrayColor];
       [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
       [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:button];
}

- (void)ButtonClick
{
    KPlayerTestVC *vc = [[KPlayerTestVC alloc] init];
    
    [self presentViewController:vc animated:NO completion:nil];
}

@end

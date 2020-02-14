//
//  KPlayerTestVC.m
//  KHTTPSVideoPlayer
//
//  Created by 孔雨露 on 2020/2/14.
//  Copyright © 2020 Apple. All rights reserved.
//

#import "KPlayerTestVC.h"
#import "KPlayer.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface KPlayerTestVC ()
@property (nonatomic, strong) KPlayer *player;
@property (nonatomic, strong) UIView *showView;
@end

@implementation KPlayerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void) setupUI {
    self.showView = [[UIView alloc] init];
      self.showView.backgroundColor = [UIColor redColor];
      self.showView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
      [self.view addSubview:self.showView];
      
      
      
      NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
      NSString *movePath =  [document stringByAppendingPathComponent:@"kyl_saved.mp4"];
      
      NSURL *localURL = [NSURL fileURLWithPath:movePath];
      
      NSURL *url2 = [NSURL URLWithString:@"http://vjs.zencdn.net/v/oceans.mp4"];
    
       //url2 = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
      
      //url2 = [NSURL URLWithString:@"https://ubtech.oss-cn-shenzhen.aliyuncs.com/jimu/user/files/1435656/playerdata/190814173627413186/Exhibition/190814173627413186.mp4"];
      
      //url2 = [NSURL URLWithString:@"https://ubtech.oss-cn-shenzhen.aliyuncs.com/ubtech/jimu/post/2D774795-0F72-4000-8EC1-9B8EE55AFF50969855.mp4"];
      
      //url2 = [NSURL URLWithString:@"http://video.ubtrobot.com/jimu/video/170628115335574424.mp4"];
    
    self.player = [[KPlayer alloc] init];
    [self.player playWithUrl:url2 showView:self.showView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

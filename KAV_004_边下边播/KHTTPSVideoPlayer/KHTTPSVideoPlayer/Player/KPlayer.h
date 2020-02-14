//
//  KPlayer.h
//  KHTTPSVideoPlayer
//
//  Created by 孔雨露 on 2020/2/14.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kPlayerStateChangedNotification;
FOUNDATION_EXPORT NSString *const kPlayerProgressChangedNotification;
FOUNDATION_EXPORT NSString *const kPlayerLoadProgressChangedNotification;

//播放器的几种状态
typedef NS_ENUM(NSInteger, KPlayerState) {
    KPlayerStateBuffering = 1,
    KPlayerStatePlaying   = 2,
    KPlayerStateStopped   = 3,
    KPlayerStatePause     = 4
};

@interface KPlayer : NSObject

@property (nonatomic, readonly) KPlayerState state;
@property (nonatomic, readonly) CGFloat       loadedProgress;   //缓冲进度
@property (nonatomic, readonly) CGFloat       duration;         //视频总时间
@property (nonatomic, readonly) CGFloat       current;          //当前播放时间
@property (nonatomic, readonly) CGFloat       progress;         //播放进度 0~1
@property (nonatomic          ) BOOL          stopWhenAppDidEnterBackground;// default is YES

- (void)playWithUrl:(NSURL *)url showView:(UIView *)showView;
- (void)seekToTime:(CGFloat)seconds;

- (void)resume;
- (void)pause;
- (void)stop;

- (void)fullScreen;  //全屏
- (void)halfScreen;   //半屏

@end

NS_ASSUME_NONNULL_END

//
//  KAudioPlayer.h
//  KRecorderDemo_OC
//
//  Created by 孔雨露 on 2020/1/31.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KAudioPlayer : NSObject
@property (nonatomic, strong) AVAudioPlayer * audioPlayer;
+ (KAudioPlayer *)shareInstance;
// 播放指定路径下音频（wav）
+ (void)playAudioWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;
- (void)playAudioWithPath:(NSString *)aFilePath
                  completion:(void(^)(NSError *error))completon;

// 停止当前播放音频
+ (void)stopCurrentPlaying;
- (void)stopCurrentPlaying;
@end

NS_ASSUME_NONNULL_END

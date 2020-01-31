//
//  KAudioRecorder.h
//  KRecorderDemo_OC
//
//  Created by 孔雨露 on 2020/1/31.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KAudioRecorder : NSObject
@property (nonatomic, strong) AVAudioRecorder * audioRecorder;
@property (nonatomic, copy) NSDictionary * recoredSettings;
+ (KAudioRecorder  *)shareInstance;
// 开始录音
+ (void)startRecordingWithPreparePath:(NSString *)aFilePath
                                completion:(void(^)(NSError *error))completion;
// 停止录音
+(void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 取消录音
+(void)cancelCurrentRecording;

+(AVAudioRecorder *)audioRecorder;

- (void)startRecoredWithPath:(NSString *)path
                  completion:(void(^)(NSError *error))completion;
- (void)stopRecorderWithCompletion:(void(^)(NSString *recoredPath))completion;
- (void)cancelCurrentRecording;

@end

NS_ASSUME_NONNULL_END

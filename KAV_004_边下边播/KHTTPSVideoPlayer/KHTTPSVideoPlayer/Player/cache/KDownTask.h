//
//  KDownTask.h
//  KHTTPSVideoPlayer
//
//  Created by 孔雨露 on 2020/2/14.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KDownTask;
@protocol KDownTaskDelegate <NSObject>

- (void)task:(KDownTask *)task didReceiveVideoLength:(NSUInteger)ideoLength mimeType:(NSString *)mimeType;
- (void)didReceiveVideoDataWithTask:(KDownTask *)task;
- (void)didFinishLoadingWithTask:(KDownTask *)task;
- (void)didFailLoadingWithTask:(KDownTask *)task WithError:(NSInteger )errorCode;

@end


@interface KDownTask : NSObject
@property (nonatomic, strong, readonly) NSURL   *url;
@property (nonatomic, readonly) NSUInteger  offset;
@property (nonatomic, readonly) NSUInteger  videoLength;
@property (nonatomic, readonly) NSUInteger  downLoadingOffset;
@property (nonatomic, strong, readonly) NSString * mimeType;
@property (nonatomic, assign) BOOL isFinishLoad;
@property (nonatomic, weak) id <KDownTaskDelegate> delegate;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;
- (void)cancel;
- (void)continueLoading;
- (void)clearData;

@end

NS_ASSUME_NONNULL_END

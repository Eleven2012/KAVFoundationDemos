//
//  KRequest.h
//  KHTTPSVideoPlayer
//
//  Created by 孔雨露 on 2020/2/14.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KDownTask.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KResLoadingDelegate <NSObject>

- (void)didFinishLoadingWithTask:(KDownTask *)task;
- (void)didFailLoadingWithTask:(KDownTask *)task WithError:(NSInteger )errorCode;

@end


@interface KRequest : NSURLConnection <AVAssetResourceLoaderDelegate>
@property (nonatomic, strong) KDownTask *task;
@property (nonatomic, weak  ) id<KResLoadingDelegate> delegate;
- (NSURL *)getSchemeVideoURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END

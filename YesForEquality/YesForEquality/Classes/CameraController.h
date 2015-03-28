//
//  CameraController.h
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraController : NSObject

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

- (void)captureStillImage:(void (^)(UIImage *image, NSDictionary *metadata))completion;
- (void)logSession;

@end

//
//  CameraController.h
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraControllerDelegate <NSObject>
@end


@interface CameraController : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate> {
    dispatch_queue_t sessionQueue;
}

@property (nonatomic,assign) id <CameraControllerDelegate> delegate;

@property (nonatomic,strong) AVCaptureSession *session;
@property (nonatomic,strong) AVCaptureDevice *backCameraDevice;
@property (nonatomic,strong) AVCaptureDevice *frontCameraDevice;
@property (nonatomic,strong) AVCaptureDevice *currentCameraDevice;
@property (nonatomic,strong) AVCaptureStillImageOutput *stillCameraOutput;
@property (nonatomic,strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic,strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic,assign) BOOL isUsingFrontCamera;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;

- (id)initWithDelegate:(id<CameraControllerDelegate>)delegate;

- (void)startRunning;
- (void)stopRunning;

- (void)captureStillImage:(void (^)(UIImage *image, NSDictionary *metadata))completion;
- (void)toggleCamera;
- (void)logSession;

@end

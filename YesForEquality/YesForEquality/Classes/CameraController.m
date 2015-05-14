//
//  CameraController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "CameraController.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>


@interface CameraController ()
@end

@implementation CameraController {
}

- (id)initWithDelegate:(id<CameraControllerDelegate>)delegate {
    self = [super init];
    if (self){
        self.delegate = delegate;
        sessionQueue = dispatch_queue_create("com.example.session_access_queue", DISPATCH_QUEUE_SERIAL);
        self.isUsingFrontCamera= YES;
        [self initializeSession];
    }
    return self;
}

- (void)initializeSession{
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted){
                                         if (granted) {
                                             [self configureCamera];
                                         } else {
                                             [self showAccessDeniedMessage];
                                         }
                                     }];
        } break;

        case AVAuthorizationStatusAuthorized:{
            [self configureCamera];
        } break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:{
            [self showAccessDeniedMessage];
        } break;
        default:
            break;
    }
}

- (void)showAccessDeniedMessage{
    UIAlertView *alert  =[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Access", nil)
                                                    message:NSLocalizedString(@"We need access to the camera!", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)configureDeviceInput{
    [self performConfiguration:^{
        [self.session beginConfiguration];
        
        NSArray *availableCameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in availableCameraDevices) {
            if (device.position == AVCaptureDevicePositionBack) {
                self.backCameraDevice = device;
            }
            else if (device.position == AVCaptureDevicePositionFront) {
                self.frontCameraDevice = device;
            }
        }
        
        //remove any existing camera input if necessary
        NSArray *sessionInputs = self.session.inputs;
        [sessionInputs enumerateObjectsUsingBlock:^(AVCaptureDeviceInput *cameraInput, NSUInteger idx, BOOL *stop){
            [self.session removeInput:cameraInput];
        }];
        
        // let's set the back camera as the initial device
        //self.currentCameraDevice = self.backCameraDevice
        BOOL isUsingFrontCamera = self.isUsingFrontCamera;
        if (isUsingFrontCamera){
            self.currentCameraDevice = self.frontCameraDevice;
        } else {
            self.currentCameraDevice = self.backCameraDevice;
        }
        
        NSError *error;
        AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.currentCameraDevice error: &error];
        if ([self.session canAddInput:cameraInput]){
            [self.session addInput:cameraInput];
        }
        
        [self.session commitConfiguration];
    }];
}
- (void)configureStillImageCameraOutput{
    [self performConfiguration:^{
        [self.session beginConfiguration];
        self.stillCameraOutput = [[AVCaptureStillImageOutput alloc] init];
        self.stillCameraOutput.outputSettings = @{ AVVideoCodecKey  : AVVideoCodecJPEG,
                                                   AVVideoQualityKey: @0.9
                                                   };
        
        if ([self.session canAddOutput:self.stillCameraOutput]) {
            [self.session addOutput:self.stillCameraOutput];
        }
        
        [self.session commitConfiguration];
    }];
}
- (void)configureVideoOutput{
    [self performConfiguration:^{
        [self.session beginConfiguration];
        self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL)];
        if ([self.session canAddOutput:self.videoOutput]) {
            [self.session addOutput:self.videoOutput];
        }
        [self.session commitConfiguration];
    }];
}

- (void)configureCamera{
    [self performConfiguration:^{
        
        [self.session stopRunning];
        
        [self.session beginConfiguration];
        
        NSArray *outputs = self.session.outputs;
        [outputs enumerateObjectsUsingBlock:^(AVCaptureOutput *output,NSUInteger idx,BOOL*stop){
            [self.session removeOutput:output];
        }];
        
        //configureDeviceInput
        NSArray *availableCameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in availableCameraDevices) {
            if (device.position == AVCaptureDevicePositionBack) {
                self.backCameraDevice = device;
            }
            else if (device.position == AVCaptureDevicePositionFront) {
                self.frontCameraDevice = device;
            }
        }
        
        //remove any existing camera input if necessary
        NSArray *sessionInputs = self.session.inputs;
        [sessionInputs enumerateObjectsUsingBlock:^(AVCaptureDeviceInput *cameraInput, NSUInteger idx, BOOL *stop){
            [self.session removeInput:cameraInput];
        }];
        
        // let's set the back camera as the initial device
        //self.currentCameraDevice = self.backCameraDevice
        BOOL isUsingFrontCamera = self.isUsingFrontCamera;
        if (isUsingFrontCamera){
            self.currentCameraDevice = self.frontCameraDevice;
        } else {
            self.currentCameraDevice = self.backCameraDevice;
        }
        
        NSError *error;
        AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.currentCameraDevice error: &error];
        if ([self.session canAddInput:cameraInput]){
            [self.session addInput:cameraInput];
        }
        
        //configureStillImageCameraOutput
        self.stillCameraOutput = [[AVCaptureStillImageOutput alloc] init];
        self.stillCameraOutput.outputSettings = @{ AVVideoCodecKey  : AVVideoCodecJPEG,
                                                   AVVideoQualityKey: @0.9
                                                   };
        
        if ([self.session canAddOutput:self.stillCameraOutput]) {
            [self.session addOutput:self.stillCameraOutput];
        }
        
        
        //configureVideoOutput
        self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [self.videoOutput setSampleBufferDelegate:self queue:dispatch_queue_create("sample buffer delegate", DISPATCH_QUEUE_SERIAL)];
        if ([self.session canAddOutput:self.videoOutput]) {
            [self.session addOutput:self.videoOutput];
        }
        [self.session commitConfiguration];
        
        [self.session startRunning];
        
        [self logSession];
        
    }];
}

- (void)startRunning{
    [self performConfiguration:^{
        [self.session startRunning];
    }];
}
- (void)stopRunning{
    [self performConfiguration:^{
        [self.session stopRunning];
    }];
}

- (void)captureStillImage:(void (^)(UIImage *image, NSDictionary *metadata))completion{
    [self performConfiguration:^{
        
        AVCaptureConnection *connection = [self.stillCameraOutput connectionWithMediaType:AVMediaTypeVideo];
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        connection.videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;

      id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

      [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"selfie"     // Event category (required)
                                                            action:@"taken"  // Event action (required)
                                                             label:@"hurrah!"          // Event label
                                                             value:nil] build]];    // Event value

        [self logSession];
        
        NSLog(@"\n\n\t\tCONNECTION = %@\n\n",connection);
        
        [self.stillCameraOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
            
            if (!error){
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                //NSDictionary *metadata = CMCopyDictionaryOfAttachments(nil, imageDataSampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate));
                NSDictionary *metadata = @{};
                
                UIImage *image = [UIImage imageWithData:imageData];
                dispatch_async(dispatch_get_main_queue(),^{
                    completion(image, metadata);
                });
                
            }
            else {
                NSLog(@"error while capturing still image: %@",error);
            }
        }];
        
    }];
}

//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
////    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
////    CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
////    //self.delegate cameraController(self, didOutputImage: image)
//}
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//}

- (void)toggleCamera{
    self.isUsingFrontCamera = !self.isUsingFrontCamera;
    [self configureCamera];
}

- (void)performConfiguration:(void (^)(void))block{
    dispatch_async(sessionQueue,^{
        block();
    });
}

- (void)logSession{
//    NSLog(@"######################################");
//    NSLog(@"AVSESSION:");
//    NSLog(@"  session                       = %@",self.session);
//    NSLog(@"  session.inputs                = %@",self.session.inputs);
//    NSLog(@"  session.outputs               = %@",self.session.outputs);
//    NSLog(@"  stillCameraOutput             = %@",self.stillCameraOutput);
//    NSLog(@"  stillCameraOutput.connections = %@",self.stillCameraOutput.connections);
//    NSLog(@"  videoOutput                   = %@",self.videoOutput);
//    NSLog(@"  videoOutput.connections       = %@",self.videoOutput.connections);
//    NSLog(@"  currentCameraDevice           = %@",self.currentCameraDevice);
//    AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.currentCameraDevice error:nil];
//    if (cameraInput){
//        NSLog(@"  cameraInput                   = %@",cameraInput);
//    }
//    NSLog(@"######################################");
}

@end

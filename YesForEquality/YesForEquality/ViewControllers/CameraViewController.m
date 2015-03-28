//
//  CameraViewController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "CameraViewController.h"
#import "YESInformationViewController.h"
#import "constants.h"

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPreviewViewWidthConstraint;
@property (assign, nonatomic) BOOL isDisplayingStillImage;
@property (strong, nonatomic) CameraController *cameraController;
@property (strong, nonatomic) UIImageView *stillImageView;
@property (nonatomic,strong) UIImage *renderedImage;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cameraController = [[CameraController alloc] initWithDelegate:self];
    AVCaptureVideoPreviewLayer *previewLayer = self.cameraController.previewLayer;
    self.cameraView.contentMode = UIViewContentModeScaleAspectFill;
    previewLayer.frame = self.cameraView.bounds;
    
    [self.cameraView.layer insertSublayer:previewLayer atIndex:0];
    self.cameraView.clipsToBounds = YES;
    
    self.cameraView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cameraView.layer.shadowOffset = CGSizeMake(0, 2);
    self.cameraView.layer.shadowOpacity = 0.3;
    self.cameraView.layer.shadowRadius = 2.0;
    
    [self.cameraView.layer insertSublayer:self.logoView.layer above:previewLayer];
    
    CGRect bounds = self.cameraView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.bounds = bounds;
    
    self.shareButton.enabled = NO;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    CGFloat minDimension = MIN(CGRectGetWidth(self.view.frame),CGRectGetHeight(self.view.frame));
    self.videoPreviewViewWidthConstraint.constant = minDimension - 10;
    [self.cameraView layoutIfNeeded];

    AVCaptureVideoPreviewLayer *previewLayer = self.cameraController.previewLayer;
    previewLayer.frame = self.cameraView.bounds;

    [self.logoView layoutIfNeeded];
    CGRect frame = self.logoView.frame;
    frame.origin.x = 10.0;
    frame.origin.y = self.cameraView.frame.size.height - self.logoView.frame.size.height - 10.0;
    self.logoView.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.cameraController startRunning];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapMenuButton:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kYESInfoStoryboardName bundle:nil];
    YESInformationViewController *viewController = [sb instantiateViewControllerWithIdentifier:kYESMenuVCStoryboardId];
    [self presentViewController:viewController animated:YES completion:nil];
}
- (IBAction)didTapFlipButton:(id)sender {
    [self.cameraController stopRunning];
    [self.cameraController toggleCamera];
    [self.cameraController startRunning];
    [self removePreviewImageview];

}
- (IBAction)didTapCameraButton:(id)sender {
    [self takePhoto];
}
- (IBAction)didTapInfoButton:(id)sender {
}

- (IBAction)didTapShareButton:(id)sender {
    if (!self.renderedImage){
        return;
    }
    if (IOS8){
        NSArray *activityItems = @[self.renderedImage];
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        
    }
}

- (void)takePhoto{
    if (!self.isDisplayingStillImage){
        
        self.shareButton.enabled = YES;
        
        [self.cameraController logSession];
        
        [self.cameraController captureStillImage:^(UIImage *image, NSDictionary *metatata){
            
            UIImage *outputImage = image;
            if (self.cameraController.isUsingFrontCamera) {
                UIImage *mirroredImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
                outputImage = mirroredImage;
            }
            
            self.cameraController.previewLayer.hidden = YES;
            
            self.stillImageView = [[UIImageView alloc] initWithFrame:self.cameraView.bounds];
            self.stillImageView.clipsToBounds = YES;
            self.stillImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.stillImageView.image = outputImage;
            [self.cameraView addSubview:self.stillImageView];
            [self.cameraView sendSubviewToBack:self.stillImageView];
            
            CGSize size = self.cameraView.frame.size;
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.cameraView.layer renderInContext:context];
            self.renderedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            self.isDisplayingStillImage = YES;
            
            self.stillImageView.alpha = 0.0;
            [UIView animateWithDuration:0.5 animations:^{
                self.stillImageView.alpha = 1.0;
            }];
            
        }];
        
    } else {
        [self removePreviewImageview];
    }

}

- (void)removePreviewImageview{
    self.isDisplayingStillImage = NO;
    self.cameraController.previewLayer.hidden = NO;
    [self.stillImageView removeFromSuperview];
    self.shareButton.enabled = NO;
}

- (void)saveImageToSavedPhotosAlbum:(UIImage*)image{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self removePreviewImageview];
}
- (void)shareImageOnTwitter:(UIImage*)image{
    SLComposeViewController* tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    tweet.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                break;
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    [tweet setInitialText:@"Vote Yes!"]; //The default text in the tweet
    [tweet addImage:image]; //Add an image
    [tweet addURL:[NSURL URLWithString:@"http://facebook.com"]]; //A url which takes you into safari if tapped on
    [self presentViewController:tweet animated:YES completion: ^{
        [self removePreviewImageview];
    }];
}
- (void)shareImageOnFacebook:(UIImage*)image{
    SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    facebookPost.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result) {
        case SLComposeViewControllerResultCancelled:
                break;
        case SLComposeViewControllerResultDone:
                break;
        }
    };
    [facebookPost setInitialText:@"Vote Yes!"]; //The default text in the tweet
    [facebookPost addImage:image]; //Add an image
    [facebookPost addURL:[NSURL URLWithString:@"http://facebook.com"]]; //A url which takes you into safari if tapped on
    [self presentViewController:facebookPost animated:YES  completion:^{
        [self removePreviewImageview];
    }];
}


@end

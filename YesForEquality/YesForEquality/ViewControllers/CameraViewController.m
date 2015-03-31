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
#import "CameraController.h"
#import "ReminderViewController.h"
#import "InfoPageViewController.h"

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@property (weak, nonatomic) IBOutlet UIView *prePhotoView;
@property (weak, nonatomic) IBOutlet UIView *postPhotoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prePhotoViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postPhotoViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *xButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoPreviewViewWidthConstraint;
@property (assign, nonatomic) BOOL isDisplayingStillImage;
@property (assign, nonatomic) BOOL usingFrontCamera;
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
    self.cameraView.layer.shadowOpacity = 0.2;
    self.cameraView.layer.shadowRadius = 2.0;
    
    [self.cameraView.layer insertSublayer:self.logoView.layer above:previewLayer];
    
    CGRect bounds = self.cameraView.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.bounds = bounds;
    
    self.shareButton.enabled = NO;
    
    self.cameraButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cameraButton.layer.shadowOpacity = 0.2;
    self.cameraButton.layer.shadowOffset = CGSizeMake(0, 5);
    
    self.flipCameraButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.flipCameraButton.layer.shadowOpacity = 0.1;
    self.flipCameraButton.layer.shadowOffset = CGSizeMake(0, 5);
    
    self.shareButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shareButton.layer.shadowOpacity = 0.1;
    self.shareButton.layer.shadowOffset = CGSizeMake(0, 5);
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
    [self.view layoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self shouldShowShareButton:NO animated:NO];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Reminder" bundle:nil];
    ReminderViewController *controller = (ReminderViewController*)[storyboard instantiateViewControllerWithIdentifier:@"reminderSB"];
    [self presentViewController:controller animated:YES completion:^{}];

}

- (IBAction)didTapFlipButton:(id)sender {
    [self.cameraController stopRunning];
    [self.cameraController toggleCamera];
    [self.cameraController startRunning];
    [self removePreviewImageview:nil];

}
- (IBAction)didTapCameraButton:(id)sender {
    [self takePhoto];
}
- (IBAction)didTapInfoButton:(id)sender {
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:kYESInfoStoryboardName bundle:nil];
//    YESInformationViewController *viewController = [sb instantiateViewControllerWithIdentifier:kYESMenuVCStoryboardId];
    
    InfoPageViewController *controller = [[InfoPageViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
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
            self.stillImageView.userInteractionEnabled = YES;
            [self.cameraView addSubview:self.stillImageView];
            [self.cameraView sendSubviewToBack:self.stillImageView];
            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapStillImage:)];
//            [self.stillImageView addGestureRecognizer:tap];
            
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
            
            
            [self shouldShowShareButton:YES animated:YES];

        }];
        
    } else {
        [self removePreviewImageview:nil];
    }

}

- (IBAction)discardImage:(id)sender{
    if (self.isDisplayingStillImage){
        [self removePreviewImageview:nil];
    }
}

- (IBAction)removePreviewImageview:(id)sender{
    self.isDisplayingStillImage = NO;
    self.cameraController.previewLayer.hidden = NO;
    [self.stillImageView removeFromSuperview];
    self.shareButton.enabled = NO;
    [self shouldShowShareButton:NO animated:YES];
}

- (void)saveImageToSavedPhotosAlbum:(UIImage*)image{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self removePreviewImageview:nil];
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
        [self removePreviewImageview:nil];
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
        [self removePreviewImageview:nil];
    }];
}

#pragma mark - Info page
- (IBAction)transitionToInfoView:(id)sender {
//    UIStoryboard *infoStoryboard = [UIStoryboard storyboardWithName:@"Info" bundle:nil];
//    YESInformationViewController * infoViewController = [infoStoryboard instantiateViewControllerWithIdentifier:@"YESInformationViewController"];
//    [self presentViewController:infoViewController animated:YES completion: nil];
    InfoPageViewController *controller = [[InfoPageViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)shouldShowShareButton:(BOOL)shouldShowShareButton animated:(BOOL)animated{
    CGFloat height = -CGRectGetHeight(self.prePhotoView.frame);
    CGFloat shareButtonAlpha = (shouldShowShareButton?1.0:0.0);
    if (!shouldShowShareButton){
        self.prePhotoViewBottomConstraint.constant = 0.0;
        self.postPhotoViewBottomConstraint.constant = height;
    } else {
        self.prePhotoViewBottomConstraint.constant = height;
        self.postPhotoViewBottomConstraint.constant = 0.0;
    }
    
    void (^uiUpdate)() = ^void(){
        [self.view layoutIfNeeded];
        [self.prePhotoView setAlpha:(1.0-shareButtonAlpha)];
        [self.postPhotoView setAlpha:shareButtonAlpha];
    };
    
    if (animated){
        [UIView animateWithDuration:0.76 delay:0.23 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             uiUpdate();
                         } completion:^(BOOL completion){
                         }];
    } else {
        uiUpdate();
    }
    
}
@end

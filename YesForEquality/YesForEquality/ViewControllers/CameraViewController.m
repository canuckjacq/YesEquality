//
//  CameraViewController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraController.h"

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *flipCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapMenuButton:(id)sender {
}
- (IBAction)didTapFlipButton:(id)sender {
}
- (IBAction)didTapCameraButton:(id)sender {
}
- (IBAction)didTapInfoButton:(id)sender {
}

- (IBAction)didTapShareButton:(id)sender {
}

- (void)takePhoto{
    if (!self.isDisplayingStillImage){
        
        self.shareButton.enabled = YES;
        
        [self.cameraController logSession];
        
        [self.cameraController captureStillImage:^(UIImage *image, NSDictionary *metatata){
            
            UIImage *outputImage = image;
            if (self.usingFrontCamera) {
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
        self.isDisplayingStillImage = NO;
        [self removePreviewImageview];
        self.shareButton.enabled = NO;
    }

}

- (void)removePreviewImageview{
    self.cameraController.previewLayer.hidden = NO;
    [self.stillImageView removeFromSuperview];
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

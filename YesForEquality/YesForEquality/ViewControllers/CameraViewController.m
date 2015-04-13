//
//  CameraViewController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

typedef enum {
    kPanDropPositionBottomLeft=0,
    kPanDropPositionBottomRight,
    kPanDropPositionTopLeft,
    kPanDropPositionTopRight
} kPanDropPosition;

#import "CameraViewController.h"
#import "YESInformationViewController.h"
#import "constants.h"
#import "CameraController.h"
#import "ReminderViewController.h"
#import "InfoPageViewController.h"
#import "LogoImageView.h"

@interface OSLabel : UILabel
//@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat padding;
@end
@implementation OSLabel

- (CGSize) intrinsicContentSize{
    CGSize parentSize = [super intrinsicContentSize];
    parentSize.width += 2*self.padding;
    return parentSize;
}

- (CGSize)sizeThatFits:(CGSize)size{
    CGSize parentSize = [super sizeThatFits:size];
    parentSize.width += 2*self.padding;
    return parentSize;
}

//- (id)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//    return self;
//}
//- (void)drawTextInRect:(CGRect)rect {
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
//}
@end

@interface CameraViewController () {
    CGPoint panOffset;
    kPanDropPosition lastPanDropPosition;
}
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet LogoImageView *logoView;
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

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *logoViewMarginConstraintCollection;

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

    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.logoView addGestureRecognizer:pgr];
    pgr.delegate = self;
    self.logoView.userInteractionEnabled = YES;

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

    CGSize size = self.cameraView.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.cameraView.layer renderInContext:context];
    self.renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (!self.renderedImage){
        return;
    }
    if (IOS8){
        NSArray *activityItems = @[self.renderedImage];
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [self presentiOS7ShareOptions];
    }
}

- (void)takePhoto{
    if (!self.isDisplayingStillImage){
        
        self.shareButton.enabled = YES;
        
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
            
//            CGSize size = self.cameraView.frame.size;
//            UIGraphicsBeginImageContextWithOptions(size, false, 0);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            [self.cameraView.layer renderInContext:context];
//            self.renderedImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
            
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

- (IBAction)handlePan:(UIPanGestureRecognizer *)pan{
    __block CGPoint panPoint = [pan locationInView:self.view];

    void (^translateView)() = ^void(){
        //allow the user to drag the view
        panPoint.x -= panOffset.x;
        panPoint.y -= panOffset.y;
        [self dropPositionAtPoint:panPoint];
        if (!CGPointEqualToPoint(panPoint, CGPointZero)){
            [self.logoView setCenter:panPoint];
        }
    };
    
    if (pan.state == UIGestureRecognizerStateBegan){
        //remove existing constraints when dragging starts
        panOffset = CGPointMake(panPoint.x - self.logoView.center.x,
                                panPoint.y - self.logoView.center.y);
        
    } else if (pan.state == UIGestureRecognizerStateChanged){
        //allow the user to drag the view
        translateView();
        
    } else if (pan.state == UIGestureRecognizerStateEnded){
        //restore the constraints, depending on the gesture's final location
        [self positionPublisherViewAtPoint:panPoint animated:YES];
        
    } else if (pan.state == UIGestureRecognizerStateCancelled ||
               pan.state == UIGestureRecognizerStateFailed){
        //restore the original constraints
        [self.view addConstraints:self.logoViewMarginConstraintCollection];
        [self animatePublisherViewConstraints];
    }
    
}

- (kPanDropPosition)dropPositionAtPoint:(CGPoint)point{
    CGRect leftRect, rightRect;
    CGRectDivide(self.cameraView.bounds, &leftRect, &rightRect, CGRectGetWidth(self.cameraView.bounds)/2.0, CGRectMinXEdge);
    CGRect topRect, bottomRect;
    CGRectDivide(self.cameraView.bounds, &topRect, &bottomRect, CGRectGetHeight(self.cameraView.bounds)/2.0, CGRectMinYEdge);

    point.x -= panOffset.x;
    point.y -= panOffset.y;

    
    kPanDropPosition panDropPosition = kPanDropPositionBottomLeft;
    if (CGRectContainsPoint(leftRect, point) && CGRectContainsPoint(topRect, point)){
        panDropPosition = kPanDropPositionTopLeft;
    } else if (CGRectContainsPoint(rightRect, point) && CGRectContainsPoint(topRect, point)){
        panDropPosition = kPanDropPositionTopRight;
    } else if (CGRectContainsPoint(leftRect, point) && CGRectContainsPoint(bottomRect, point)){
        panDropPosition = kPanDropPositionBottomLeft;
    } else if (CGRectContainsPoint(rightRect, point) && CGRectContainsPoint(bottomRect, point)){
        panDropPosition = kPanDropPositionBottomRight;
    }
    return panDropPosition;
}

- (void)positionPublisherViewAtPoint:(CGPoint)point animated:(BOOL)animated{
    kPanDropPosition panDropPosition = [self dropPositionAtPoint:point];
    [self positionPublisherViewAtPosition:panDropPosition animated:animated];
}

- (void)positionPublisherViewAtPosition:(kPanDropPosition)panDropPosition animated:(BOOL)animated{
    lastPanDropPosition = panDropPosition;
    
    CGFloat margin = 0.0;
    NSArray *constraints = @[];
    UIView *mainView = self.cameraView;
    UIView *childView = self.logoView;
    
    switch (panDropPosition){
        case kPanDropPositionTopLeft:
            constraints = @[[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-margin],
                            [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-margin]];
            break;
        case kPanDropPositionTopRight:
            constraints = @[[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin],
                            [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-margin]];
            break;
        case kPanDropPositionBottomLeft:
            constraints = @[[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-margin],
                            [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin]];
            break;
        case kPanDropPositionBottomRight:
            constraints = @[[NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeRight multiplier:1.0 constant:margin],
                            [NSLayoutConstraint constraintWithItem:mainView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                                            toItem:childView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin]];
            break;
    }
    
    //    [childView removeFromSuperview];
    //    [mainView addSubview:childView];
    
    if (self.logoViewMarginConstraintCollection){
        [mainView removeConstraints:self.logoViewMarginConstraintCollection];
    }
    self.logoViewMarginConstraintCollection = constraints;
    [mainView addConstraints:self.logoViewMarginConstraintCollection];
    
    if (animated){
        [self animatePublisherViewConstraints];
    } else {
        [self.logoView layoutIfNeeded];
    }
    
}

- (void)animatePublisherViewConstraints{
    [UIView animateWithDuration:0.5 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.logoView layoutIfNeeded];
                     } completion:^(BOOL finished){
                     }];
}

#pragma iOS7 share options
- (void)presentiOS7ShareOptions{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Twitter", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Facebook", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Save to Photos", nil)];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0: {} break;
        case 1: { [self shareImageOnTwitter:self.renderedImage]; } break;
        case 2: { [self shareImageOnFacebook:self.renderedImage]; } break;
        case 3: { [self saveImageToSavedPhotosAlbum:self.renderedImage]; } break;
        default: break;
    }
}
- (void)saveImageToSavedPhotosAlbum:(UIImage*)image{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self showMessage:NSLocalizedString(@"Photo saved!", nil)];
}
- (void)shareImageOnTwitter:(UIImage*)image{
    SLComposeViewController* tweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    tweet.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                [self showMessage:NSLocalizedString(@"Cancelled", nil)];
                break;
            case SLComposeViewControllerResultDone:
                [self showMessage:NSLocalizedString(@"Thanks for sharing!", nil)];
                break;
        }
    };
    NSString *initialText = [self.logoView titleForCurrentImage];
    [tweet setInitialText:initialText]; //The default text in the tweet
    [tweet addImage:image]; //Add an image
    [tweet addURL:[NSURL URLWithString:@"http://www.marriagequality.ie"]]; //A url which takes you into safari if tapped on
    [self presentViewController:tweet animated:YES completion: ^{
    }];
}
- (void)shareImageOnFacebook:(UIImage*)image{
    SLComposeViewController *facebookPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    facebookPost.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                [self showMessage:NSLocalizedString(@"Cancelled", nil)];
                break;
            case SLComposeViewControllerResultDone:
                [self showMessage:NSLocalizedString(@"Thanks for sharing!", nil)];
                break;
        }
    };
    NSString *initialText = [self.logoView titleForCurrentImage];
    [facebookPost setInitialText:initialText]; //The default text in the tweet
    [facebookPost addImage:image]; //Add an image
    [facebookPost addURL:[NSURL URLWithString:@"http://www.marriagequality.ie"]]; //A url which takes you into safari if tapped on
    [self presentViewController:facebookPost animated:YES  completion:^{
    }];
}

- (void)showMessage:(NSString*)message{
    OSLabel *label = [[OSLabel alloc] initWithFrame:CGRectZero];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setPadding:20.0];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:message];
    [label setFont:[[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] fontWithSize:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline].pointSize*2.0]];
    [label setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    [label setTextColor:[UIColor whiteColor]];
    [label.layer setCornerRadius:8.0];
    [label.layer setMasksToBounds:YES];
    [self.cameraView addSubview:label];
    
    [self.cameraView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cameraView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
    [self.cameraView addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cameraView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
    [self.cameraView setNeedsLayout];

    CGFloat animationDuration = 0.32;
    CGFloat animationDelay = 1.0;
    
    //regular animation
    label.alpha = 1.0;
    [UIView animateWithDuration:animationDuration delay:animationDelay usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         label.alpha = 0.0;
                         label.transform = CGAffineTransformMakeScale(0.01, 0.01);
                     } completion:^(BOOL finished){
                         [label removeFromSuperview];
                     }];
}

@end

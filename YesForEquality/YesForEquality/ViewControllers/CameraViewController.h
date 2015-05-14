//
//  CameraViewController.h
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>

#import "CameraController.h"

@interface CameraViewController : GAITrackedViewController <CameraControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

@end

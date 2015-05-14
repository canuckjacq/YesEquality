//
//  ReminderViewController.h
//  YesForEquality
//
//  Created by rafaelajopia on 28/03/15.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics-iOS-SDK/GAI.h>

@interface ReminderViewController : GAITrackedViewController

@property (weak, nonatomic) IBOutlet UISwitch *dayReminderSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *dayBeforeReminderSwitch;

- (IBAction)dayReminder:(id)sender;
- (IBAction)dayBeforeReminder:(id)sender;

@end

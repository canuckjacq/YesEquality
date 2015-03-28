//
//  ReminderViewController.m
//  YesForEquality
//
//  Created by rafaelajopia on 28/03/15.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "ReminderViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:(v) options:NSNumericSearch] != NSOrderedAscending)

@interface ReminderViewController ()

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set switch status according to NSUserDefaults
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"dayReminder"]) {
        [self.dayReminderSwitch setOn:NO animated:NO];
        
    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"dayBeforeReminder"]) {
        [self.dayBeforeReminderSwitch setOn:NO animated:NO];
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if ([self isRegisteredForLocalNotifications] == NO) {
        [self.dayReminderSwitch setOn:NO animated:NO];
        [self.dayBeforeReminderSwitch setOn:NO animated:NO];
    }
    
    //Set NSUserDefaults for Notifications
    if ([self.dayReminderSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayReminder"];

    }

    if ([self.dayBeforeReminderSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayBeforeReminder"];

    }
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToSettings{

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (IBAction)dayReminder:(id)sender {
    
    if ([self isRegisteredForLocalNotifications] == NO) {
        [self goToSettings];
    }
    
    if (![sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dayReminder"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayReminder"];
    }
    
}

- (IBAction)dayBeforeReminder:(id)sender {
    
    if ([self isRegisteredForLocalNotifications] == NO) {
        [self goToSettings];
    }
    
    if (![sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"dayBeforeReminder"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayBeforeReminder"];
    }

}

- (BOOL)isRegisteredForLocalNotifications{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
            
            UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            
            if (grantedSettings.types == UIUserNotificationTypeNone) {
                NSLog(@"No permiossion granted");
                return NO;
            }
            return YES;
            
        }
    }
    return NO;
    
}

- (IBAction)dismiss {

    [self dismissViewControllerAnimated:YES completion:nil];

}
@end

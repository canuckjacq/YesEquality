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
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set switch status according to NSUserDefaults
    BOOL dayReminder = [[NSUserDefaults standardUserDefaults] boolForKey:@"dayReminder"];
    BOOL dayBeforeReminder = [[NSUserDefaults standardUserDefaults] boolForKey:@"dayBeforeReminder"];
    
    [self.dayReminderSwitch setOn:dayReminder animated:NO];
    [self.dayBeforeReminderSwitch setOn:dayBeforeReminder animated:NO];
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
    
    BOOL dayReminder = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setBool:dayReminder forKey:@"dayReminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (IBAction)dayBeforeReminder:(id)sender {
    if ([self isRegisteredForLocalNotifications] == NO) {
        [self goToSettings];
    }
    
    BOOL dayBeforeReminder = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setBool:dayBeforeReminder forKey:@"dayBeforeReminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (BOOL)isRegisteredForLocalNotifications{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){ // Check it's iOS 8 and above
            
            UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            
            if (grantedSettings.types == UIUserNotificationTypeNone) {
                NSLog(@"No permission granted");
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

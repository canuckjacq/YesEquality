//
//  AppDelegate.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "AppDelegate.h"
#import "constants.h"
#import "YESHKConfigurator.h"
#import <ShareKit/ShareKit.h>
#import <ShareKit/SHKFacebook.h>
#import <ShareKit/SHKConfiguration.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIPageControl.appearance.pageIndicatorTintColor = UIColor.blackColor;
    YESHKConfigurator *configurator = [[YESHKConfigurator alloc] init];
    UIPageControl.appearance.currentPageIndicatorTintColor = UIColor.redColor;
    
    // Ask for Notification permissions
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    }

    //only set the defaults to YES if it hasn't already been set
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"dayBeforeReminder"]==nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"dayReminder"]==nil){
        
        if( [[NSUserDefaults standardUserDefaults] objectForKey:@"dayReminder"] == nil){
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                UIUserNotificationSettings *grantedSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
                if (grantedSettings.types == UIUserNotificationTypeNone) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayBeforeReminder"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayReminder"];
                }
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayBeforeReminder"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"dayReminder"];
            }
        }
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [self saveReminders];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    NSString *scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    return YES;
}

#pragma custom methods
- (void)saveReminders{
    UIApplication *app = [UIApplication sharedApplication];
    [app cancelAllLocalNotifications];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSString *dayReminderUUID = @"dayReminderUUID";
    NSString *dayBeforeReminderUUID = @"dayBeforeReminderUUID";
    NSString *alertBodyDay = @"Don´t forget to vote!";
    NSString *alertBodyDayBefore = @"Remind your friends to vote YES!";
    BOOL useDayReminder = [[NSUserDefaults standardUserDefaults] boolForKey:@"dayReminder"];
    BOOL useDayBeforeReminder= [[NSUserDefaults standardUserDefaults] boolForKey:@"dayBeforeReminder"];
    
    if (useDayReminder){
        NSString *alertBody = alertBodyDay;
        
        // Set the day for the notification
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *componentsDayReminder = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:[NSDate date]];
        [componentsDayReminder setDay:22];
        [componentsDayReminder setMonth:5];
        [componentsDayReminder setYear:2015];
        [componentsDayReminder setHour:8];
        [componentsDayReminder setMinute:58];
        NSDate *dayReminder = [gregorian dateFromComponents:componentsDayReminder];
        
        // Create notification for the day
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.userInfo = @{@"uuid":dayReminderUUID};
        notification.repeatInterval = NSCalendarUnitDay;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        [notification setAlertBody:alertBody];
        [notification setFireDate:dayReminder];
        [notification setTimeZone:[NSTimeZone defaultTimeZone]];
        [app scheduleLocalNotification:notification];
    } else {
        [self deleteLocalNotificationForUUID:dayReminderUUID];
    }
    
    
    if (useDayBeforeReminder){
        NSString *alertBody = alertBodyDayBefore;
        
        // Set the day before for the notification
        NSDateComponents *componentsDayBeforeReminder = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:[NSDate date]];
        [componentsDayBeforeReminder setDay:21];
        [componentsDayBeforeReminder setMonth:5];
        [componentsDayBeforeReminder setYear:2015];
        [componentsDayBeforeReminder setHour:12];
        [componentsDayBeforeReminder setMinute:58];
        NSDate *dayBeforeReminder = [gregorian dateFromComponents:componentsDayBeforeReminder];
        
        // Create notification for the day before
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        notification.userInfo = @{@"uuid":dayBeforeReminderUUID};
        notification.repeatInterval = NSCalendarUnitDay;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.applicationIconBadgeNumber = 1;
        
        [notification setAlertBody:alertBody];
        [notification setFireDate:dayBeforeReminder];
        [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
        [app scheduleLocalNotification:notification];
    } else {
        [self deleteLocalNotificationForUUID:dayBeforeReminderUUID];
        
    }
    
}
- (void)deleteLocalNotificationForUUID:(NSString*)uuidToDelete{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *scheduledLocalNotifications = [app scheduledLocalNotifications];
    [scheduledLocalNotifications enumerateObjectsUsingBlock:^(UILocalNotification *oneEvent, NSUInteger idx, BOOL *stop){
        NSString *uuid = [NSString stringWithFormat:@"%@",oneEvent.userInfo[@"uuid"]];
        //Cancel local notification
        if ([uuid isEqualToString:uuidToDelete]){
            [app cancelLocalNotification:oneEvent];
        }
    }];
}

@end

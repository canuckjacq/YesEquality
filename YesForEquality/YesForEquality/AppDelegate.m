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

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    // Create notification for the day
    UILocalNotification *notificationDay = [[UILocalNotification alloc]init];
    notificationDay.repeatInterval = NSCalendarUnitDay;
    notificationDay.soundName = UILocalNotificationDefaultSoundName;
    notificationDay.applicationIconBadgeNumber = 1;
    
    // Create notification for the day before
    UILocalNotification *notificationDayBefore = [[UILocalNotification alloc]init];
    notificationDayBefore.repeatInterval = NSCalendarUnitDay;
    notificationDayBefore.soundName = UILocalNotificationDefaultSoundName;
    notificationDayBefore.applicationIconBadgeNumber = 1;
    
    
    // Set the day for the notification
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsDayReminder = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:[NSDate date]];
    
    [componentsDayReminder setDay:22];
    [componentsDayReminder setMonth:5];
    [componentsDayReminder setYear:2015];
    [componentsDayReminder setHour:8];
    [componentsDayReminder setMinute:58];
    
    NSDate *dayReminder = [gregorian dateFromComponents:componentsDayReminder];
    
    
    // Set the day before for the notification
    NSDateComponents *componentsDayBeforeReminder = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:[NSDate date]];
    
    [componentsDayBeforeReminder setDay:21];
    [componentsDayBeforeReminder setMonth:5];
    [componentsDayBeforeReminder setYear:2015];
    [componentsDayBeforeReminder setHour:12];
    [componentsDayBeforeReminder setMinute:58];
    
    NSDate *dayBeforeReminder = [gregorian dateFromComponents:componentsDayBeforeReminder];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"dayReminder"]) {
        [notificationDay setAlertBody:@"Don´t forget to vote!"];
        [notificationDay setFireDate:dayReminder];
        [notificationDay setTimeZone:[NSTimeZone defaultTimeZone]];
        [application setScheduledLocalNotifications:[NSArray arrayWithObject:notificationDay]];
        [application scheduleLocalNotification:notificationDay];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"dayBeforeReminder"]){
        [notificationDayBefore setAlertBody:@"Remind your friends to vote YES!"];
        [notificationDayBefore setFireDate:dayBeforeReminder];
        [notificationDayBefore setTimeZone:[NSTimeZone  defaultTimeZone]];
        [application scheduleLocalNotification:notificationDayBefore];
    }

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

@end

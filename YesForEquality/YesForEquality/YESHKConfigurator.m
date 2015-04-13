//
//  YESHKConfigurator.m
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "YESHKConfigurator.h"
#import <Accounts/Accounts.h>

@implementation YESHKConfigurator

- (NSString *)appURL {
    return @"http://yesequality.ie";
}

- (NSString *)facebookAppId {
    return @"1432004707093159";
}

- (NSArray *)facebookWritePermissions {
    return @[@"publish_actions"];
}

- (NSNumber *)forcePreIOS5TwitterAccess {
    return [NSNumber numberWithBool:![YESHKConfigurator hasLocalTwitterAccounts]];
}

- (NSString *)twitterConsumerKey {
    return @"XVHg8zJter8nlSZz8rKEBc09d";
}

- (NSString *)twitterSecret {
    return @"ceakbSjPxr9DJjVKfOyh30zFJAFMSHf1EjU6raeWSjPeX8lmfc";
}
- (NSString *)twitterCallbackUrl {
    return @"http://example.com/authorize";
}

+ (BOOL)hasLocalTwitterAccounts {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
    
    return accounts.count > 0;
}

@end

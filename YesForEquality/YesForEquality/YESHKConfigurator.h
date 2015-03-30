//
//  YESHKConfigurator.h
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <ShareKit/DefaultSHKConfigurator.h>

@interface YESHKConfigurator : DefaultSHKConfigurator

- (NSString *)appURL;

- (NSString *)facebookAppId;
- (NSArray *)facebookWritePermissions;

- (NSString *)twitterConsumerKey;
- (NSString *)twitterSecret;
- (NSString *)twitterCallbackUrl;

+ (BOOL)hasLocalTwitterAccounts;

@end

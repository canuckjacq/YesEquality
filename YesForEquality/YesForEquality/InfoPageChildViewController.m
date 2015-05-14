//
//  InfoPageChildViewController.m
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "InfoPageChildViewController.h"

@interface InfoPageChildViewController ()

@property (nonatomic, strong) NSString *topText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *bottomText;
@property (nonatomic, strong) UIColor *backgroundColour;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *linkTitle;

@end

@implementation InfoPageChildViewController

- (instancetype)initWithTopText:(NSString *)topText
                          image:(UIImage *)image
                     bottomText:(NSString *)bottomText
               backgroundColour:(UIColor *)backgroundColour
                      textColor:(UIColor *)textColor
                            url:(NSURL*)url
                      linkTitle:(NSString*)linkTitle{
    if (self = [super init]) {
        self.topText = topText;
        self.image = image;
        self.bottomText = bottomText;
        self.backgroundColour = backgroundColour;
        self.textColor = textColor;
        if (url){
            self.url = url;
        }
        self.linkTitle = linkTitle;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

  self.screenName = @"InfoPageChildViewController";
    
    self.topLabel.text = self.topText;
    self.imageView.image = self.image;
    self.bottomLabel.text = self.bottomText;
    
    self.view.backgroundColor = self.backgroundColour;

    self.topLabel.textColor = self.textColor;
    self.bottomLabel.textColor = self.textColor;

    [self addLink:self.url];
}

- (void)viewDidAppear:(BOOL)animated{
    if (self.url){
        UITapGestureRecognizer *tap;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptToOpenURL:)];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView addGestureRecognizer:tap];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptToOpenURL:)];
        [self.bottomLabel addGestureRecognizer:tap];
    }
}


- (void)addLink:(NSURL*)url{
    if (url){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(promptToOpenURL:)];
        [self.imageView addGestureRecognizer:tap];
        [self.imageView setUserInteractionEnabled:YES];
        [self.bottomLabel addGestureRecognizer:tap];
    }
}

- (void)promptToOpenURL:(NSURL*)url{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:self.linkTitle
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"No", nil)
                                          otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex) {
        [[UIApplication sharedApplication] openURL:self.url];
    }
}


@end

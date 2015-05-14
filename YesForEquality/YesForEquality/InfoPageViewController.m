//
//  InfoPageViewController.m
//  YesForEquality
//
//  Created by Adam Govan on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "InfoPageViewController.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

#include "InfoPageCoverViewController.h"
#include "InfoPageChildViewController.h"

#define kPageDownloadForm 6

@interface InfoPageViewController () {
    NSUInteger currentIndex;
}

@property (nonatomic, strong) NSMutableArray *infoViewControllers;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.infoViewControllers = [NSMutableArray array];
    
    //[self.infoViewControllers addObject:[[InfoPageCoverViewController alloc] init]];
    
    for (NSDictionary *info in [self childPageInfo]) {
        InfoPageChildViewController *child = [[InfoPageChildViewController alloc] initWithTopText:info[@"title"]
                                                                                            image:info[@"image"]
                                                                                       bottomText:info[@"bottomText"]
                                                                                 backgroundColour:info[@"backgroundColor"]
                                                                                        textColor:info[@"textColor"]
                                                                                              url:info[@"url"]
                                                                                        linkTitle:info[@"linkTitle"]];
        [self.infoViewControllers addObject:child];
    }
    
    [self setViewControllers:@[self.infoViewControllers.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    button.frame = CGRectMake(0.0, 20.0, 60.0, 40.0);
    
    [button addTarget:self.parentViewController action:@selector(didTouchUpInsideBackButton) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = button;
    
    [self.view addSubview:self.closeButton];
}

- (void)viewDidAppear:(BOOL)animated
{
  // May return nil if a tracker has not already been initialized with a
  // property ID.
  id tracker = [[GAI sharedInstance] defaultTracker];

  // This screen name value will remain set on the tracker and sent with
  // hits until it is set to a new value or to nil.
  [tracker set:kGAIScreenName
         value:@"InfoPageViewController"];

  // New SDK versions
  [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

}

- (NSArray *)childPageInfo {
    return @[
             @{@"title":@"To vote on May 22nd you must be:", @"image":[UIImage imageNamed:@"1"], @"bottomText":@"Aged over 18", @"backgroundColor":[UIColor colorWithRed:0.5 green:0.27 blue:0.59 alpha:1],@"textColor":[UIColor whiteColor]},
             @{@"title":@"To vote on May 22nd you must be:", @"image":[UIImage imageNamed:@"2"], @"bottomText":@"Irish Citizen", @"backgroundColor":[UIColor colorWithRed:0.14 green:0.47 blue:0.73 alpha:1],@"textColor":[UIColor whiteColor]},
             @{@"title":@"To vote on May 22nd you must be:", @"image":[UIImage imageNamed:@"3"], @"bottomText":@"Resident in the republic", @"backgroundColor":[UIColor colorWithRed:0.19 green:0.22 blue:0.55 alpha:1],@"textColor":[UIColor whiteColor]},
             @{@"title":@"To vote on May 22nd you must be:", @"image":[UIImage imageNamed:@"4"], @"bottomText":@"Registered to vote", @"backgroundColor":[UIColor colorWithRed:0.62 green:0.15 blue:0.39 alpha:1],@"textColor":[UIColor whiteColor]},
             @{@"title":@"Check to see if you are registered", @"image":[UIImage imageNamed:@"5"], @"bottomText":@"checktheregister.ie", @"backgroundColor":[UIColor colorWithRed:0.16 green:0.16 blue:0.38 alpha:1],@"textColor":[UIColor whiteColor], @"url":[NSURL URLWithString:@"http://www.checktheregister.ie"],@"linkTitle":@"Open link in Safari?"},
             @{@"title":@"On May 22nd", @"image":[UIImage imageNamed:@"9"], @"bottomText":@"Polling stations will be open from 7am to 10pm.", @"backgroundColor":[UIColor colorWithRed:0.49 green:0.75 blue:0.3 alpha:1],@"textColor":[UIColor whiteColor]},
             @{@"title":@"And remember...", @"image":[UIImage imageNamed:@"Logo"], @"bottomText":@"Your vote counts.\nDon't forget\nto use it.\n yesequality.ie", @"backgroundColor":[UIColor whiteColor],@"textColor":[UIColor darkGrayColor], @"url":[NSURL URLWithString:@"http://www.yesequality.ie"],@"linkTitle":@"Open link in Safari?"},
    
             ];
}

- (void)didTouchUpInsideBackButton {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewDidLayoutSubviews {
    UIScrollView *scrollView = nil;
    UIPageControl *pageControl = nil;
    
    for (UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIScrollView class]] ) {
            scrollView = (UIScrollView*)view;
        }
        else if ([view isKindOfClass:[UIPageControl class]]) {
            pageControl = (UIPageControl*)view;
        }
    }
    
    if (scrollView != nil && pageControl != nil) {
        scrollView.frame = self.view.bounds;
        [self.view bringSubviewToFront:pageControl];
    }
    
    [super viewDidLayoutSubviews];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    return self.infoViewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController
{
    currentIndex = [self.infoViewControllers indexOfObject:viewController];
    
    if (currentIndex == 0) {
        return nil;
    }
    
    --currentIndex;
    currentIndex = currentIndex % self.infoViewControllers.count;
    
    UIViewController *controller = [self customiseViewControllerAtIndex:currentIndex];
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    currentIndex = [self.infoViewControllers indexOfObject:viewController];
    
    if (currentIndex == self.infoViewControllers.count - 1) {
        return nil;
    }
    
    ++currentIndex;
    currentIndex = currentIndex % self.infoViewControllers.count;

    UIViewController *controller = [self customiseViewControllerAtIndex:currentIndex];

    return controller;
}

- (UIViewController*)customiseViewControllerAtIndex:(NSUInteger)index{
    UIViewController *controller = [self.infoViewControllers objectAtIndex:index];

    UIColor *textColor = [self textColorForPageAtIndex:currentIndex];
    if (textColor){
        [self.closeButton setTintColor:textColor];
    }
    
    if (currentIndex==kPageDownloadForm){
        InfoPageChildViewController *childController = (InfoPageChildViewController*)controller;
        
        return childController;
        
    } else {
        return controller;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.infoViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIColor*)textColorForPageAtIndex:(NSUInteger)index{
    if (currentIndex < [[self childPageInfo] count]){
        NSDictionary *pageInfo = [self childPageInfo][currentIndex];
        if (pageInfo && pageInfo[@"textColor"]){
            UIColor *textColor = pageInfo[@"textColor"];
            return textColor;
        }
    }
    return nil;
}


@end

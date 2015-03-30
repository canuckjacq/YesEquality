//
//  InfoPageViewController.m
//  YesForEquality
//
//  Created by Adam Govan on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "InfoPageViewController.h"

#include "InfoPageCoverViewController.h"
#include "InfoPageChildViewController.h"

@interface InfoPageViewController ()

@property (nonatomic, strong) NSMutableArray *infoViewControllers;

@end

@implementation InfoPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.infoViewControllers = [NSMutableArray array];

    [self.infoViewControllers addObject:[[InfoPageCoverViewController alloc] init]];

    for (NSArray *info in [self childPageInfo]) {
        InfoPageChildViewController *child = [[InfoPageChildViewController alloc] initWithTopText:info[0]
                                                                                             image:info[1]
                                                                                        bottomText:info[2]
                                                                                  backgroundColour:info[3]];
        [self.infoViewControllers addObject:child];
    }
    
    [self setViewControllers:@[self.infoViewControllers.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 20.0, 60.0, 40.0);
    button.tintColor = [UIColor blueColor];
    
    [button addTarget:self.parentViewController
               action:@selector(didTouchUpInsideBackButton)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (NSArray *)childPageInfo {
    return @[
        @[@"To vote on May 22nd you must be:", [UIImage imageNamed:@"1"], @"Aged over 18", [UIColor colorWithRed:0.5 green:0.27 blue:0.59 alpha:1]],
        @[@"To vote on May 22nd you must be:", [UIImage imageNamed:@"2"], @"Irish Citizen", [UIColor colorWithRed:0.14 green:0.47 blue:0.73 alpha:1]],
        @[@"To vote on May 22nd you must be:", [UIImage imageNamed:@"3"], @"Resident in the republic", [UIColor colorWithRed:0.19 green:0.22 blue:0.55 alpha:1]],
        @[@"To vote on May 22nd you must be:", [UIImage imageNamed:@"4"], @"Registered To Vote", [UIColor colorWithRed:0.62 green:0.15 blue:0.39 alpha:1]],
        @[@"Check to see if you are registered", [UIImage imageNamed:@"5"], @"checktheregister.ie", [UIColor colorWithRed:0.16 green:0.16 blue:0.38 alpha:1]],
        @[@"Registering is easy", [UIImage imageNamed:@"6"], @"Download the Form", [UIColor colorWithRed:0.09 green:0.58 blue:0.3 alpha:1]],
        @[@"Registering is easy", [UIImage imageNamed:@"7"], @"Get is signed & stamped by a Garda", [UIColor colorWithRed:0.56 green:0.18 blue:0.55 alpha:1]],
        @[@"Registering is easy", [UIImage imageNamed:@"8"], @"Return it to your local authority office", [UIColor colorWithRed:0.74 green:0.14 blue:0.2 alpha:1]],
        @[@"Student?", [UIImage imageNamed:@"9"], @"You can vote by post", [UIColor colorWithRed:0.49 green:0.75 blue:0.3 alpha:1]],
        @[@"Away for work?", [UIImage imageNamed:@"10"], @"You can vote by post too!", [UIColor colorWithRed:0.5 green:0.27 blue:0.59 alpha:1]],
        @[@"Changed address?", [UIImage imageNamed:@"11"], @"There’s a form for that.", [UIColor colorWithRed:0.14 green:0.47 blue:0.73 alpha:1]]
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
    NSUInteger currentIndex = [self.infoViewControllers indexOfObject:viewController];
    
    if (currentIndex == 0) {
        return nil;
    }
    
    --currentIndex;
    currentIndex = currentIndex % self.infoViewControllers.count;
    return [self.infoViewControllers objectAtIndex:currentIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.infoViewControllers indexOfObject:viewController];
    
    if (currentIndex == self.infoViewControllers.count - 1) {
        return nil;
    }
    
    ++currentIndex;
    currentIndex = currentIndex % self.infoViewControllers.count;
    return [self.infoViewControllers objectAtIndex:currentIndex];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.infoViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end

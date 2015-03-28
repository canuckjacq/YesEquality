//
//  InfoPageViewController.m
//  YesForEquality
//
//  Created by Adam Govan on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "InfoPageViewController.h"
#include "InfoPageChildViewController.h"

@interface InfoPageViewController ()

@property (nonatomic, strong) NSMutableArray *infoViewControllers;

@end

@implementation InfoPageViewControllerg

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *pageTexts = [self pageTexts];
    
    self.infoViewControllers = [NSMutableArray array];
    
    for (NSArray *info in pageTexts) {
        InfoPageChildViewController *child = [[InfoPageChildViewController alloc] initWithTopText:info[0]
                                                                                             image:nil
                                                                                        bottomText:info[1]
                                                                                  backgroundColour:info[2]];
        [self.infoViewControllers addObject:child];
    }
    
    [self setViewControllers:@[self.infoViewControllers.firstObject]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO
                  completion:nil];
}

- (NSArray *)pageTexts {
    return @[
        @[@"To vote on May 22nd you must be:", @"Aged over 18", [UIColor whiteColor]],
        @[@"To vote on May 22nd you must be:", @"Irish Citizen", [UIColor whiteColor]],
        @[@"To vote on May 22nd you must be:", @"Resident in the republic", [UIColor whiteColor]],
        @[@"To vote on May 22nd you must be:", @"Registered To Vote", [UIColor whiteColor]],
        @[@"Check to see if you are registered", @"checktheregister.ie", [UIColor whiteColor]],
        @[@"Registering is easy", @"Download the Form", [UIColor purpleColor]],
        @[@"Registering is easy", @"Get is signed & stamped by a Garda", [UIColor redColor]],
        @[@"Registering is easy", @"Return it to your local authority office", [UIColor blueColor]],
        @[@"Student?", @"You can vote by post", [UIColor orangeColor]],
        @[@"Away for work?", @"You can vote by post too!", [UIColor greenColor]],
        @[@"Changed address?", @"There’s a form for that.", [UIColor blueColor]]
    ];
}

-(void)viewDidLayoutSubviews {
    if (self.view.subviews.count == 2 ) {
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

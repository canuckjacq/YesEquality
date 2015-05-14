//
//  YESInformationViewController.m
//  YesForEquality
//
//  Created by Michael on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "YESInformationViewController.h"
#import "YESContentViewController.h"

@interface YESInformationViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (strong,nonatomic) UIPageViewController *pageViewController;
@property (strong,nonatomic) NSArray *pageTitles;
@property (strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) IBOutlet UIButton *backButton;

@property NSInteger currentIndex;
@end

@implementation YESInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.screenName = @"YESInformationViewController";
    self.pageTitles = @[@"Page 1",@"Page 2",@"Page 3",@"Page 4",@"Page 5"];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    YESContentViewController *startingVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    self.pageViewController.view.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.pageViewController.view];
    [self.view bringSubviewToFront:self.imageView];
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.backButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YESContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((YESContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(YESContentViewController *) viewControllerAtIndex:(NSInteger)index {
    
    YESContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"yesPageContentVC"];
    
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    contentViewController.descriptionText = self.pageTitles[index];
    contentViewController.pageIndex = index;
    
    self.currentIndex = index;
    
    return contentViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSArray *array = pendingViewControllers;
    YESContentViewController *vc = (YESContentViewController *)array[0];
    self.pageControl.currentPage = vc.pageIndex;
}

-(IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end

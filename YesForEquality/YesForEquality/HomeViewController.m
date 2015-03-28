//
//  ViewController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "HomeViewController.h"
#import "YESInformationViewController.h"

static NSString * const kYESInfoStoryboardName = @"Info";
static NSString * const kYESMenuVCStoryboardId = @"YESInformationViewController";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)menuButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:kYESInfoStoryboardName bundle:nil];
    YESInformationViewController *viewController = [sb instantiateViewControllerWithIdentifier:kYESMenuVCStoryboardId];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end

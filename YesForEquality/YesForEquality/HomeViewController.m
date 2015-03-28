//
//  ViewController.m
//  YesForEquality
//
//  Created by Liam Dunne on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "HomeViewController.h"
#import "CameraViewController.h"

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
- (IBAction)didTapInformationButton:(id)sender {
    
}
- (IBAction)didTapRemindMeButton:(id)sender {
    
}
- (IBAction)didTapCameraButton:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    CameraViewController *controller = (CameraViewController*)[storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    [self presentViewController:controller animated:YES completion:^{}];
}

@end

//
//  YESContentViewController.m
//  YesForEquality
//
//  Created by Michael on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "YESContentViewController.h"

@interface YESContentViewController ()

@property (strong,nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation YESContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.descriptionLabel.text = self.descriptionText;
  self.screenName = @"YESContentViewController";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

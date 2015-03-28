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

@end

@implementation InfoPageChildViewController

- (instancetype)initWithTopText:(NSString *)topText
                          image:(UIImage *)image
                     bottomText:(NSString *)bottomText
               backgroundColour:(UIColor *)backgroundColour {
    if (self = [super init]) {
        self.topText = topText;
        self.image = image;
        self.bottomText = bottomText;
        self.backgroundColour = backgroundColour;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topLabel.text = self.topText;
    self.imageView.image = self.image;
    self.bottomLabel.text = self.bottomText;
    
    self.view.backgroundColor = self.backgroundColour;
    if (self.backgroundColour != [UIColor whiteColor]) {
        self.topLabel.textColor = [UIColor whiteColor];
        self.bottomLabel.textColor = [UIColor whiteColor];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    self.parentViewController.view.backgroundColor = self.backgroundColour;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

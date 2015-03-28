//
//  InfoPageChildViewController.h
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPageChildViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *bottomLabel;

- (instancetype)initWithTopText:(NSString *)topText
                          image:(UIImage *)image
                     bottomText:(NSString *)bottomText
               backgroundColour:(UIColor *)backgroundColour;

@end

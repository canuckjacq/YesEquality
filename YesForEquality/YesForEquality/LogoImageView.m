//
//  LogoImageView.m
//  YesForEquality
//
//  Created by Liam Dunne on 13/04/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "LogoImageView.h"

@interface LogoImageView () {
    NSArray *images;
    NSArray *titles;
    NSInteger indexOfCurrentImage;
}
@end

@implementation LogoImageView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    images = @[
               @"YES_ImVoting_white.png",
               @"YES_We'reVoting_white.png",
               @"YES_Me_white.png",
               @"YES_white.png",
               @"TA_white.png",

               @"YES_ImVoting.png",
               @"YES_We'reVoting.png",
               @"YES_Me.png",
               @"YES.png",
               @"TA.png",
               ];

    titles = @[
               @"I'm voting YES for Equality! #MarRef",
               @"We're voting YES for Equality! #MarRef",
               @"Vote YES for me! #MarRef",
               @"Vote YES! #MarRef",
               @"TÁ Comhionannas! #MarRef",
               
               @"I'm voting YES for Equality! #MarRef",
               @"We're voting YES for Equality! #MarRef",
               @"Vote YES for me! #MarRef",
               @"Vote YES! #MarRef",
               @"TÁ Comhionannas! #MarRef",
               ];

    indexOfCurrentImage = 0;
    [self setImage:[UIImage imageNamed:images[indexOfCurrentImage]]];
    [self setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNextImage)];
    [self addGestureRecognizer:tap];
    
}

- (void)showNextImage{
    indexOfCurrentImage++;
    indexOfCurrentImage = indexOfCurrentImage % images.count;

    CGFloat animationDuration = 0.18;

    //regular animation
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.alpha = 0.0;
                     } completion:^(BOOL finished){
                         [self setImage:[UIImage imageNamed:images[indexOfCurrentImage]]];
                         [self.superview setNeedsLayout];
                         [UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              self.alpha = 1.0;
                                          } completion:^(BOOL finished){
                                          }];
                     }];

    //bounce animation
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:animationDuration
                     animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:animationDuration delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
        }];
    }];
}

- (NSString*)titleForCurrentImage{
    return titles[indexOfCurrentImage];
}

@end

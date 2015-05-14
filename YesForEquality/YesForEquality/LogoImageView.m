//
//  LogoImageView.m
//  YesForEquality
//
//  Created by Liam Dunne on 13/04/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "LogoImageView.h"

@interface LogoImageView () {
  NSMutableArray *images;
  NSMutableArray *titles;
  NSInteger indexOfCurrentImage;
}
@property (nonatomic,strong) NSLayoutConstraint *aspectRatioConstraint;
@end

@implementation LogoImageView

- (void)awakeFromNib{
  [super awakeFromNib];
  [self setup];
}

- (void)setup{
  images = [[NSMutableArray alloc] initWithArray:
            @[
              @"im-voting_white.png",
              @"im-voting_color.png",
              @"were-voting_white.png",
              @"were-voting_color.png",
              @"voteforme_color.png",
              @"voteforme_white.png",
              @"YES_white.png",
              @"yes_color.png",
              @"TA_white.png",
              @"ta_color.png",
              ]];

  titles =[[NSMutableArray alloc] initWithArray:
           @[
             @"I'm voting YES for Equality! #MarRef",
             @"I'm voting YES for Equality! #MarRef",
             @"We're voting YES for Equality! #MarRef",
             @"We're voting YES for Equality! #MarRef",
             @"Vote YES for me! #MarRef",
             @"Vote YES for me! #MarRef",
             @"Vote YES! #MarRef",
             @"Vote YES! #MarRef",
             @"TÁ Comhionannas! #MarRef",
             @"TÁ Comhionannas! #MarRef",
             ]];
  indexOfCurrentImage = 0;

  NSDate *pollingDate = [NSDate dateWithTimeIntervalSince1970:1432249260];
  NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-100];
  if ([pollingDate timeIntervalSinceNow] <= 0) {
    [images addObject:@"itsAYes_colour.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];

    [images addObject:@"itsAYes_white.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];

    [images addObject:@"iVotedYes_colour.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];

    [images addObject:@"iVotedYes_white.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];

    [images addObject:@"yesThankYou_colour.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];

    [images addObject:@"yesThankYou_white.png"];
    [titles addObject:@"I voted! Have you? #MarRef"];


    indexOfCurrentImage = 10;
  }

  [self setImage:[UIImage imageNamed:images[indexOfCurrentImage]]];
  [self setUserInteractionEnabled:YES];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNextImage)];
  [self addGestureRecognizer:tap];

  [self updateAspectRatio];

}

- (void)showNextImage{
  indexOfCurrentImage++;
  indexOfCurrentImage = indexOfCurrentImage % images.count;

  CGFloat animationDuration = 0.1;

  //regular animation
  [UIView animateWithDuration:animationDuration
                   animations:^{
                     self.alpha = 0.0;
                   } completion:^(BOOL finished){
                     [self setImage:[UIImage imageNamed:images[indexOfCurrentImage]]];
                     [self sizeToFit];
                     [self updateAspectRatio];

                     [self.superview setNeedsLayout];
                     [UIView animateWithDuration:animationDuration*2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
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
                     [UIView animateWithDuration:animationDuration*2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState
                                      animations:^{
                                        self.transform = CGAffineTransformIdentity;
                                      } completion:^(BOOL finished){
                                      }];
                   }];
}

- (NSString*)titleForCurrentImage{
  return titles[indexOfCurrentImage];
}

- (void)updateAspectRatio{
  CGFloat width = 1.0;
  CGFloat height = 1.0;
  if (self.image){
    width = self.image.size.width;
    height = self.image.size.height;
  }
  [self removeConstraint:self.aspectRatioConstraint];
  self.aspectRatioConstraint =[NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeHeight
                               relatedBy:NSLayoutRelationEqual
                               toItem:self
                               attribute:NSLayoutAttributeWidth
                               multiplier:height/width
                               constant:0.0f];
  [self addConstraint:self.aspectRatioConstraint];
  [self layoutIfNeeded];
}

@end

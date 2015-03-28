//
//  InfoPageQuestionViewController.h
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoPageQuestionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *bodyLabel;

- (instancetype)initWithBodyText:(NSString *)bodyText;

@end

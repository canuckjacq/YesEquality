//
//  InfoPageQuestionViewController.m
//  YesForEquality
//
//  Created by Matt Donnelly on 28/03/2015.
//  Copyright (c) 2015 YesForEquality. All rights reserved.
//

#import "InfoPageQuestionViewController.h"

@interface InfoPageQuestionViewController ()

@property (nonatomic, strong) NSString *bodyText;

@end

@implementation InfoPageQuestionViewController

- (instancetype)initWithBodyText:(NSString *)bodyText {
    if (self = [super init]) {
        self.bodyText = bodyText;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bodyLabel.text = self.bodyText;
}

@end

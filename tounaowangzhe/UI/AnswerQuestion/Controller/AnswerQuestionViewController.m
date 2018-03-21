//
//  AnswerQuestionViewController.m
//  huanle
//
//  Created by Sj03 on 2018/1/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "AnswerQuestionViewController.h"


@interface AnswerQuestionViewController ()

@end

@implementation AnswerQuestionViewController
- (instancetype)initWithModel:(AnswerQuestionViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel.subject_TCPlink  sendNext:@YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

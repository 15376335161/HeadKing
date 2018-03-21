//
//  AnswerQuestionViewModel.m
//  huanle
//
//  Created by Sj03 on 2018/1/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "AnswerQuestionViewModel.h"
#import "AnswerTCPLink.h"

@implementation AnswerQuestionViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _subject_TCPlink = [[RACSubject alloc] init];
        [self initSigin];
    }
    
    return self;
}

- (void)initSigin {
    [self.subject_TCPlink subscribeNext:^(id x) {
        [[AnswerTCPLink share] starLink];
        
    }];
}
@end

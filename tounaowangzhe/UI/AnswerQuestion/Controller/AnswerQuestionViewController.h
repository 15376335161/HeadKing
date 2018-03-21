//
//  AnswerQuestionViewController.h
//  huanle
//
//  Created by Sj03 on 2018/1/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerQuestionViewModel.h"
@interface AnswerQuestionViewController : BaseViewController

@property (nonatomic, strong)AnswerQuestionViewModel *viewModel;
- (instancetype)initWithModel:(AnswerQuestionViewModel *)viewModel;
@end

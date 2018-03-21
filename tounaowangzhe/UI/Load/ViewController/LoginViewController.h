//
//  LoginViewController.h
//  huanle
//
//  Created by Sj03 on 2018/1/15.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : BaseViewController
- (instancetype)initWithComplete:(void(^)(NSInteger tag))completeBlock;
@end

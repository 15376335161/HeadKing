//
//  YMWebViewController.h
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "BaseViewController.h"

@interface YMWebViewController : BaseViewController
//网页链接
@property(nonatomic,copy)NSString* urlStr;
@property (nonatomic, copy)void (^complete)(void);
@end

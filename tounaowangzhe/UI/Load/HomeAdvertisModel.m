//
//  HomeAdvertisModel.m
//  huanle
//
//  Created by Sj03 on 2017/12/25.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import "HomeAdvertisModel.h"

@implementation HomeAdvertisModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _isopen = NO;
        _isdynamic = NO;
        _imageUrl = @"";
        _redirectUrl = @"";
    }
    return self;
}
- (void)getDateForServer:(NSDictionary *)dic {
    NSString *open = [dic stringForKey:@"open"];
    if ([open isEqualToString:@"off"]) {
        self.isopen = NO;
    } else if ([open isEqualToString:@"on"]) {
        self.isopen = YES;
    }
    NSString *dynamic = [dic stringForKey:@"is_dynamic"];
    if ([dynamic isEqualToString:@"yes"]) {
        self.isdynamic = YES;
    } else {
        self.isdynamic = NO;
    }
    self.imageUrl = [dic stringForKey:@"img_url"];
    self.redirectUrl = [dic stringForKey:@"redirect_url"];
}
@end

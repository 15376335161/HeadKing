//
//  HomeAdvertisModel.h
//  huanle
//
//  Created by Sj03 on 2017/12/25.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeAdvertisModel : NSObject
@property (nonatomic, assign)BOOL isopen;
@property (nonatomic, assign)BOOL isdynamic; // 是否为动态图
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSString *redirectUrl;

- (void)getDateForServer:(NSDictionary *)dic;
@end

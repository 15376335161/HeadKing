//
//  INIT.h
//  ColorfulFund
//
//  Created by Madis on 2016/10/6.
//  Copyright © 2016年 zritc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kTradeUrl = @"trade";
static NSString *const kPaymentUrl = @"payment";
static NSString *const kCooperationUrl = @"cooperation";
static NSString *const kPrivacyclauseUrl = @"privacyclause";
static NSString *const kRegUrl = @"reg";
static NSString *const kYingmibao = @"yingmibao";
static NSString *const kyingmiinfo = @"yingmiinfo";
static NSString *const kAboutDuocai = @"aboutduocai";
static NSString *const kAboutDuocaibao = @"aboutduocaibao";


#define INIT_BASE_URL(versions) [NSString stringWithFormat:@"http://172.16.101.202/colorweb/%@/",versions]

@interface INIT : NSObject
//支持的银行卡列表
@property (nonatomic,strong) NSMutableDictionary *bankInfoDict;
//支持的银行卡卡bin
@property (nonatomic,strong) NSMutableDictionary *bankCodeDict;
//组合信息(教育/心愿/激进/稳健/保守)
//@property (nonatomic,strong) NSMutableDictionary *poInfoDict;
// 版本信息
//@property (nonatomic, strong) NSMutableDictionary *versionDict;
@property (nonatomic,assign,readonly) BOOL initIsOK;
@property (nonatomic,assign,readonly) BOOL reloadInitIsOK;

+ (INIT *)share;

- (RACSignal *)signal_initInterfacesDict;


//监听网络状态从不可用变为可用
- (RACSignal *)signal_networkStatusChangedToReachable;
- (NSString *)interfaceAddressFromKey:(NSString *)keyString;

@end

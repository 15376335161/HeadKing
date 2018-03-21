//
//  UserInfo.m
//  daikuanchaoshi
//
//  Created by Sj03 on 2017/11/21.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import "UserInfo.h"
static UserInfo *_instance;

@implementation UserInfo
+ (UserInfo*)shareInstance
{
    //里面的代码永远都只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *personIdCard = [UserDefaultsTool getStringWithKey:userIdentifierNumber];
        self.personIdCard = personIdCard ? personIdCard:@"";
        NSString *name = [UserDefaultsTool getStringWithKey:userName];
        self.personName = name ? name:@"";
        NSString *phoneN = [UserDefaultsTool getStringWithKey:phoneNumber];
        self.phone = phoneN ? phoneN:@"";
        NSString *userId = [UserDefaultsTool getStringWithKey:kUid];
        self.uid = userId ? userId:@"";
        NSString *usertoken = [UserDefaultsTool getStringWithKey:kToken];
        self.token = usertoken ? usertoken:@"";
        BOOL isCerti = [UserDefaultsTool getBoolWithKey:isCertification];
        self.isCertification = isCerti;
        BOOL iscanchanges = [UserDefaultsTool getBoolWithKey:isCanChange];
        self.iscanchange = iscanchanges;
    }
    return self;
}


-(BOOL)isValidLogin {
    if ([[kUserDefauts valueForKey:kUid] integerValue] > 0 && [kUserDefauts valueForKey:kToken] ) {
        return YES;
    }else{
        return NO;
    }
}

- (void)getUserforLogin:(NSDictionary *)dic {
    self.token = [dic stringForKey:@"token"];
    self.phone = [dic stringForKey:@"phone"];
    self.uid = [dic stringForKey:@"uid"];
    self.personName = [dic stringForKey:@"real_name"];
    self.personIdCard = [dic stringForKey:@"card_number"];
    if (![self.personIdCard isEqualToString:@""] &&![self.personName isEqualToString:@""]) {
        self.isCertification = YES;
    } else {
        self.isCertification = NO;
    }
    
    [UserDefaultsTool setString:self.token withKey:kToken];
    [UserDefaultsTool setString:self.phone withKey:phoneNumber];
    [UserDefaultsTool setString:self.uid withKey:kUid];
    [UserDefaultsTool setString:self.personName withKey:userName];
    [UserDefaultsTool setString:self.personIdCard withKey:userIdentifierNumber];
    [UserDefaultsTool setBool:self.isCertification withKey:isCertification];
}

- (void)upDateforRealPerson:(NSDictionary *)dic {
    self.personName = [dic stringForKey:@"real_name"];
    self.personIdCard = [dic stringForKey:@"card_number"];
    if (![self.personIdCard isEqualToString:@""] &&![self.personName isEqualToString:@""]) {
        self.isCertification = YES;
    } else {
        self.isCertification = NO;
    }
    NSString *canchange  = [dic stringForKey:@"is_attestation"];
    if ([canchange isEqualToString:@"0"]) {
        self.iscanchange = YES;
    } else {
        self.iscanchange = NO;
    }
    
    [UserDefaultsTool setString:self.personName withKey:userName];
    [UserDefaultsTool setString:self.personIdCard withKey:userIdentifierNumber];
    [UserDefaultsTool setBool:self.isCertification withKey:isCertification];
    [UserDefaultsTool setBool:self.iscanchange withKey:isCanChange];
}

- (void)removeAllDate {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userIdentifierNumber];
    self.personIdCard = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userName];
    self.personName = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:phoneNumber];
    self.phone = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUid];
    self.uid = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kToken];
    self.token = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:isCertification];
    self.isCertification = NO;
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)requestPoAssetWithPoCode:(NSString *)poCode
                        callBack:(void (^)(BOOL isSucessed,id callBackObject) )callBack {
    
}




@end

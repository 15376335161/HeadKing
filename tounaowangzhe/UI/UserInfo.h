//
//  UserInfo.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2017/11/21.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString * uid;

@property (nonatomic, assign) BOOL isCertification;// 是否实名认证
@property (nonatomic, copy) NSString *personName; // 真实姓名
@property (nonatomic, copy) NSString *personIdCard;// 身份证号码
@property (nonatomic, assign)BOOL iscanchange; // 是否可以修改 绑定成功卡后不可修改。

+ (UserInfo*)shareInstance;
- (void)getUserforLogin:(NSDictionary *)dic;// 登录的时候获取token，uid 和phone
- (void)upDateforRealPerson:(NSDictionary *)dic; //  存储实名认证用户的信息
- (void)removeAllDate;

-(BOOL)isValidLogin;
@end

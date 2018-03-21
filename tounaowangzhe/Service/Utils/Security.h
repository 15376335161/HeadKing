//
//  Security.h
//  tounaowangzhe
//
//  Created by YouMeng on 2018/1/31.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Security : NSObject

//根据密匙初始化
-(instancetype) initWithKey:(NSString *) key;
//加密
-(NSString *) AES256EncryptWithString:(NSString *) str;
//解密
-(NSString *) AES256DecryptWithString:(NSString *) str;
//获取安全密匙
+(NSString*) getSecurityKey;

/**
 *  加密
 *
 *  @param string 需要加密的string
 *
 *  @return 加密后的字符串
 */
+ (NSString *)AES128EncryptStrig:(NSString *)string;

/**
 *  解密
 *
 *  @param string 加密的字符串
 *
 *  @return 解密后的内容
 */
+ (NSString *)AES128DecryptString:(NSString *)string;
//加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;

@end

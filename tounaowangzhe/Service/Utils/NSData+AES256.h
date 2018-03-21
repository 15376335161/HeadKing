//
//  NSData+AES256.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2018/1/16.
//  Copyright © 2018年 Sj03. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData(AES256)
-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
// 将加密的二进制转化成16进制字符
- (NSString *)AES256EncryptWithKeyString:(NSString *)key;
// 将解密的二进制转换成字符
- (NSString *)AES256DecryptWithKeyString:(NSString *)key;

 //加密
+(NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;
+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;
//解密
+ (NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;



@end


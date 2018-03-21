//
//  Security.m
//  tounaowangzhe
//
//  Created by YouMeng on 2018/1/31.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "Security.h"
#import "NSData+AES256.h"
#import "NSData+AES128.h"
#import "GTMBase64.h"

#define IV  @""//偏移量 16位长度的字符串
#define  KEY  @"52vJB87VF9z02qEM"

@interface Security ()

@property(strong,nonatomic) NSString *key;

@end

@implementation Security
//根据密匙初始化
-(instancetype) initWithKey:(NSString *) key{
    if (self = [super init]) {
        self.key = key;
    }
    return self;
}
//加密
-(NSString *) AES256EncryptWithString:(NSString *) str{
    NSData *dt1 = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dt2 = [dt1 aes256_encrypt:self.key];
    
    NSString *str2 = [dt2 base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return str2;
}
//解密
-(NSString *) AES256DecryptWithString:(NSString *) str{
    NSData *dt3 = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *dt4 = [dt3 aes256_decrypt:self.key];
    
    NSString *str4 = [[NSString alloc] initWithData:dt4 encoding:NSUTF8StringEncoding];
    
    return str4;
}
//获取安全密匙
+(NSString*) getSecurityKey{
    return kAES;
}
+ (NSString *)AES128EncryptStrig:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *aesData = [data AES128EncryptWithKey:KEY iv:IV];
    return [Security convertDataToHexStr:aesData];
}
+ (NSString *)AES128DecryptString:(NSString *)string{
    NSData *data  = [Security convertHexStrToData:string];
    NSData *aesData = [data AES128DecryptWithKey:KEY iv:IV];
    return [[NSString alloc] initWithData:aesData encoding:NSUTF8StringEncoding];
}

//16进制转换为NSData
+ (NSData*)convertHexStrToData:(NSString*)str {
    if (!str || [str length] ==0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc]initWithCapacity:[str length]*2];
    NSRange range;
    if ([str length] %2==0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc]initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location+= range.length;
        range.length=2;
    }
    //    NSLog(@"hexdata: %@", hexData);
    return hexData;
}

//NSData转换为16进制
+ (NSString*)convertDataToHexStr:(NSData*)data {
    if (!data || [data length] ==0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc]initWithCapacity:[data length]/2];
    
    [data enumerateByteRangesUsingBlock:^(const void*bytes,NSRange byteRange,BOOL*stop) {
        unsigned char *dataBytes = (unsigned  char*)bytes;
        for (NSInteger i =0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] ==2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}
/**
 *  aes128加密后的密文编码处理，参数为128加密后的密文
 */
- (NSString *)AES128Convert: (NSString *)aes128 {
    
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    return [aes128 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        //        return [GTMBase64 stringByEncodingData:resultData];
        return [self hexStringFromData:resultData];
        
    }
    free(buffer);
    return nil;
}

#pragma mark - 加密解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    //NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data=[self dataForHexString:encryptText];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] ;
    }
    free(buffer);
    return nil;
}

// 十六进制转换为普通字符串的。
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
}

// 普通字符串转换为十六进

+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
        
    }
    return hexStr;
}

//参考：http://blog.csdn.net/linux_zkf/article/details/17124577
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            
            byte = *ch - 'A' + 10;
            
        }
        
        ch++;
        
        byte = byte << 4;
        
        if (*ch) {
            
            if ('0' <= *ch && *ch <= '9') {
                
                byte += *ch - '0';
                
            } else if ('a' <= *ch && *ch <= 'f') {
                
                byte += *ch - 'a' + 10;
                
            }else if('A' <= *ch && *ch <= 'F'){
                
                byte += *ch - 'A' + 10;
                
            }
            
            ch++;
            
        }
        
        [data appendBytes:&byte length:1];
        
    }
    
    return data;
}

@end

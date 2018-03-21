//
//  NSMutableDictionary+Utils.m
//  iOSCodeProject
//
//  Created by Fox on 14-7-19.
//  Copyright (c) 2014年 翔傲信息科技（上海）有限公司. All rights reserved.
//

#import "NSMutableDictionary+Utils.h"


@implementation NSMutableDictionary (Utils)

- (void)addUnEmptyString:(NSString *)stringObject forKey:(NSString *)key{
    
    if ((![ToolUtil isStringNotEmpty:stringObject])) {
        [self setObject:@"" forKey:key];
    }else{
        [self setObject:stringObject forKey:key];
    }
}

@end

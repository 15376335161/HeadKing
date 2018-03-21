//
//  Config.h
//  huanle
//
//  Created by Sj03 on 2017/11/21.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#ifndef Defines_h
#define Defines_h


static BOOL isProduction = FALSE;
#define JpushAppKey      @"AppKey copied from JiGuang Portal application"
#define UMAppKey         @"UMAppKey"
#define kChannel          @"channel"
#define Version          @"8"    // 升级版本
#define KType                 @"jikedai_ios"

#define kAES                  @"52vJB87VF9z02qEM"
#define kJpushAppKey          @"c5597a5fd02cfaadf8187921"//一信贷
#define kIsProduct            YES

//注册协议
#define RegistProtocalURL    [NSString stringWithFormat:@"%@",@"https://www.hjr.com/Shop/Protocol/register.html"]

#define PrivacyURL    [NSString stringWithFormat:@"%@",@"https://www.hjr.com/Shop/Protocol/privacy.html"]
#define  BaseApi        @"https://www.hjr.com/" //  @"https://dk.youmeng.com/"

/*-------------------------预处理-----------------*/
#define dispatch_main_async(block) \
if ([NSThread isMainThread]) { \
block(); \
} \
else { \
dispatch_async(dispatch_get_main_queue(), block); \
}

//重新定义宏定义
#define LOG_LEVEL_DEF ddLogLevel
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#define LOG_ASYNC_ENABLED YES

//log日志输出
#ifdef DEBUG
//DDLogVerbose>DDLogDebug>DDLogInfo>DDLogWarn>DDLogError
#define MSLog(...) DDLogVerbose(__VA_ARGS__)
//NSLog(__VA_ARGS__)
//printf("\n%s %s:%s",__TIME__,__FUNCTION__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define MSLog(...) DDLogVerbose(__VA_ARGS__)
#endif


//判断是否是iphoneX
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define kAppVersions [NSString stringWithFormat:@"%@.%@",[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."][0],[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."][1]]


#define kScreenBounds         [[UIScreen mainScreen] bounds]
#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kApplicationSize      [[UIScreen mainScreen] applicationFrame].size       //(e.g. 320,460)
#define kApplicationWidth     [[UIScreen mainScreen] applicationFrame].size.width //(e.g. 320)
#define kApplicationHeight    [[UIScreen mainScreen] applicationFrame].size.height//不包含状态bar的高度(e.g. 460)

#define kUIWindow               [[[UIApplication sharedApplication] delegate] window] //获得window


#define RGB(r,g,b)          RGBA(r,g,b,1)
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00)>> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue &0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00)>> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define IMAGE_NAME(name)    [UIImage imageNamed:name]

#define kColorTitleBlack    UIColorFromRGB(0x333333)
#define kColorHWBlack       UIColorFromRGB(0x222222)
#define kColorWeekWhite     UIColorFromRGB(0xf1f1f1)
#define kColorBackground    UIColorFromRGB(0xf2f2f2)
#define kColorRed           [UIColor redColor]
#define kFontHWSmall        [UIFont systemFontOfSize:17.0]

#define kRate                   kScreenWidth / 375
#define kUserDefauts            [NSUserDefaults standardUserDefaults]
// 默认值
#define kNBButtonWidth          50
#define kNBTitleWidth           160

#define kHeightStatusBar        20
#define kHeightTabBar           49
#define kHeightNavigation       64
#define kHeightNavigationCustomView 30
#define kHeightCustomNavigation kHeightNavigation+kHeightNavigationCustomView

#define kHeightButtonBig        49
#define kHeightCellNormal       44
#define kHeightNormal           30
#define kHeightCellNormalEx     40

//字体大小
#define Font(a)        [UIFont systemFontOfSize:a]

//身份证照片
#define kFrontIdImg         @"frontIdPic"
#define kBackIdImg          @"backIdPic"
#define FrontIdImgFilePath   [[XCFileManager documentsDir]stringByAppendingPathComponent:@"frontIdImage.png"]
#define BackIdImgFilePath    [[XCFileManager documentsDir]stringByAppendingPathComponent:@"backIdImage.png"]


// 请求错误code
static NSString *const kRequestSuccessfulCode = @"1000";
static NSString *const kRequestErrorCode   = @"1001";
static NSString *const kSessionTimeoutCode = @"1002";

// 登录状态
static NSString *const isCertification = @"isCertification";// 是否登录
static NSString *const userAccountIdentifier = @"account"; //账户
static NSString *const userPasswordIdentifier = @"userPassword";
static NSString *const kUid = @"uid";// 用户id
static NSString *const isCanChange = @"iscanchange";// 是否可以修改实名

static NSString *const userName = @"userName"; // 用户名
static NSString *const userIdentifierNumber = @"useridentifierNumber";// 身份证号
static NSString *const kToken = @"token"; // 用户token
static NSString *const phoneNumber = @"phoneNumber"; //手机号码
static NSString *const LoginDate = @"LoginDate";

typedef enum : NSUInteger {
    BusinessTypeCrditCardWithdraw,        //信用卡收款
    BusinessTypeCrditCardReplaceRepayments//代替还信用卡
} BusinessType; // 业务类型

typedef enum : NSUInteger {
    BankCardTypeCredit,
    BankCardTypeSaving
} BankCardType; //银行卡类型


#define YMWeakSelf   __weak typeof(self) weakSelf = self

#define requestErrorStrings(error)  \
NSString *errorString = @"";\
if (error.userInfo) {\
NSDictionary *dict = error.userInfo;\
errorString = [NSString stringWithFormat:@"NSDebugDescription:%@",dict[@"NSDebugDescription"]];\
}else{\
errorString = error.description;\
}\
[[[UIAlertView alloc] initWithTitle:@"温馨提示"\
message:[NSString stringWithFormat:@"url:%@\nparams:%@\nerror.description:%@",url,params,errorString]\
delegate:nil\
cancelButtonTitle:@"好的"\
otherButtonTitles:nil] show];\

#define NAV_BACKBUTTON_DISABLE(sender) \
NSAssert([sender isKindOfClass:[UIButton class]], @"sender必须是UIButton类型");\
[(UIButton*)sender setEnabled:NO];

#endif /* Defines_h */

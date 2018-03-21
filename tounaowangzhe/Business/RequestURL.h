//
//  RequestURL.h
//  daikuanchaoshi
//
//  Created by Sj03 on 2017/11/22.
//  Copyright © 2017年 Sj03. All rights reserved.
//

#ifndef RequestURL_h
#define RequestURL_h

static  NSString *const ReViewURL  = @"http://daixiaoer.youmeng.com/load/index.html"; //审核链接

static  NSString *const StartAdURL  = @"https://www.hjr.com/Shop/Config/startAd"; //闪屏页广告

static  NSString *const LoginQuickURL  = @"http://hl.hjr.com/Api/Member/loginQuick"; // 快捷登录
//
static  NSString *const SendSmsCodeURL  = @"http://hl.hjr.com/Api/Member/sendLoginQuickCode";// 发送短信验证码
static  NSString *const GetIndexConfigURL  = @"http://hl.hjr.com/Api/App/getIndexConfig.html";// 获取首页配置

static  NSString *const GetBankListURL  = @"http://hl.hjr.com/Api/GetMoney/getBankName.html";// 获取支持的银行列表

static  NSString *const AddSavingCardURL  = @"http://hl.hjr.com/Api/GetMoney/addDebitCard.html";// 添加储蓄卡
static  NSString *const AddCreditCardURL  = @"http://hl.hjr.com/Api/GetMoney/addCreditCard.html";//添加信用卡

static NSString *const GetDefaultCardInfo = @"http://hl.hjr.com/Api/GetMoney/getDefaultCardInfo.html";

static  NSString *const UpdateIDCardURL  = @"http://hl.hjr.com/Api/Member/realNameAuth";// 上传身份证信息

static  NSString *const CreditCardURL  = @"http://hl.hjr.com/Api/Recommend/creditCard";// 办卡

static  NSString *const RegisterURL  = @"https://www.hjr.com/Shop/UserInfo/register";// 用户注册

static  NSString *const AddFeedBack  = @"https://www.hjr.com/Shop/UserInfo/addFeedBack";// 用户添加反馈

static  NSString *const GetBannerList  = @"https://www.hjr.com/Shop/Banner/getBannerList";//获取首页banner列表


static  NSString *const GetRedirectUrl  = @"https://www.hjr.com/Shop/Product/getRedirectUrl.html";

static  NSString *const GetApkUpdate  = @"https://www.hjr.com/Shop/UserInfo/getApkUpdate.html";

// 我的
static NSString *const GetMyInfo = @"http://hl.hjr.com/Api/Member/myInfo.html";
// 退出登录
static NSString *const GetSignOut = @"http://hl.hjr.com/Api/Member/logOut.html";

// 借记卡列表
static NSString *const GetDebitCardList = @"http://hl.hjr.com/Api/GetMoney/getDebitCardList.html";


#endif /* RequestURL_h */

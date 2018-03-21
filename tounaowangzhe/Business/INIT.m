//
//  INIT.m
//  ColorfulFund
//
//  Created by Madis on 2016/10/6.
//  Copyright © 2016年 zritc. All rights reserved.
//

#import "INIT.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTCellularData.h>

static INIT *_initConfig;

@interface INIT ()<UIAlertViewDelegate>
{
    NSTimer *_countDownTimer;
    
}
@property (nonatomic,strong) NSMutableDictionary *interfacesDict;
@property (nonatomic,strong) NSMutableDictionary *pushInfoDict;

@property (assign, nonatomic) NSInteger currentSecondsCountDown; //倒计时总时长
/**
 刷新时间(单位:min)
 */
@property (nonatomic,assign) NSInteger sessionRefreshduration;
@property (nonatomic,assign) BOOL cellularDataStatusRestricted;
@property (nonatomic,strong) UIAlertView *cellularDataStatusAlertView;

@property (nonatomic, copy)void (^networkstate)(void );
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, assign)NSInteger times;
@end

@implementation INIT

+ (INIT *)share
{
    //里面的代码永远都只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _initConfig = [[self alloc] init];
        _initConfig.bankInfoDict = [NSMutableDictionary new];
        _initConfig.bankCodeDict = [NSMutableDictionary new];
//        _initConfig.poInfoDict = [NSMutableDictionary new];
        _initConfig.interfacesDict = [NSMutableDictionary new];
        _initConfig.pushInfoDict = [NSMutableDictionary new];
        //占位默认值
        _initConfig.sessionRefreshduration = 55*60;
        //默认为init OK
        _initConfig->_initIsOK = NO;
        _initConfig->_reloadInitIsOK = NO;
        _initConfig.cellularDataStatusRestricted = NO;
        _initConfig.cellularDataStatusAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已禁止当前app的网络访问,请前往设置修改app网络权限" delegate:nil cancelButtonTitle:@"去设置" otherButtonTitles:nil];
        _initConfig.cellularDataStatusAlertView.hidden = YES;
        [_initConfig listenCellularDataStatus];
        [_initConfig listenReachabilityStatusChanged];
        [_initConfig initSignal];
    });
    return _initConfig;
}

- (void)initSignal
{
    @weakify(self);
    // TODO:监听当前网络状态下是否能够ping通服务器地址
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //登录状态改变时也判断是否显示alertView
    [[RACSignal merge:@[RACObserve(self, cellularDataStatusRestricted),
                       RACObserve(manager, networkReachabilityStatus),
                        RACObserve(self, initIsOK)
                       ]] subscribeNext:^(id x) {
        @strongify(self);
        if (self.cellularDataStatusRestricted && AFNetworkReachabilityStatusNotReachable == manager.networkReachabilityStatus) {
            //app网络受限,且网络不可用
            if(!self.cellularDataStatusAlertView.isHidden){
                [self.cellularDataStatusAlertView dismissWithClickedButtonIndex:1 animated:NO];
            }
            self.cellularDataStatusAlertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您已禁止当前app的网络访问,请前往设置修改app网络权限" delegate:self cancelButtonTitle:@"去设置" otherButtonTitles:nil];
            [self.cellularDataStatusAlertView show];
            self.cellularDataStatusAlertView.hidden = NO;
            
//            [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
//                if(buttonIndex == 0){
//                    NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                    [[UIApplication sharedApplication] openURL:appSettings];
//                }
//            } title:@"温馨提示" message:@"您已禁止当前app的网络访问.是否前往设置修改app网络权限" cancelButtonName:@"去设置" otherButtonTitles: nil];
        }else if (self.cellularDataStatusRestricted && AFNetworkReachabilityStatusNotReachable != manager.networkReachabilityStatus){
            //网络受限,但是网络可用.指:app允许wifi访问,且当前网络连接为wifi连接
            if(!self.cellularDataStatusAlertView.isHidden){
                [self.cellularDataStatusAlertView dismissWithClickedButtonIndex:1 animated:NO];

            }
        }else{
            //其他情况下,如果网络连接可用或者网络未受限
            if(!self.cellularDataStatusAlertView.isHidden){
                [self.cellularDataStatusAlertView dismissWithClickedButtonIndex:1 animated:NO];
            }
        }
    }];
    
    //app网络从不可用到可用,且当initIsOK=NO时请求init数据
    [[[[self signal_networkStatusChangedToReachable] filter:^BOOL(id value) {
        @strongify(self);
        return !self.initIsOK;
    }] flattenMap:^RACStream *(id value) {
        @strongify(self);
        return [self signal_initInterfacesDict];
    }] subscribeNext:^(id x) {
        @strongify(self);
        //改变reload状态为YES
        [self willChangeValueForKey:@keypath(self.reloadInitIsOK)];
        self->_reloadInitIsOK = YES;
        [self didChangeValueForKey:@keypath(self.reloadInitIsOK)];
    }];
}

#pragma mark - initJson解析
//接口地址的解析
- (void)parseInitInterfacesFromDict:(NSDictionary *)dict
{
    if(dict){
        NSArray *dictAllKeys = [dict allKeys];
        if(dictAllKeys.count >0){
            for (NSString *key in dictAllKeys) {
                self.interfacesDict[key] = dict[key];
            }
        }
    }
}

- (void)parsePushInfoFromDict:(NSDictionary *)dict
{
    if (dict) {
        NSArray *entranceListArray = dict[@"entranceList"];
        if (entranceListArray && entranceListArray.count >0) {
            for (NSDictionary *entranceDict in entranceListArray) {
                NSString *keyStr = entranceDict[@"name"];
                NSString *valueStr = entranceDict[@"entrance"];
                [self.pushInfoDict setObject:valueStr forKey:keyStr];
            }
        }
    }
}

- (void)parseServInfoFromDict:(NSDictionary *)dict
{
    if(dict){
        NSDictionary *sessionInfoDict = dict[@"session"];
        if (sessionInfoDict) {
            NSString *sessionRefreshduration = sessionInfoDict[@"refreshduration"];
            if (sessionRefreshduration) {
                //单位min
                self.sessionRefreshduration = [sessionRefreshduration integerValue]*60;
            }
        }
    }
}

- (void)parseInitJsonDictionary:(NSDictionary *)responseDict
{
    //resource
    NSDictionary *resourceDict = responseDict[@"resource"];
    NSString *resourceHost = resourceDict[@"host"];
    if(!resourceHost){
        resourceHost = @"";
    }

    //ads,启动广告页
    NSString *adImageString = responseDict[@"img_url"];
    self.interfacesDict[@"adsimage"] = adImageString;
    
    NSString *adisopen = responseDict[@"open"];
    self.interfacesDict[@"isopen"] = adisopen;
    
    NSString *adotherUrl = responseDict[@"redirect_url"];
    self.interfacesDict[@"openUrl"] = adotherUrl;
}

#pragma mark 接口网络请求
- (RACSignal *)signal_initInterfacesDict
{
    NSString *urlStr1 =StartAdURL;
//    INIT_BASE_URL(kAppVersions);
    NSString *urlStr2 = StartAdURL;
    
    @weakify(self);
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        model.parameters = params;
        model.url = urlStr1;
        [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            [subscriber sendNext:response.result];
            [subscriber sendCompleted];
    } Failure:^(HttpRequest *request, HttpResponse *response) {
        [BasePopoverView showFailHUDToWindow:response.errorMsg];
        
    } RequsetStart:^{
        
    } ResponseEnd:^{
        
    }];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        model.parameters = params;
        model.url = urlStr2;
        [[HttpClient sharedInstance]requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            [subscriber sendNext:response.result];
            [subscriber sendCompleted];
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
            
        } RequsetStart:^{
            
        } ResponseEnd:^{
            
        }];
        return nil;
    }];

    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACMulticastConnection *mConnection = [[signal1 catchTo:signal2] publish];
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        self.currentSecondsCountDown = 3;
        [_countDownTimer fire];
        self.networkstate = ^() {
            [subscriber sendNext:@1];
        };

        [[mConnection.signal deliverOnMainThread] subscribeNext:^(NSDictionary* x) {
            //数据解析
            @strongify(self);
            MSLog(@"init文件:%@",x);
            [self parseInitJsonDictionary:x];
            [self willChangeValueForKey:@keypath(self.initIsOK)];
            self->_initIsOK = YES;
            [self didChangeValueForKey:@keypath(self.initIsOK)];
            [subscriber sendNext:x];
         } error:^(NSError *error) {
             [self willChangeValueForKey:@keypath(self.initIsOK)];
             self->_initIsOK = NO;
             [self didChangeValueForKey:@keypath(self.initIsOK)];
             [subscriber sendError:error];
         } completed:^{
             [subscriber sendCompleted];
         }];
        [mConnection connect];
        return nil;
    }];
}

- (void)onTimer {
    if (self.currentSecondsCountDown > 0) {
        self.currentSecondsCountDown--;
    }else {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
        if (self.networkstate) {
            self.networkstate();
        }
    }
    
}


#pragma mark - 通过key值获取接口地址
//通过键值获取接口地址
- (NSString *)interfaceAddressFromKey:(NSString *)keyString
{
    NSString *interfaceString = @"";
    if(self.interfacesDict){
        interfaceString = [self.interfacesDict objectForKey:keyString];
        if (!interfaceString) {
//            NSString *errorString = [NSString stringWithFormat:@"%@对应的键值不存在",keyString];
//            NSAssert(false, errorString);
            interfaceString = @"";
        }
    }
    return interfaceString;
}

- (NSString *)poCodeFromPoInfoDict:(NSString *)keyString
{
    NSString *poCode = @"";
//    if(self.poInfoDict){
//        poCode = [self.poInfoDict objectForKey:keyString];
//        if (!poCode) {
//            NSString *errorString = [NSString stringWithFormat:@"%@对应的键值不存在",keyString];
////            NSAssert(false, errorString);
//            poCode = @"";
//        }
//    }
    return poCode;
}




- (void)listenCellularDataStatus
{
    @weakify(_initConfig);
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    //!! FIXME
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        @strongify(_initConfig);
        //获取联网状态
        [self willChangeValueForKey:@keypath(self.cellularDataStatusRestricted)];
        switch (state) {
            case kCTCellularDataRestricted:{
                //受限制(0/1)
                MSLog(@"Restricrted");
                _initConfig.cellularDataStatusRestricted = YES;
            }
                break;
            case kCTCellularDataNotRestricted:{
                //不受限制(2)
                MSLog(@"Not Restricted");
                _initConfig.cellularDataStatusRestricted = NO;
            }
                break;
            case kCTCellularDataRestrictedStateUnknown:
                MSLog(@"Unknown");
                break;
            default:
                break;
        };
        [self didChangeValueForKey:@keypath(self.cellularDataStatusRestricted)];
    };
}
#pragma mark - 网络监听
//监听网络变化
- (void)listenReachabilityStatusChanged
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*//已连接wifi,但是没有网络
     BOOL networkSwitchOff = NO;
     if(manager.reachable == NO){  //Reachability NotReachable
        NSArray *supportedInterfaces = (__bridge_transfer id)CNCopySupportedInterfaces();
        id info = nil;
        NSString *ssid = nil;
        for (NSString *networkInfo in supportedInterfaces) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)networkInfo);
            if (info && [info count])
                break;
        }
        
        if (info) {
            NSDictionary *dctySSID = (NSDictionary *)info;
            //we can't get ssid if wifi is not connected
            ssid = [dctySSID objectForKey:@"SSID"];
        }
        networkSwitchOff = (ssid!=nil);
    }*/
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
    {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                MSLog(@"未识别的网络");
//                [BasePopoverView showFailHUDToWindow:@"当前网络不可用"];
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                MSLog(@"不可达的网络(未连接)");
                [BasePopoverView showFailHUDToWindow:@"当前网络不可用"];
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                //                MSLog(@"2G,3G,4G...的网络");
                //                [BasePopoverView showFailHUDToWindow:@""];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //                MSLog(@"wifi的网络");
                //                [BasePopoverView showFailHUDToWindow:@""];
                break;
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
}
//监听网络状态从不可用变为可用
- (RACSignal *)signal_networkStatusChangedToReachable
{
    RACSubject *subject_reachable = [RACSubject new];
    RACSubject *subject_notReachable = [RACSubject new];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [RACObserve(manager, reachable) subscribeNext:^(NSNumber* x) {
        if([x boolValue]){
            //网络可用
            [subject_reachable sendNext:@"a"];
        }else{
            //网络不可用
            [subject_notReachable sendNext:@1];
        }
    }];
    //网络从不可用到可用
    RACSignal *signal_netWorkStatusChanged = [subject_notReachable flattenMap:^RACStream *(id value) {
        return [subject_reachable take:1];
    }];
    return signal_netWorkStatusChanged;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

@end

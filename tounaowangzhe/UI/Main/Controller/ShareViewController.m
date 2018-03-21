//
//  ShareViewController.m
//  tounaowangzhe
//
//  Created by Sj03 on 2018/1/19.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "ShareViewController.h"
#import "XWPresentOneTransition.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ShareViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        //为什么要设置为Custom，在最后说明.
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    //这里我们初始化presentType
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypePresent];
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    //这里我们初始化dismissType
    return [XWPresentOneTransition transitionWithTransitionType:XWPresentOneTransitionTypeDismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)shareToWeixin:(id)sender {
    NSArray* imageArray = @[[UIImage imageNamed:@"微信"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"分享成功"];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"分享失败"];
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"取消分享"];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (IBAction)shareToFirends:(id)sender {
    NSArray* imageArray = @[[UIImage imageNamed:@"微信"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"分享成功"];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"分享失败"];
                    break;
                }
                case SSDKResponseStateCancel:
                {
                    [BasePopoverView showSuccessHUDToWindow:@"取消分享"];
                    break;
                }
                default:
                    break;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

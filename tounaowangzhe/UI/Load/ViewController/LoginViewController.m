//
//  LoginViewController.m
//  huanle
//
//  Created by Sj03 on 2018/1/15.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, strong)void (^complete)(NSInteger tag);
@end

@implementation LoginViewController

- (instancetype)initWithComplete:(void(^)(NSInteger tag))completeBlock {
    self = [super init];
    if (self) {
        self.complete = completeBlock;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginButtonAction:(id)sender {
    [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat]; //这儿就是取消授权
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
         if (state == SSDKResponseStateSuccess) {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             
             if (self.complete) {
                 self.complete(1);
             }
         } else {
             NSLog(@"%@",error);
         }
     }];
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

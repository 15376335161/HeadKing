//
//  YMWebViewController.m
//  CloudPush
//
//  Created by YouMeng on 2017/3/7.
//  Copyright © 2017年 YouMeng. All rights reserved.
//

#import "YMWebViewController.h"
#import <WebKit/WebKit.h>

@interface YMWebViewController ()<WKUIDelegate,UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)MBProgressHUD* hub;
@end

@implementation YMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载界面
    self.webView.delegate = self;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit = YES;
    [RACObserve(self, urlStr) subscribeNext:^(id x) {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.urlStr]];
        NSLog(@"urls ==- %@",self.urlStr);
        [self.webView loadRequest:request];
    }];
}

// navBar 回调
- (void)navBarButtonAction:(UIButton *)sender {
    if (self.complete) {
        self.complete();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)dealloc {
    self.webView = nil;
    NSLog(@"i am dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
     NSLog(@"开始加载数据 request == %@",request);

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
     self.hub = [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
     [self.hub removeFromSuperview];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
      [self.hub removeFromSuperview];
    
}

@end

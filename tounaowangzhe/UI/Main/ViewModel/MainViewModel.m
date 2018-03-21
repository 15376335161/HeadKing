//
//  MainViewModel.m
//  tounao
//
//  Created by Sj03 on 2018/1/18.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "MainViewModel.h"

@implementation MainViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
//        _matchState = MatchStateNY;
        _matchLabelString = @"";
        _subject_getDate = [[RACSubject alloc] init];
        _matchState = (arc4random() % 4);
        _matchLabelString = @"01:33:34 报名成功。进入等待";
        _matchSessionString = @"下期50人场";
        _matchTimeString = @"今日13：00";
        _matchIQmoneyString = @"500IQ币";
        _matchPersonNumString = @"0人已参与";
        [self initSigin];
    }
    return self;
}
- (void)initSigin {
    [self.subject_getDate subscribeNext:^(id x) {
        // 模拟请求
        HttpRequestMode* model = [[HttpRequestMode alloc]init];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        model.parameters = params;
        model.url = StartAdURL;
        [BasePopoverView showHUDAddedTo:kUIWindow animated:YES withMessage:@"加载中..."];
        [[HttpClient sharedInstance] requestApiWithHttpRequestMode:model Success:^(HttpRequest *request, HttpResponse *response) {
            
            [BasePopoverView hideHUDForView:kUIWindow animated:YES];
            switch (self.matchState) {
                case MatchStateNN:
                    self.matchLabelString = @"01:33:34  立即参加";
                    break;
                case MatchStateNY:
                    self.matchLabelString = @"01:33:34  报名成功，进入等待";
                    break;
                case MatchStateYN:
                    self.matchLabelString = @"观看比赛";
                    break;
                case MatchStateYY:
                    self.matchLabelString = @"进入比赛";
                    break;
                case MatchStateUK:
                    self.matchLabelString = @"";
                default:
                    break;
            }
            if (self.reloadData) {
                self.reloadData();
            }
            
        } Failure:^(HttpRequest *request, HttpResponse *response) {
            [BasePopoverView showFailHUDToWindow:response.errorMsg];
            
        } RequsetStart:^{
            
        } ResponseEnd:^{
            
        }];
    }];

}
@end

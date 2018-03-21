//
//  MainViewController.m
//  huanle
//
//  Created by Sj03 on 2018/1/15.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "MainViewController.h"
#import "HRAdView.h"
#import "AnswerQuestionViewController.h"
#import "AnswerQuestionViewModel.h"
#import "layoutStateView.h"
#import "MainViewModel.h"

#import "ShoppingViewController.h"
#import "BuyMatchTicketViewController.h"
#import "SearchRankListViewController.h"
#import "ShareViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBoardViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *labels;
@property (weak, nonatomic) IBOutlet UIButton *getMoreButton;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet layoutStateView *layoutStateView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutStateViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *informationView;
@property (nonatomic, strong) HRAdView *adView;
@property (weak, nonatomic) IBOutlet UIImageView *waitingImage;
@property (weak, nonatomic) IBOutlet UIImageView *siginoutImage;
@property (weak, nonatomic) IBOutlet UILabel *searchListLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputCodeLabel;


@property (weak, nonatomic) IBOutlet UILabel *matchSessionLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchIQmoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchPersonNumLabel;



@property(nonatomic,strong)NSMutableArray* titlsArr;
@property (weak, nonatomic) IBOutlet UIView *matchView;

@property (weak, nonatomic) IBOutlet UIButton *pushButton;
@property (weak, nonatomic) IBOutlet UILabel *pushLabel;

@property (nonatomic, strong)MainViewModel *viewModel;
@end

@implementation MainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.pushButton.hidden = [ToolUtil isOpenPush];
    self.pushLabel.hidden = [ToolUtil isOpenPush];
    self.viewModel = [[MainViewModel alloc] init];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        if (kDevice_Is_iPhoneX) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    // Do any additional setup after loading the view from its nib.
}
- (void)loadUIData {
    self.waitingImage.hidden = YES;
    
    self.siginoutImage.userInteractionEnabled = YES;
    self.searchListLabel.userInteractionEnabled = YES;
    self.inputCodeLabel.userInteractionEnabled = YES;
    
    [UIUtil viewLayerWithView:self.getMoreButton cornerRadius:15 boredColor:RGBA(67,47,117,0.5) borderWidth:1];
    [UIUtil viewLayerWithView:self.boardView cornerRadius:8 boredColor:[UIColor clearColor] borderWidth:1];
    
    self.layoutStateView.changeState = ^(CGFloat width) {
        self.layoutStateViewWidthConstraint.constant = width;
    };

    
    self.informationView.layer.cornerRadius = 8;
    self.informationView.layer.masksToBounds = YES;
    
    self.adView = [[HRAdView alloc]initWithTitles:self.titlsArr];
    [self.adView setFrame:CGRectMake(0, 0, self.informationView.frame.size.width, self.informationView.frame.size.height)];
    _adView.textAlignment = NSTextAlignmentLeft;//默认
    _adView.isHaveHeadImg = NO;
    _adView.headImg = IMAGE_NAME(@"广播");
    _adView.isHaveTouchEvent = YES;
    _adView.labelFont = [UIFont boldSystemFontOfSize:12];
    _adView.color = RGB(67,47,117);
    _adView.time  = 5.0f;
    _adView.clickAdBlock = ^(NSUInteger index){
    };
    
    //开始滚动
    [self.adView beginScroll];
    [self.informationView addSubview:self.adView];
    
    if (iPhone6Plus) {
        self.topBoardViewConstraint.constant = self.topBoardViewConstraint.constant + 60;
    } else if(kDevice_Is_iPhoneX) {
        self.topBoardViewConstraint.constant = self.topBoardViewConstraint.constant + 130;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    @weakify(self);
    [self.viewModel.subject_getDate sendNext:@YES];

    self.viewModel.reloadData = ^{
        @strongify(self);
        self.layoutStateView.stateLabel.text = self.viewModel.matchLabelString;
        self.matchSessionLabel.text = self.viewModel.matchSessionString;
        self.matchTimeLabel.text = self.viewModel.matchTimeString;
        self.matchIQmoneyLabel.text= self.viewModel.matchIQmoneyString;
        self.matchPersonNumLabel.text = self.viewModel.matchPersonNumString;
        if (self.viewModel.matchState == MatchStateUK) {
            self.layoutStateView.hidden = YES;
            self.waitingImage.hidden = NO;
            self.matchView.hidden = YES;
        } else {
            self.layoutStateView.hidden = NO;
            self.waitingImage.hidden = YES;
            self.matchView.hidden = NO;
        }
    };
}

- (IBAction)startAnswerQuestion:(id)sender {

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)titlsArr{
    if (!_titlsArr) {
        _titlsArr = @[[NSString stringWithFormat:@"%d分钟前 陈** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 张** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 李** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 赵** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 孙** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 王** 成功还款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 杜** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 吴** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 周** 成功还款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 刘** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 吕** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 郝** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 肖** 成功还款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 刁** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 岳** 成功借款1000元",arc4random() % 60],
                      [NSString stringWithFormat:@"%d分钟前 钱** 成功借款1000元",arc4random() % 60]].mutableCopy;
    }
    
    return _titlsArr;
}

#pragma -mark 事件
 // 购物
- (IBAction)ShoppingAction:(id)sender {
    ShoppingViewController *sVC = [[ShoppingViewController alloc] init];
    
    [self.navigationController pushViewController:sVC animated:YES];
}
// 购买入场券
- (IBAction)BuyMatchTick:(id)sender {
    BuyMatchTicketViewController *bVC = [[BuyMatchTicketViewController alloc] init];
    [self.navigationController pushViewController:bVC animated:YES];
}
// 查看排行榜
- (IBAction)SearchList:(id)sender {
    SearchRankListViewController *srVC = [[SearchRankListViewController alloc] init];
    [self.navigationController pushViewController:srVC animated:YES];
}

// 输入邀请码
- (IBAction)InputCode:(id)sender {
    
}
// 进入比赛
- (IBAction)AccessToMatchAction:(id)sender {
    AnswerQuestionViewController *aqVC = [[AnswerQuestionViewController alloc] initWithModel:[[AnswerQuestionViewModel alloc] init]];
    [self.navigationController pushViewController:aqVC animated:YES];
}
// 退出登录
- (IBAction)SiginOutAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"注销账号" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [[BackgroundViewController share] showLoginViewController:loginVC animated:NO completion:^{
        }];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:archiveAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 开战提醒
- (IBAction)RemindMeAction:(id)sender {
    
}
// 规则说明
- (IBAction)RuleDescriptionAction:(id)sender {
    NSLog(@"规则说明");
}
// 获得更多复活卡
- (IBAction)GetMoreAction:(id)sender {
        NSLog(@"更多复活卡");
    ShareViewController *shVC = [[ShareViewController alloc] init];
    [self.navigationController presentViewController:shVC animated:YES completion:^{
        
    }];
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

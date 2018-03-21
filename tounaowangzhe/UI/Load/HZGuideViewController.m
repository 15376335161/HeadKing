//
//  HZGuideViewController.m
//  ColorfulFund
//
//  Created by Madis on 2017/4/6.
//  Copyright © 2017年 zritc. All rights reserved.
//

#import "HZGuideViewController.h"

@interface HZGuideViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *welcomeScrollview;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *imageNameArray;
@end

@implementation HZGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化引导页
    //图片资源从本地获取
    NSArray *imageNameArray = @[@"闪屏_1",@"闪屏_2",@"闪屏_3",@"闪屏_4"];
    self.imageNameArray = imageNameArray;
    for (NSString *imageName in imageNameArray) {
        NSInteger index = [imageNameArray indexOfObject:imageName];
        CGRect rect = CGRectMake(kScreenWidth*index, 0,kScreenWidth,kScreenHeight);
        UIImageView *imageView= [UIUtil createImageView:rect image:[UIImage imageNamed:imageName]];
        [self.welcomeScrollview addSubview:imageView];
    };
    self.welcomeScrollview.contentSize = CGSizeMake(kScreenWidth *imageNameArray.count, kScreenHeight);
    self.pageControl.numberOfPages = imageNameArray.count;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat currentX = scrollView.contentOffset.x;
    self.pageControl.currentPage = currentX/kScreenWidth;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat currentX = scrollView.contentOffset.x;
    if(currentX > (self.imageNameArray.count -1)*kScreenWidth){
        [self guideViewFinished];
    }
}
// 点击pageControl
- (IBAction)pageControlClicked:(UIPageControl *)sender {
    [self.welcomeScrollview setContentOffset:CGPointMake(kScreenWidth*sender.currentPage, 0) animated:YES];
}

// 点击跳过按钮
- (IBAction)skipButtonClicked:(id)sender {
    [self guideViewFinished];
}

- (void)guideViewFinished{
    //存储新Version
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [UserDefaultsTool setString:currentVersion withKey:@"AppVersion"];
    if(self.block_guideViewFinished){
        self.block_guideViewFinished();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

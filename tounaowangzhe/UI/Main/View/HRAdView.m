//
//  HRAdView.m
//  AutoAdLabelScroll
//
//  Created by 陈华荣 on 16/4/6.
//  Copyright © 2016年 陈华荣. All rights reserved.
//

#import "HRAdView.h"



#define ViewWidth   self.bounds.size.width
#define ViewHeight  self.bounds.size.height

@interface HRAdView ()
/**
 *  文字广告条前面的图标
 */
@property (nonatomic, strong) UIImageView *headImageView;
/**
 *  图片位置
 */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
/**
 *  轮流显示的两个Label
 */
@property (nonatomic, strong) UILabel *oneLabel;
@property (nonatomic, strong) UILabel *twoLabel;

//显示时间
@property(nonatomic,strong)UILabel * oneTimeLabel;

@property(nonatomic,strong)UIView* oneView;
@property(nonatomic,strong)UIView* secondView;

@property(nonatomic,strong)UIImageView* backgroudImgV;
/**
 *  计时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HRAdView
{
    NSUInteger index;
    CGFloat margin;
    BOOL isBegin;
}

-(instancetype)initWithFrame:(CGRect)frame adsArr:(NSArray* )adsArr headImgStr:(NSString* )headImgStr backgroundImgStr:(NSString* )backgroundImgStr{
    if (self = [super initWithFrame:frame]) {
        //背景图
        _backgroudImgV = [[UIImageView alloc]initWithFrame:frame];
        _backgroudImgV.image = [UIImage imageNamed:backgroundImgStr];
        [self addSubview:_backgroudImgV];
        
        //头部的广告图
        UIImageView* headImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 20, 20)];
        headImg.image = [UIImage imageNamed:headImgStr];
        [self addSubview:headImg];
        
     
        
        //第一个广告
        CGFloat magin  = 10;
        CGFloat y      = 3;
        CGFloat x      = CGRectGetMaxX(headImg.frame) + magin;
        CGFloat width  = frame.size.width - x ;
        CGFloat height = 16;
        UILabel* topLabel = [[UILabel alloc]initWithFrame:CGRectMake( x, y,width,height)];
        topLabel.font = [UIFont systemFontOfSize:14];
        topLabel.textAlignment = NSTextAlignmentLeft;
        topLabel.textColor = [UIColor blackColor];
        [self addSubview:topLabel];
        
        //第二个广告
        y = CGRectGetMaxY(topLabel.frame ) + 5;
        height = 13;
        UILabel* bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake( x, y,width,height)];
        bottomLabel.font = [UIFont systemFontOfSize:12];
        bottomLabel.textAlignment = NSTextAlignmentLeft;
        bottomLabel.textColor = [UIColor blackColor];
        [self addSubview:bottomLabel];
        
    }
    return self;
}


- (instancetype)initWithTitles:(NSArray *)titles{
    self = [super init];
    if (self) {
        //添加背景
        _backgroudImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _backgroudImgV.image = [UIImage imageNamed:@"播报底"];
        [self addSubview:_backgroudImgV];
        [self sendSubviewToBack:_backgroudImgV];
        
        
        margin = 0;
        self.clipsToBounds = YES;
        self.adTitles = titles;
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:16];
        self.color = [UIColor blackColor];
        self.time = 2.0f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveHeadImg = NO;
        self.isHaveTouchEvent = NO;
        
      //  self.backgroundColor = [UIColor greenColor];
        index = 0;
        
        if (!_headImageView) {
            _headImageView = [UIImageView new];
        }
        
        if (!_oneLabel) {
            _oneLabel = [UILabel new];
            if (self.adTitles.count) {
                 _oneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
            }
            _oneLabel.font = self.labelFont;
            _oneLabel.textAlignment = self.textAlignment;
            _oneLabel.textColor = self.color;
            _oneLabel.numberOfLines = 0;
            _oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            _oneLabel.backgroundColor = [UIColor greenColor];
            [self addSubview:_oneLabel];
            
            
        }
        
        if (!_twoLabel) {
            _twoLabel = [UILabel new];
            _twoLabel.font = self.labelFont;
            _twoLabel.textColor = self.color;
            _twoLabel.textAlignment = self.textAlignment;
            _twoLabel.numberOfLines = 0;
            _twoLabel.lineBreakMode = NSLineBreakByWordWrapping;
//             _twoLabel.backgroundColor = [UIColor blueColor];
            [self addSubview:_twoLabel];
        }
        
//        if (!_oneTimeLabel) {
//            _oneTimeLabel = [UILabel new];
//            _oneTimeLabel.font = self.labelFont;
//            _oneTimeLabel.textColor = self.color;
//            _oneTimeLabel.textAlignment = self.textAlignment;
//            _oneTimeLabel.numberOfLines = 0;
//            _oneTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            _oneTimeLabel.text = [NSString stringWithFormat:@"%d分钟前",arc4random()%60];
//            //                _oneTimeLabel.backgroundColor = [UIColor blueColor];
//            //时间
//            _oneTimeLabel.frame = CGRectMake(ViewWidth - 60 - 15, 0, 60, ViewHeight);
//            [self addSubview:_oneTimeLabel];
//
//        }
       
    }
    return self;
}


-(void)setAdTitles:(NSArray *)adTitles{
      _adTitles = adTitles;
    
//      index = 0;
      if (adTitles.count > index) {
         _oneLabel.text = [NSString stringWithFormat:@"%@",adTitles[index]];
//         _oneTimeLabel.text = [NSString stringWithFormat:@"%d分钟前",arc4random()%60];
      }
}
- (void)timeRepeat{
    if (self.adTitles.count <= 1) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    __block UILabel *currentLabel;
    __block UILabel *hidenLabel;
    __weak typeof(self) weakself = self;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *label = obj;
            NSString * string = weakself.adTitles[index];
            if ([label.text isEqualToString:string]) {
                currentLabel = label;
            }else{
                hidenLabel = label;
            }
        }
    }];

    //取随机数
    NSInteger indexs = index;
    
    index = [self getarc];
    if (index == indexs) {
        if (index != self.adTitles.count-1) {
            index++;
        }else{
            index = 0;
        }
    }
    
   // DDLog(@"edgeInsets.left == %f",_edgeInsets.left);
    hidenLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
    [UIView animateWithDuration:0.5 animations:^{
        hidenLabel.frame = CGRectMake(margin, 0, ViewWidth - margin, ViewHeight);
        
        currentLabel.frame = CGRectMake(margin, -ViewHeight,  ViewWidth - margin , ViewHeight);
       
        
    } completion:^(BOOL finished){
        currentLabel.frame = CGRectMake(margin, ViewHeight,  ViewWidth - margin , ViewHeight);
    }];

    
    
//    if (self.adTitles.count == 0) {
//        return;
//    }
//    if (index != self.adTitles.count-1) {
//        index++;
//    }else{
//        index = 0;
//    }
//    
//    if (index == 0) {
//        
//        self.oneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
//        
//    } else {
//        switch (index%2) {
//            case 0:
//            {
//                self.oneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
//            }
//                break;
//                
//            default:
//            {
//                self.twoLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
//                
//            }
//                break;
//        }
//    }
//    
//    if (index%2 == 0) {
//        [UIView animateWithDuration:1 animations:^{
//            self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
//            self.twoLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
//        } completion:^(BOOL finished){
//            self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
//        }];
//    }else{
//        [UIView animateWithDuration:1 animations:^{
//            self.twoLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
//            self.oneLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
//        } completion:^(BOOL finished){
//            self.oneLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
//        }];
//    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _backgroudImgV.frame = CGRectMake(0, 0, ViewWidth - 5, ViewHeight);
    
    if (self.headImg) {
        [self addSubview:self.headImageView];
        
        self.headImageView.frame = CGRectMake(15,(32-16)/2, 16, 16);
//        CGRectMake(self.edgeInsets.left, self.edgeInsets.top, 20, 20);
//        ViewHeight-self.edgeInsets.top-self.edgeInsets.bottom,ViewHeight-self.edgeInsets.top-self.edgeInsets.bottom
        margin = CGRectGetMaxX(self.headImageView.frame) +10;
    }else{
        
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 10;
    }
    
    self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
    self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
    
    
//    if (self.isHaveHeadImg) {
//        [self addSubview:self.headImageView];
//        self.headImageView.frame = CGRectMake(0, 0, ViewHeight,ViewHeight);
//        margin = ViewHeight +10;
//    }else{
//        if (self.headImageView) {
//            [self.headImageView removeFromSuperview];
//            self.headImageView = nil;
//        }
//        margin = 0;
//    }
//    self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
//    self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
}


- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}


- (void)beginScroll{
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self timeRepeat];
}

- (void)closeScroll{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setIsHaveHeadImg:(BOOL)isHaveHeadImg{
    _isHaveHeadImg = isHaveHeadImg;
}

- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent{
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }else{
        self.userInteractionEnabled = NO;
    }
}

- (void)setTime:(NSTimeInterval)time{
    _time = time;
    if (self.timer.isValid) {
        [self.timer isValid];
        self.timer = nil;
    }
}


- (void)setHeadImg:(UIImage *)headImg{
    _headImg = headImg;
    
    self.headImageView.image = headImg;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    
    self.oneLabel.textAlignment = _textAlignment;
    self.twoLabel.textAlignment = _textAlignment;
}

- (void)setColor:(UIColor *)color{
    _color = color;
    self.oneLabel.textColor = _color;
    self.twoLabel.textColor = _color;
}

- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.oneLabel.font = _labelFont;
    self.twoLabel.font = _labelFont;
}


- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer{
    
    [self.adTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (index % 2 == 0 && [self.oneLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }else if(index % 2 != 0 && [self.twoLabel.text isEqualToString:obj]){
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
    }];
    
}

-(NSInteger )getarc {
    
    NSInteger index = arc4random() % self.adTitles.count;
    return index;
}


@end

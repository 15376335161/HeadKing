//
//  layoutStateView.m
//  tounao
//
//  Created by Sj03 on 2018/1/17.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import "layoutStateView.h"
@interface layoutStateView ()
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation layoutStateView

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([layoutStateView class]) owner:self options:nil];
    [self addSubview:self.view];
    self.view.frame = self.bounds;
    [RACObserve(self.stateLabel, text) subscribeNext:^(id x) {
        CGFloat w =   [self.stateLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:17.0f] constrainedToSize:CGSizeMake(kScreenWidth-30, 300) lineBreakMode:NSLineBreakByWordWrapping].width + 60;
        if (self.changeState) {
            self.changeState(w);
        }
        self.layer.cornerRadius = 22;
        self.layer.masksToBounds = YES;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

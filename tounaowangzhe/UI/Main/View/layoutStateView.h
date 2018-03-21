//
//  layoutStateView.h
//  tounao
//
//  Created by Sj03 on 2018/1/17.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface layoutStateView : UIView

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, copy)void (^changeState)(CGFloat width);

@end

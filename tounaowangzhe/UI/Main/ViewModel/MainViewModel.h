//
//  MainViewModel.h
//  tounao
//
//  Created by Sj03 on 2018/1/18.
//  Copyright © 2018年 Sj03. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    MatchStateNN, // 为开赛，未报名
    MatchStateNY, // 为开赛，以报名
    MatchStateYN,
    MatchStateYY,
    MatchStateUK //  未知比赛
} MatchState;

@interface MainViewModel : NSObject

@property (nonatomic, assign)MatchState matchState;
@property (nonatomic, strong)NSString *matchLabelString;
@property (nonatomic, strong)NSString *matchSessionString;
@property (nonatomic, strong)NSString *matchTimeString;
@property (nonatomic, strong)NSString *matchIQmoneyString;
@property (nonatomic, strong)NSString *matchPersonNumString;
@property (nonatomic, strong)RACSubject *subject_getDate;

@property (nonatomic, copy)void (^reloadData)(void);

@end

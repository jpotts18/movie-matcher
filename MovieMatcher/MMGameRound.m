//
//  MMGameRound.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/12/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGameRound.h"

@implementation MMGameRound

- (NSInteger) accuracy {
    NSInteger total = self.numberCorrect + self.numberInorrect;
    return self.numberCorrect / total;
}

@end

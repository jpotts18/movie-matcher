//
//  MMGame.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGame.h"

#define INCORRECT_GUESS_PENALTY = 100
#define MILLIS_PER_GUESS = 10000

@interface MMGame()

@end


@implementation MMGame

- (id) init {
    self = [super init];
    
    if(self){
        _totalScore = 0;
        _numCorrect = 0;
        _numIncorrect = 0;
        _created = [[NSDate alloc] init];
        _username = @"";
        // roundTimer
        // gameTimer
        _movies = [[NSMutableArray alloc] init];
        _tempMovies = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)sharedInstance {
    static MMGame *sharedGame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGame = [[self alloc] init];
    });
    return sharedGame;
}




@end

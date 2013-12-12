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
    
    if(self = [super init]){
        _totalScore = 0;
        _numCorrect = 0;
        _numIncorrect = 0;
        _created = [[NSDate alloc] init];
        _username = @"";
        // roundTimer
        // gameTimer
        _boxOfficeMovieData = [[NSMutableArray alloc] init];
        _gameMovies = [[NSMutableArray alloc] init];
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

- (void) initializeNewGame {

    [self generateRandomGameMovies];
    
}

- (void) generateRandomGameMovies {

    self.gameMovies = [self.boxOfficeMovieData mutableCopy];
    
    for (NSUInteger i = 0; i < [self.gameMovies count]; i++) {
        NSUInteger randomNumber = arc4random() % [self.gameMovies count];
        NSLog(@"Index -> %ld random number -> %ld", (long)i, (long)randomNumber);
        [self.gameMovies exchangeObjectAtIndex:i withObjectAtIndex:randomNumber];
    }
    
}


@end

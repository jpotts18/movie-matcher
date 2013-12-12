//
//  MMGame.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGame.h"
#import "MMMovie.h"

#define INCORRECT_GUESS_PENALTY = 100
#define MILLIS_PER_GUESS = 10000

@interface MMGame()

@end


@implementation MMGame

- (id) init {
    
    if(self = [super init]){
        _created = [[NSDate alloc] init];
        _username = @"";
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

    self.gameMovies = [self.boxOfficeMovieData mutableCopy];
    
    for (NSUInteger i = 0; i < [self.gameMovies count]; i++) {
        NSUInteger randomNumber = arc4random() % [self.gameMovies count];
        NSLog(@"Index -> %ld random number -> %ld", (long)i, (long)randomNumber);
        [self.gameMovies exchangeObjectAtIndex:i withObjectAtIndex:randomNumber];
    }
    
}

- (NSMutableArray *) randomMovieAnswersBy:(MMMovie *)currentMovie {

    NSMutableArray *randomMovies = [[NSMutableArray alloc] init];
    NSUInteger countOfRandomMovies = 0;
    
    
    // add the current movie into the randomMovies array
    [randomMovies addObject:currentMovie];
    countOfRandomMovies++;
    
    do {
        
        NSUInteger randomNumber = arc4random() % [self.gameMovies count];
        MMMovie *randomMovie = [self.gameMovies objectAtIndex:randomNumber];
        
        BOOL isUnique = YES;
        
        // loop through and make sure it is not a duplicate
        for (MMMovie *movie in randomMovies) {
            if(movie.movieId == randomMovie.movieId){
                isUnique = NO;
            }
        }
        
        if (isUnique) {
            countOfRandomMovies++;
            [randomMovies addObject:randomMovie];
        }

        
    } while (countOfRandomMovies < 4);
    
    
    // Do the shuffle!
    
    for (NSUInteger i = 0; i < [randomMovies count]; i++) {
        NSUInteger randomNumber = arc4random() % [randomMovies count];
        NSLog(@"Index -> %ld random number -> %ld", (long)i, (long)randomNumber);
        [randomMovies exchangeObjectAtIndex:i withObjectAtIndex:randomNumber];
    }
    
    return randomMovies;
    
}


@end

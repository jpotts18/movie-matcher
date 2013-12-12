//
//  MMGame.h
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMovie.h"

@interface MMGame : NSObject

@property (nonatomic) NSUInteger difficulty;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSMutableArray *boxOfficeMovieData;
@property (strong, nonatomic) NSMutableArray *gameMovies;

+ (id)sharedInstance;

- (void) initializeNewGame;
- (NSMutableArray *) randomMovieAnswersBy:(MMMovie *)currentMovie;


@end

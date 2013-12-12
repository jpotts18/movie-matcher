//
//  MMGame.h
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMGame : NSObject

@property (nonatomic) NSUInteger totalScore;
@property (nonatomic) NSUInteger difficulty;
@property (nonatomic) NSUInteger numCorrect;
@property (nonatomic) NSUInteger numIncorrect;
@property (strong, nonatomic) NSDate *created;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSTimer *roundTimer;
@property (strong, nonatomic) NSTimer *gameTimer;
@property (strong, nonatomic) NSMutableArray *movies;
@property (strong, nonatomic) NSMutableArray *tempMovies;

+ (id)sharedInstance;

@end

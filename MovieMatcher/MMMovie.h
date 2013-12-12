//
//  MMMovie.h
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MMMovie : NSObject

@property (nonatomic) NSUInteger movieId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableArray *images;

@end

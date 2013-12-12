//
//  MMNetworking.h
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MMLoadModelDelegate <NSObject>
@required
- (void) loadingCompleted;
@end

@interface MMLoader : NSObject

@property (weak, nonatomic) id <MMLoadModelDelegate> delegate;

- (void) loadModel;

@end
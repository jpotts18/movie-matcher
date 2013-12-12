//
//  MMNetworking.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMLoader.h"
#import <AFNetworking/AFNetworking.h>
#import "MMMovie.h"
#import "MMGame.h"

#define API_BASE @"http://api.rottentomatoes.com/api/public/v1.0"
#define API_KEY @"af46uut8ma9y77atkyzxbwnp"
#define BOX_OFFICE_PATH @"/lists/movies/box_office.json"
#define MOVIE_PATH @"http://api.rottentomatoes.com/api/public/v1.0/movies/"
#define COUNTRY @"us"
#define BOX_OFFICE_LIMIT 5

@interface MMLoader()

@property (nonatomic, strong) MMGame *gameInstance;
@property (nonatomic, strong) AFHTTPRequestOperationManager *sharedManager;

@end

@implementation MMLoader

- (void) loadModel{
    
    self.gameInstance = [MMGame sharedInstance];
    self.sharedManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{@"limit": @BOX_OFFICE_LIMIT, @"country": COUNTRY, @"apikey": API_KEY};
   
    [self.sharedManager GET:[NSString stringWithFormat:@"%@%@", API_BASE, BOX_OFFICE_PATH] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *movies = responseObject[@"movies"];
        
        for (NSDictionary *movie in movies) {
            MMMovie *m = [[MMMovie alloc] init];
            m.movieId = [[movie valueForKey:@"id"] integerValue];
            m.title = movie[@"title"];
            [self.gameInstance.boxOfficeMovieData addObject:m];
        }
        
        [self getMovieImages];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error accessing API: %@", error);
    }];

}

- (void) getMovieImages{
    
    NSDictionary *clipParams = @{@"apikey": API_KEY};
    __block NSInteger moviesDownloaded = 0;
    
    for (MMMovie *movie in self.gameInstance.boxOfficeMovieData){
        // GET images for each movie
        NSString *clipsUrl = [NSString stringWithFormat:@"%@%lul%@",
                              MOVIE_PATH,
                              (unsigned long) movie.movieId,
                              @"/clips.json"];
        
        [self.sharedManager GET:clipsUrl parameters:clipParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSMutableDictionary *clips = responseObject[@"clips"];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            
            for (NSDictionary *clip in clips) {
                NSString *clipUrl = clip[@"thumbnail"];
                if([clipUrl length] > 0){
                    [images addObject:clipUrl];
                }
            }
            
            movie.images = images;
            
            [self.gameInstance.boxOfficeMovieData addObject:movie];
            
            moviesDownloaded++;
            
            if(moviesDownloaded == BOX_OFFICE_LIMIT){
                
                NSLog(@"video %d of %d", (int)moviesDownloaded, BOX_OFFICE_LIMIT);
                
                if([self.delegate respondsToSelector:@selector(loadingCompleted)]){
                 [self.delegate loadingCompleted];
                }
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to download images");
        }];
    }
    
}


@end

//
//  MMNetworking.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "MMMovie.h"
#import "MMGame.h"


@interface MMNetworking()

@property (nonatomic) NSUInteger moviesDownloaded;
@property (nonatomic) NSUInteger *boxOfficeLimit;
@property (nonatomic, strong) MMGame *gameInstance;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *baseApi;
@property (nonatomic, strong) NSString *boxOfficePath;
@property (nonatomic, strong) NSString *moviePath;
@property (nonatomic, strong) NSString *country;



@end

@implementation MMNetworking

-(id) init{

    self = [super init];
    
    _gameInstance = [MMGame sharedInstance];
    
    if(!self){
        _moviesDownloaded = 0;
        _baseApi = @"http://api.rottentomatoes.com/api/public/v1.0";
        _boxOfficePath = @"/lists/movies/box_office.json";
        _apiKey = @"af46uut8ma9y77atkyzxbwnp";
        _country = @"us";
        _boxOfficeLimit = 5;
    }
    
    return self;
    
}

- (void) getBoxOfficeMovies{
    
    NSDictionary *params = @{@"limit": @5, @"country" :self.country, @"apikey": self.apiKey};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // GET BOX OFFICE MOVIES
    [manager GET:[NSString stringWithFormat:@"%@%@",self.baseApi, self.boxOfficePath] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *movies = responseObject[@"movies"];
        for (NSDictionary *movie in movies) {
            MMMovie *m = [[MMMovie alloc] init];
            m.movieId = [[movie valueForKey:@"id"] integerValue];
            m.title = movie[@"title"];
            [self.gameInstance.movies addObject:m];
        }
        
        [self getMovieImages];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // failure logic
        NSLog(@"Error: %@", error);
    }];

}

- (void) getMovieImages{
    
}

- (NSMutableArray *) loadModel{
    
    [self getBoxOfficeMovies];
    
    NSDictionary *params = @{@"limit": @5, @"country" :self.country, @"apikey": self.apiKey};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // GET BOX OFFICE MOVIES
    [manager GET:[NSString stringWithFormat:@"%@%@",self.baseApi, self.boxOfficePath] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        MMGame *gameInstance = [MMGame sharedInstance];
        
        NSMutableArray *gameMovies;
        
        for (NSDictionary *movie in movies) {
            MMMovie *m = [[MMMovie alloc] init];
            m.movieId = [[movie valueForKey:@"id"] integerValue];
            m.title = movie[@"title"];
            
            // GET images for each movie
            NSString *clipsUrl = [NSString stringWithFormat:@"%@%lul%@",
                                  @"http://api.rottentomatoes.com/api/public/v1.0/movies/",
                                  (unsigned long)m.movieId,
                                  @"/clips.json"];
            
            NSDictionary *clipParams = @{@"apikey": self.apiKey};
            
            [manager GET:clipsUrl parameters:clipParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSMutableDictionary *clips = responseObject[@"clips"];
                NSMutableArray *images = [[NSMutableArray alloc] init];
                
                for (NSDictionary *clip in clips) {
                    NSString *clipUrl = clip[@"thumbnail"];
                    if([clipUrl length] > 0){
                        [images addObject:clipUrl];
                    }
                }
                
                m.images = images;
                [gameInstance.movies addObject:m];
                
                self.moviesDownloaded++;
                
                
                if((int)self.moviesDownloaded == (int)self.boxOfficeLimit ){
                    NSLog(@"video %lul of %lul", (unsigned long)self.moviesDownloaded, (unsigned long)self.boxOfficeLimit);
                    return gameMovies;
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Loading" message:@"Sorry, the data that is needed for this game is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alert show];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // failure logic
        NSLog(@"Error: %@", error);
    }];
    
    
}


@end

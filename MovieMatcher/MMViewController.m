//
//  MMViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "MMMovie.h"
#import "MMGame.h"

#define APIKEY @"af46uut8ma9y77atkyzxbwnp";
#define BASE_URL "http://api.rottentomatoes.com/api/public/v1.0/";

#define BOX_OFFICE_MOVIE_LIMIT 5;

@interface MMViewController ()

@property (nonatomic) NSInteger moviesCount;
@property (nonatomic) NSInteger movieLimit;
@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviesCount = 0;
    self.movieLimit = 5;
    
    [self loadModel];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) loadModel{

    NSDictionary *params = @{@"limit": @5, @"country" :@"us", @"apikey": @"af46uut8ma9y77atkyzxbwnp"};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // GET BOX OFFICE MOVIES
    [manager GET:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Box office Movies Recieved");
        
        NSMutableArray *movies = responseObject[@"movies"];
        
        NSMutableArray *gameMovies;
        
        for (NSDictionary *movie in movies) {
            MMMovie *m = [[MMMovie alloc] init];
            m.movieId = [[movie valueForKey:@"id"] integerValue];
            m.title = movie[@"title"];
            
            // GET images for each movie
            NSString *clipsUrl = [NSString stringWithFormat:@"%@%u%@",
                                  @"http://api.rottentomatoes.com/api/public/v1.0/movies/",
                                  m.movieId,
                                  @"/clips.json"];
            
            NSDictionary *clipParams = @{@"apikey":@"af46uut8ma9y77atkyzxbwnp"};
            
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
                [gameMovies addObject:m];
                
                self.moviesCount++;
                NSLog(@"video %u of %i", self.moviesCount, 5);
                
                if(self.moviesCount == 5){
                    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

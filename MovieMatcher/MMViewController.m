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
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviesCount = 0;
    self.movieLimit = 5;
    self.startGameButton.hidden = YES;
    
    [self loadModel];
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

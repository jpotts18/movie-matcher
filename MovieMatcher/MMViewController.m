//
//  MMViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/5/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMViewController.h"
#import "MMLoader.h"

#define APIKEY @"af46uut8ma9y77atkyzxbwnp";
#define BASE_URL "http://api.rottentomatoes.com/api/public/v1.0/";

#define BOX_OFFICE_MOVIE_LIMIT 5;

@interface MMViewController ()

@property (nonatomic) NSInteger moviesCount;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@end

@implementation MMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviesCount = 0;
    self.startGameButton.hidden = YES;
    
    MMLoader *loader = [[MMLoader alloc] init];
    loader.delegate = self;
    
    [loader loadModel];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadingCompleted{
    
    self.loadingLabel.hidden = YES;
    self.startGameButton.hidden = NO;
    
}

@end

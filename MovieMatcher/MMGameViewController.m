//
//  MMGameViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGameViewController.h"
#import "MMGame.h"

@interface MMGameViewController ()

@property (strong, nonatomic) MMGame *gameInstance;

@end

@implementation MMGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameInstance = [MMGame sharedInstance];
    
    NSLog(@"Game for %@ at difficulty %lu", self.gameInstance.username, (unsigned long)self.gameInstance.difficulty);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

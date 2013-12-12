//
//  MMGameViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGameViewController.h"
#import "MMGame.h"
#import "MMMovie.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MMGameViewController ()

@property (strong, nonatomic) MMGame *gameInstance;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger countDownTimerSeconds;
@property (nonatomic) NSInteger pointsAvailable;
@property (nonatomic) MMMovie *currentMovie;
@property (nonatomic) NSString *currentImageUrl;

@end

@implementation MMGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentIndex = 0;
    
    self.gameInstance = [MMGame sharedInstance];
    [self.gameInstance initializeNewGame];
    [self nextMovie];

    NSLog(@"Game for %@ at difficulty %lu", self.gameInstance.username, (unsigned long)self.gameInstance.difficulty);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) nextMovie{
    
    if(self.currentIndex < [self.gameInstance.gameMovies count]){
        self.currentMovie = [self.gameInstance.gameMovies objectAtIndex:self.currentIndex];
        self.currentIndex++;
        [self nextImage];
    } else {
        NSLog(@"Game Over");
    }
}

- (void) nextImage{
    NSUInteger randomImageIndex = arc4random() % [self.currentMovie.images count];
    self.currentImageUrl = [self.currentMovie.images objectAtIndex:randomImageIndex];
    [self.movieImageView setImageWithURL:[NSURL URLWithString:self.currentImageUrl]
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//         [self startTimer];
         
         [self performSelector:@selector(startTimer) withObject:nil afterDelay:2.0];
     }];
}

- (void) startTimer {
    self.countDownTimerSeconds = 10;
    self.pointsAvailable = 1000;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
}

- (void) timerTick {
    
    self.pointsAvailable--;
    
    if (self.pointsAvailable % 100 == 0) {
      self.countDownTimerSeconds--;
    }
    
    if(self.countDownTimerSeconds == 0){
        NSLog(@"Game Over Dude!!");
        [self stopTimer];
    }
    
    NSString *pointsValue = [NSString stringWithFormat:@"%ldpts", self.pointsAvailable];
    self.pointsLabel.text = pointsValue;
    
    NSString *timerValue = [NSString stringWithFormat:@"00:%02ld", (long)self.countDownTimerSeconds];
    self.timerLabel.text = timerValue;
    
}
- (void) stopTimer {
    [self.countDownTimer invalidate];
    self.countDownTimerSeconds = 10;
    NSString *timerValue = [NSString stringWithFormat:@"00:%02ld", (long)self.countDownTimerSeconds];
    self.timerLabel.text = timerValue;
}

@end

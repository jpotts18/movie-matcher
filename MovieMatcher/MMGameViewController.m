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
@property (weak, nonatomic) IBOutlet UIView *scoreContainer;
@property (weak, nonatomic) IBOutlet UILabel *gameScoreTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;


@property (nonatomic) NSInteger totalGameScore;
@property (nonatomic) NSInteger numberCorrect;
@property (nonatomic) NSInteger numberInorrect;


@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger countDownTimerSeconds;
@property (nonatomic) NSInteger pointsAvailable;
@property (nonatomic) MMMovie *currentMovie;
@property (nonatomic) NSString *currentImageUrl;
@property (strong, nonatomic) NSMutableArray *currentMovieAnswers;

@end

@implementation MMGameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentIndex = 0;
    self.totalGameScore = 0;
    
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
        [self nextAnswerSet];
    } else {
        NSLog(@"Game Over");
    }
}

- (void) nextImage{
    NSUInteger randomImageIndex = arc4random() % [self.currentMovie.images count];
    self.currentImageUrl = [self.currentMovie.images objectAtIndex:randomImageIndex];
    [self.movieImageView setImageWithURL:[NSURL URLWithString:self.currentImageUrl]
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
         [self performSelector:@selector(startTimer) withObject:nil afterDelay:2.0];
     }];
}

- (void) nextAnswerSet{
    
    self.currentMovieAnswers = [self.gameInstance randomMovieAnswersBy:self.currentMovie];
    
    MMMovie *firstMovie = [self.currentMovieAnswers objectAtIndex:0];
    MMMovie *secondMovie = [self.currentMovieAnswers objectAtIndex:1];
    MMMovie *thirdMovie = [self.currentMovieAnswers objectAtIndex:2];
    MMMovie *fourthMovie = [self.currentMovieAnswers objectAtIndex:3];
    
    [self.firstButton setTitle:firstMovie.title forState:UIControlStateNormal];
    [self.secondButton setTitle:secondMovie.title forState:UIControlStateNormal];
    [self.thirdButton setTitle:thirdMovie.title forState:UIControlStateNormal];
    [self.fourthButton setTitle:fourthMovie.title forState:UIControlStateNormal];
    
}

- (void) nextImageForCurrentMovie{
    
    NSUInteger randomNumber = arc4random() % [self.currentMovie.images count];
    NSString *randomImageFromMovie = [self.currentMovie.images objectAtIndex:randomNumber];
    
    [self.movieImageView setImageWithURL:[NSURL URLWithString:randomImageFromMovie]];
    
}

- (void) guessBy:(NSInteger)index{
    
    MMMovie *guessedMovie = [self.currentMovieAnswers objectAtIndex:index];
    if (guessedMovie.movieId == self.currentMovie.movieId){
        [self correctAnswer];
    } else {
        [self incorrectAnswer];
    }
    
}

- (void) correctAnswer{
    
    self.totalGameScore = self.totalGameScore + self.pointsAvailable;
    self.gameScoreTotalLabel.text = [NSString stringWithFormat:@"Score: %ld pts",(long)self.totalGameScore];
    
    [self stopTimer];
    [self nextMovie];
    
}

- (void) incorrectAnswer{
    NSLog(@"You chose incorrectly");
}



#pragma button taps

- (IBAction)firstButtonGuess:(id)sender {
    [self guessBy:0];
    
}
- (IBAction)secondButtonGuess:(id)sender {
    [self guessBy:3];
    
}
- (IBAction)thirdButtonGuess:(id)sender {
    [self guessBy:2];
    
}
- (IBAction)fourtButtonGuess:(id)sender {
    [self guessBy:3];
    
}

#pragma Timer section

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
    
    if (self.pointsAvailable % 250 == 0){
        [self nextImageForCurrentMovie];
    }
    
    if(self.countDownTimerSeconds == 0){
        NSLog(@"Game Over Dude!!");
        [self stopTimer];
    }
    
    NSString *pointsValue = [NSString stringWithFormat:@"%ldpts", self.pointsAvailable];
    self.pointsLabel.text = pointsValue;
    
}
- (void) stopTimer {
    [self.countDownTimer invalidate];
    self.countDownTimerSeconds = 10;
    self.pointsAvailable = 1000;
    
    [self nextMovie];
    
}

@end

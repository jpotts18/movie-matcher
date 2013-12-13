//
//  MMGameViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/11/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGameViewController.h"
#import "MMGame.h"
#import "MMGameRound.h"
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
@property (nonatomic) BOOL gameIsOver;

@property (strong, nonatomic) NSTimer *countDownTimer;
@property (nonatomic) NSInteger pointsCount;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) MMMovie *currentMovie;
@property (nonatomic) MMGameRound *gameRound;
@property (nonatomic) NSString *currentImageUrl;
@property (strong, nonatomic) NSMutableArray *currentMovieAnswers;

@end

@implementation MMGameViewController


- (void) viewDidLoad {
    [super viewDidLoad];

    self.gameInstance = [MMGame sharedInstance];
    [self.gameInstance initializeNewGame];
    
    [self initializeGame];
    [self nextMovie];

    NSLog(@"Game for %@ at difficulty %lu", self.gameInstance.username, (unsigned long)self.gameInstance.difficulty);
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) nextMovie {

    self.currentIndex++;
    
    if(self.currentIndex < [self.gameInstance.gameMovies count]){
        self.currentMovie = [self.gameInstance.gameMovies objectAtIndex:self.currentIndex];
        [self nextImage];
        [self startTimer];
        [self nextAnswerSet];
    } else {
        self.gameIsOver = YES;
        [self gameOver];
    }
}


#pragma Game Over

- (void) gameOver{
    [self disableButtons];
    [self stopTimer];
    [self saveRound];
    [self launchGameOver];
}

- (void) saveRound {
    [self.countDownTimer invalidate];
    
    MMGameRound *currentGameRound = [[MMGameRound alloc] init];
    
    currentGameRound.numberCorrect = self.numberCorrect;
    currentGameRound.numberInorrect = self.numberInorrect;
    currentGameRound.totalGameScore = self.totalGameScore;
    currentGameRound.username = self.gameInstance.username;
    currentGameRound.finishDate = [NSDate date];
    
    [self.gameInstance.rounds addObject:currentGameRound];
}

- (void) initializeGame {
    
    self.currentIndex = -1;
    self.totalGameScore = 0;
    self.numberCorrect = 0;
    self.numberInorrect = 0;
    self.gameIsOver = NO;
    
    self.pointsLabel.text = @"0pts";
    
    [self enableButtons];
    
    [self.gameInstance initializeNewGame];
}

- (void) nextImage {
    NSUInteger randomImageIndex = arc4random() % [self.currentMovie.images count];
    self.currentImageUrl = [self.currentMovie.images objectAtIndex:randomImageIndex];
    [self.movieImageView setImageWithURL:[NSURL URLWithString:self.currentImageUrl]];
}

- (void) nextAnswerSet {
    
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

- (void) nextImageForCurrentMovie {
    
    NSUInteger randomNumber = arc4random() % [self.currentMovie.images count];
    self.currentImageUrl = [self.currentMovie.images objectAtIndex:randomNumber];
    [self.movieImageView setImageWithURL:[NSURL URLWithString:self.currentImageUrl]];
    
}

- (void) guessAtIndex:(NSInteger)index {
    
    MMMovie *guessedMovie = [self.currentMovieAnswers objectAtIndex:index];
    
    if (guessedMovie.movieId == self.currentMovie.movieId){
        [self correctAnswer];
        self.numberCorrect++;
    } else {
        [self incorrectAnswerAtIndex:index];
        self.numberInorrect++;
    }
    
}

- (void) correctAnswer {
    
    self.totalGameScore += self.pointsCount;
    [self stopTimer];
    
    self.gameScoreTotalLabel.text = [NSString stringWithFormat:@"Score: %ldpts",(long)self.totalGameScore];
    
    [self nextMovie];
    [self resetButtonState];

    
    self.numberCorrect++;
    
}

- (void) incorrectAnswerAtIndex:(NSInteger)index {
    
    if(index == 0){
        self.firstButton.hidden = YES;
    }
    if(index == 1){
        self.secondButton.hidden = YES;
    }
    if(index == 2){
        self.thirdButton.hidden = YES;
    }
    if(index == 3){
        self.fourthButton.hidden = YES;
    }
    self.numberInorrect++;
}

#pragma Buttons

- (void) resetButtonState {
    self.firstButton.hidden = NO;
    self.secondButton.hidden = NO;
    self.thirdButton.hidden = NO;
    self.fourthButton.hidden = NO;
}

- (void) disableButtons {
    self.firstButton.enabled = NO;
    self.secondButton.enabled = NO;
    self.thirdButton.enabled = NO;
    self.fourthButton.enabled = NO;
}
- (void) enableButtons {
    self.firstButton.enabled = YES;
    self.secondButton.enabled = YES;
    self.thirdButton.enabled = YES;
    self.fourthButton.enabled = YES;
}

- (IBAction)firstButtonGuess:(id)sender {
    [self guessAtIndex:0];
}
- (IBAction)secondButtonGuess:(id)sender {
    [self guessAtIndex:1];
}
- (IBAction)thirdButtonGuess:(id)sender {
    [self guessAtIndex:2];
}
- (IBAction)fourtButtonGuess:(id)sender {
    [self guessAtIndex:3];
}

#pragma Timer Section

- (void) startTimer {
    self.pointsCount = 1000;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
}

- (void) timerTick {
    
    self.pointsCount--;
    
    if (self.pointsCount % 250 == 0){
        [self nextImageForCurrentMovie];
    }
    
    
    if(self.gameIsOver == YES){
        [self stopTimer];
    }
    
    // Out of time
    if (self.pointsCount == 0){
        [self nextMovie];
    }
    
    NSString *pointsValue = [NSString stringWithFormat:@"%ldpts", self.pointsCount];
    self.pointsLabel.text = pointsValue;
    
}

- (void) stopTimer {
    [self.countDownTimer invalidate];
    self.pointsCount = 1000;
    self.pointsLabel.text = [NSString stringWithFormat:@"%ldpts", self.pointsCount];
}

#pragma alertView

- (void) launchGameOver {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nice Job!"
                                                      message:[NSString stringWithFormat:@"You scored %ldpts this round! Would you like to play again?",self.totalGameScore]
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self initializeGame];
    [self nextMovie];
}

@end

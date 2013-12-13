//
//  MMGameSetupViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/10/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMGameSetupViewController.h"
#import "MMGame.h"

@interface MMGameSetupViewController ()

@property (strong, nonatomic) MMGame *gameInstance;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *difficultySegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *difficultyErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameErrorLabel;

@end

@implementation MMGameSetupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usernameTextField.text = [defaults objectForKey:@"username"];
//    self.difficultySegmentControl
    
    self.gameInstance = [MMGame sharedInstance];
    
    self.usernameErrorLabel.hidden = YES;
    self.difficultyErrorLabel.hidden = YES;
    [self.difficultySegmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    

    
	// Do any additional setup after loading the view.
}

#pragma UITextField Delegate Implementation

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField.text.length == 0){
        self.usernameErrorLabel.hidden = YES;
    }
    return YES;
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Textfield finished with value -> %@", textField.text);
    self.gameInstance.username = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isFirstResponder]){
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma Actions

- (IBAction)startMatchingButtonTapped:(id)sender {
    
    NSInteger errorCount = 0;
    
    if(self.usernameTextField.text.length == 0){
        errorCount++;
        self.usernameErrorLabel.hidden = NO;
    }
    
    if([self.difficultySegmentControl selectedSegmentIndex] == -1){
        errorCount++;
        self.difficultyErrorLabel.hidden = NO;
    } else {
        self.gameInstance.difficulty = [self.difficultySegmentControl selectedSegmentIndex];
    }
    
    if(errorCount == 0){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.usernameTextField.text forKey:@"username"];
        [defaults synchronize];
        
        [self performSegueWithIdentifier:@"StartMatchingSegue" sender:self];
    } 
    
    
}
- (IBAction)valueChanged:(id)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    
    if([segmentedControl selectedSegmentIndex] != -1){
        self.difficultyErrorLabel.hidden = YES;
    }
    
}

@end

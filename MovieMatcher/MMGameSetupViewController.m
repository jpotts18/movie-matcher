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

@end

@implementation MMGameSetupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.difficultySegmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    self.gameInstance = [MMGame sharedInstance];
    
	// Do any additional setup after loading the view.
}

#pragma UITextField Delegate Implementation

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

#pragma UIView Actions

- (IBAction)startMatchingButtonTapped:(id)sender {
    if(self.usernameTextField.text.length == 0){
        NSLog(@"username not found");
        
    } else if([self.difficultySegmentControl selectedSegmentIndex] == -1){
        NSLog(@"difficulty was not selected");
    } else {
        self.gameInstance.difficulty = [self.difficultySegmentControl selectedSegmentIndex];
    }
    
    
}

@end

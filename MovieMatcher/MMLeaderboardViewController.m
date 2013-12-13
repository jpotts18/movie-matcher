//
//  MMLeaderboardViewController.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/12/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMLeaderboardViewController.h"
#import "MMGame.h"
#import "MMRoundCell.h"

@interface MMLeaderboardViewController ()

@property (nonatomic, strong) MMGame *gameInstance;

@end

@implementation MMLeaderboardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameInstance = [MMGame sharedInstance];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.gameInstance.rounds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RoundCell";
    MMRoundCell *cell = (MMRoundCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell updateWithRound:[self.gameInstance.rounds objectAtIndex:indexPath.row]];
    
    return cell;
}

@end

//
//  MMRoundCell.m
//  MovieMatcher
//
//  Created by Jeff Potter on 12/12/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import "MMRoundCell.h"
#import "MMGameRound.h"

@interface MMRoundCell()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyLabel;

@end

@implementation MMRoundCell


- (void) updateWithRound:(MMGameRound *)round{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:round.finishDate];
    
    self.usernameLabel.text = round.username;
    self.dateLabel.text = stringFromDate;
    self.pointsLabel.text = [NSString stringWithFormat:@"%ld", (long)round.totalGameScore];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%ld",(long)round.accuracy];
    
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

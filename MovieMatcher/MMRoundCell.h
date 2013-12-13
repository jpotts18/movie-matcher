//
//  MMRoundCell.h
//  MovieMatcher
//
//  Created by Jeff Potter on 12/12/13.
//  Copyright (c) 2013 Jeff Potter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMGameRound;

@interface MMRoundCell : UITableViewCell

- (void) updateWithRound:(MMGameRound *)round;

@end

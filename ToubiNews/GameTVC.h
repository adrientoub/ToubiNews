//
//  GameTVC.h
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* gamesArray;

- (void)getGames;
- (void)parseGames:(NSArray*)jsonArray;

@end

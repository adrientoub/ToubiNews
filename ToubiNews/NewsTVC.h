//
//  GameTVC.h
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* newsArray;

- (void)getNews;
- (void)parseNews:(NSArray*)jsonArray;

@end

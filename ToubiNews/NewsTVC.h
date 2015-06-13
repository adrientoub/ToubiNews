//
//  GameTVC.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* newsArray;
@property (nonatomic, strong) NSMutableArray* searchArray;
@property (nonatomic, strong) NSString* newsgroup;
@property (nonatomic, assign) int topicNb;
@property (atomic, assign) BOOL updating;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)getNews;
- (void)parseNews:(NSArray*)jsonArray isSearch:(BOOL)search;
- (void)loadJSON:(NSString*)strURL isSearch:(BOOL)search;

@end

//
//  GameTVC.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentNewsTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* newsArray;
@property (atomic, assign) BOOL updating;

- (void)getNews;
- (void)parseNews:(NSArray*)jsonArray;
- (void)loadJSON:(NSString*)strURL;

@end

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
@property (nonatomic, strong) NSString* newsgroup;

- (void)getNews;
- (void)parseNews:(NSArray*)jsonArray;

@end
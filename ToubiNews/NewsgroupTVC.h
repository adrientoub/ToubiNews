//
//  NewsgroupTVC.h
//  ToubiNews
//
//  Created by Adrien on 08/06/15.
//  Copyright (c) 2015 Toub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsgroupTVC : UITableViewController

@property (nonatomic, strong) NSMutableArray* newsgroups;
@property (nonatomic, strong) NSMutableArray* searchArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)getNewsgroups;
- (void)fetchDatas:(NSArray*)jsonArray isSearch:(BOOL)search;

@end

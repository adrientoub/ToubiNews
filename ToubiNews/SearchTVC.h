//
//  SearchTVC.h
//  ToubiNews
//
//  Created by Adrien on 09/06/15.
//  Copyright © 2015 Toub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTVC : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSMutableArray* newsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

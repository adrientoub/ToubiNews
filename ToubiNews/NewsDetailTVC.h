//
//  NewsDetailTVC.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 03/05/2016.
//  Copyright © 2016 Toub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailTVC : UITableViewController

@property (nonatomic, strong) News* news;
@property (nonatomic, strong) NSMutableArray* newsList;

@end

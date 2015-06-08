//
//  GameDetailVC.h
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (nonatomic, strong) News* news;

@end

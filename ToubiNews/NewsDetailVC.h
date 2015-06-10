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
@property (weak, nonatomic) IBOutlet UIWebView *newsContent;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (nonatomic, strong) News* news;

@end

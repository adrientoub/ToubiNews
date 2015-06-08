//
//  GameDetailVC.h
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GameDetailVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idObj;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic, strong) Game* game;

@end

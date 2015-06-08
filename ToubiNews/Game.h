//
//  Game.h
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

@property (nonatomic, assign) int iId;
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSString* subject;

@end

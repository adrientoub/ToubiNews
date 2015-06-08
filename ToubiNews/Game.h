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
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* smallImageURL;
@property (nonatomic, strong) NSString* bigImageURL;
@property (nonatomic, assign) int iScore;

+(id) fakeNews;

@end

//
//  Game.m
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import "Game.h"

@implementation Game

-(id) initGameWithId:(int)idG andName:(NSString*)name
{
    self = [super init];
    self.iId = idG;
    self.name = name;
    return self;
}
+(id) fakeNews
{
    Game* game = [[Game alloc] initGameWithId:arc4random() andName:[NSString stringWithFormat:@"Name %d", arc4random()]];
    game.iScore = arc4random() % 10;
    game.smallImageURL = @"";
    game.bigImageURL = @"http://www.ac-grenoble.fr/ien.vienne1-2/spip/IMG/bmp_chateau.bmp";
    return game;
}
@end

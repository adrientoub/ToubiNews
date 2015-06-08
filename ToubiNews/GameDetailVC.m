//
//  GameDetailVC.m
//  GameCritic
//
//  Created by Guest User on 08/06/15.
//  Copyright (c) 2015 3IE. All rights reserved.
//

#import "GameDetailVC.h"

@interface GameDetailVC ()

@end

@implementation GameDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.name setText:[self.game name]];
    [self.idObj setText:[NSString stringWithFormat:@"%d", self.game.iId]];
    [self.score setText:[NSString stringWithFormat:@"%d", self.game.iScore]];
    
    NSURL *url = [NSURL URLWithString: [self.game bigImageURL]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self.image setImage:[UIImage imageWithData:data]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

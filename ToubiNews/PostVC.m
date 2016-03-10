//
//  PostVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 10/03/2016.
//  Copyright © 2016 Toub. All rights reserved.
//

#import "PostVC.h"

@interface PostVC ()

@end

@implementation PostVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self performSegueWithIdentifier:@"loginSegue"
                            sender:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end

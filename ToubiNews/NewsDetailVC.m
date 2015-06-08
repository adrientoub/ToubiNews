//
//  GameDetailVC.m
//  ToubiNews
//
//  Created by Adrien Toubiana on 08/06/15.
//  Copyright (c) 2015 ToubInc. All rights reserved.
//

#import "NewsDetailVC.h"

@interface NewsDetailVC ()

@end

@implementation NewsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.subject setText:[self.news subject]];
    [self.author setText:[self.news author]];
    [self getNewsDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayError
{
}

- (void)getNewsDetails
{
  NSString* strURL = [NSString stringWithFormat:@"https://42portal.com/ng-notifier/api/topic/%d", [self.news iId]];
  NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
  NSURLSession *session = [NSURLSession sharedSession];
  [[session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                            NSURLResponse *response, NSError *error)
    {
      NSError* jsonError;
      if (!error && [response isKindOfClass:[NSHTTPURLResponse class]] &&
          ((NSHTTPURLResponse *)response).statusCode == 200)
      {
        NSDictionary *arrayJson = [NSJSONSerialization JSONObjectWithData: data
                                                             options: NSJSONReadingMutableContainers error: &jsonError];
        if ([arrayJson count] == 0)
        {
          [self displayError];
        }
        else
        {
          if (!jsonError)
          {
            //6
            [self fetchDatas:arrayJson];
          }
          else
          {
            NSLog(@"json convertion error");
          }
        }
      }
      else
      {
        [self displayError];
      }
    }] resume];
}

- (void)fetchDatas:(NSDictionary*)jsonArray
{
  NSLog(@"JSON: %@", jsonArray);
  dispatch_async(dispatch_get_main_queue(), ^{
    [self parseNews:jsonArray];
  });
}

- (void)parseNews:(NSDictionary*)jsonArray
{
  [self.content setText: [jsonArray objectForKey:@"content"]];
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
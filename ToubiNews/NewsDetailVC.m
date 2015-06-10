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
    NSString* formatedOutput = [NSString stringWithFormat:@"<h1>%@</h1><h2>%@</h2><p>Loading</p>",
                              [self.news subject],
                              [self.news author]];
    [self.newsContent loadHTMLString:formatedOutput baseURL:nil];
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
    [self parseJSON:jsonArray];
  });
}

-(NSString*)nl2br:(NSString*)content
{
  return [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>\n"];
}

-(NSString*)parseNews: (NSDictionary*)jsonArray
{
  NSString* formatedOutput = [NSString stringWithFormat:@"<h1>%@</h1><h2>%@</h2><p>%@</p>",
                              [jsonArray objectForKey:@"subject"],
                              [jsonArray objectForKey:@"author"],
                              [self nl2br:[jsonArray objectForKey:@"content"]]];
  NSArray* children = [jsonArray objectForKey:@"children"];
  for (NSDictionary* news in children)
  {
    formatedOutput = [NSString stringWithFormat:@"%@ %@", formatedOutput, [self parseNews:news]];
  }

  return formatedOutput;
}

- (void)parseJSON:(NSDictionary*)jsonArray
{
  NSString* formatedOutput = [self parseNews:jsonArray];
  [self.newsContent loadHTMLString:formatedOutput baseURL:nil];
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

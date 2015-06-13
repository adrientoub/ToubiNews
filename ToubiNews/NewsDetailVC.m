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
  NSString* formatedOutput = [self createOutput: self.news.subject
                                         author: self.news.author
                                        content: @"Loading"];
  NSString* path = [[NSBundle mainBundle] bundlePath];
  NSURL* baseURL = [NSURL fileURLWithPath:path];
  [self.newsContent loadHTMLString:formatedOutput baseURL:baseURL];
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
        if (!jsonError)
        {
          [self fetchDatas:arrayJson];
        }
        else
        {
          NSLog(@"json convertion error");
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
  return [[[content stringByReplacingOccurrencesOfString:@"<"
                                              withString:@"&lt;"]
           stringByReplacingOccurrencesOfString:@">"
                                     withString:@"&gt;"]
          stringByReplacingOccurrencesOfString:@"\n"
          withString:@"<br>\n"];

}

-(NSString*)createOutput:(NSString*)title author:(NSString*)author content:(NSString*)content
{
  NSString* bodystyle = @"background-color: #EDEDED;";
  NSString* h1style = @"font-size:30px;";
  NSString* h2style = @"font-size:20px; color: #4A4A4A; text-align: center;";
  NSString* pstyle = @"font-size:18px;text-align:left;";
  NSString* hrstyle = @"width:50%; border-style: solid; border-width: 3px;";
  NSString* html = @"<body style=\"%@\"><h1 style=\"%@\"><center>%@</center></h1>\n<h2 style=\"%@\">%@</h2><hr style=\"%@\"/>\n<p style=\"%@\">%@</p>";
  return [NSString stringWithFormat: html, bodystyle, h1style, title, h2style, author, hrstyle, pstyle, content];
}

-(NSString*)parseNews: (NSDictionary*)jsonArray
{
  NSString* formatedOutput = [self createOutput:[self nl2br:[jsonArray objectForKey:@"subject"]]
                                         author:[self nl2br:[jsonArray objectForKey:@"author"]]
                                        content:[self nl2br:[jsonArray objectForKey:@"content"]]];
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
  NSLog(@"%@", formatedOutput);
  NSString* path = [[NSBundle mainBundle] bundlePath];
  NSURL* baseURL = [NSURL fileURLWithPath:path];
  [self.newsContent loadHTMLString:formatedOutput baseURL:baseURL];
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
